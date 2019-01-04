//
//  RealmUserService.swift
//  StoryRealm
//
//  Created by Daniel Asher on 22/05/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import RxSwift
import RxCocoa
import RealmSwift

public protocol HasUserService {
    static var userService: UserService { get }
}

public extension HasUserService {
    public static var userService: UserService {
        return RealmUserService()
    }
}

public protocol UserService {

    func authUser(name: String) -> Single<RealmApp>
    func createDefaultUser() throws -> RealmUser
    func defaultUser() throws -> RealmUser
    func addUser(name: String) throws -> RealmUser
    func add(messages: [RealmMessage]) throws
    func post(message: String) throws -> RealmMessage
    func didSendMessage(uuid: String) throws

    func addExam(subject: RealmSubject, date: Date) throws
    func getExams() throws -> Results<RealmExam>
}


public class RealmUserService: UserService {
  
    private typealias Constants = RealmServerConfig.Constants

    private var currentApp: RealmApp? {
        guard let syncUser = SyncUser.current, let uuid = syncUser.identity else { return nil }
        let userConfig = RealmConfig.user(user: syncUser).configuration
        guard let userRealm = try? Realm(configuration: userConfig) else { return nil }
        return userRealm.object(ofType: RealmApp.self, forPrimaryKey: uuid)
    }

    public init() {}

    /*
     Note that the factory method takes a register boolean argument that indicates whether a new user should be registered or an existing user should be logged in. An error will be thrown if your application tries to register a new user with the username of an existing user, or tries to log in a user that does not exist.


     */
    private func login(username: String, password: String,
                       register: Bool, retryAttempts: Int = 1) -> Single<SyncUser> {
        return Single<SyncUser>.create { single -> Disposable in
            let creds = SyncCredentials.usernamePassword(username: username, password: password, register: register)
            SyncUser.all.forEach({ _, user in user.logOut() })
            SyncUser.logIn(with: creds, server: Constants.AUTH_URL, timeout: 2) { user, error in
                guard let user = user else {
                    if let error = error { print("❗️ \(error)") }
                    single(.error(RealmError.loginTimeout(error)))
                    return
                }
                single(.success(user))
            }
                return Disposables.create()
            }
            .retry(retryAttempts)
    }

    private func login(nickName: String, retryAttempts: Int = 1) -> Single<SyncUser> {
        return Single<SyncUser>.create { single -> Disposable in
            let creds = SyncCredentials.nickname(nickName, isAdmin: false)
            SyncUser.all.forEach({ _, user in user.logOut() })
            SyncUser.logIn(with: creds, server: RealmServerConfig.Constants.AUTH_URL,
                           timeout: 2, onCompletion: { user, error in
                guard let user = user else {
                    if let error = error { print("❗️ \(error)") }
                    single(.error(RealmError.loginTimeout(error)))
                    return
                }
                single(.success(user))
            })
                return Disposables.create()
            }
            .retry(retryAttempts)
    }

    private func loginUser(username: String, password: String, register: Bool, retryAttempts: Int = 1) -> Single<RealmApp> {
        return Single<RealmApp>.create { single -> Disposable in
            return self.login(username: username, password: password, register: register, retryAttempts: retryAttempts)
                .flatMap({ user -> Single<(SyncUser, Realm)> in
                    let userConfig = RealmConfig.user(user: user).configuration
                    return RealmConfig.asyncOpen(configuration: userConfig).map { (user, $0) }
                })
                .subscribe(onSuccess: { user, realm in

                    if let uuid = user.identity {
                        do {
                            if let app = realm.object(ofType: RealmApp.self, forPrimaryKey: uuid) {
                                single(.success(app))
                            } else {
                                let app = RealmApp(uuid: uuid, name: username, password: password)
                                try realm.write {
                                    realm.add(app)
                                    single(.success(app))
                                }
                            }
                        } catch let error {
                            single(.error(RealmError.writeAppError(error)))
                        }
                    }
                }, onError: { error in
                    single(.error(error))
                })
            }
            .retry(retryAttempts)
    }

    public func authUser(name: String) -> Single<RealmApp> {
        return loginUser(username: name, password: name, register: true)
            .catchError({ [unowned self] (error) -> Single<RealmApp> in
                return self.loginUser(username: name, password: name, register: false)
            })
    }

    public func addUser(name: String) throws -> RealmUser {
        guard let app = currentApp else { throw RealmError.currentAppInvalid }
        guard let realm = app.realm else { throw RealmError.userRealmUnavailable }

        if let user = realm.objects(RealmUser.self).first(where: { $0.name == name }) {
            app.defaultUser = user.uuid
            return user
        } else {
            let user = RealmUser(name: name)

            func setUser() {
                app.defaultUser = user.uuid
                realm.add(user)
                app.users.append(user)
            }

            if realm.isInWriteTransaction {
                setUser()
            } else {
                try realm.write {
                    setUser()
                }
            }
            return user
        }
    }

    // MARK: - Chatter
    public func createDefaultUser() throws -> RealmUser {
        return try addUser(name: "me")
    }

    public func defaultUser() throws -> RealmUser {
        guard let app = currentApp else { throw RealmError.currentAppInvalid }
        guard let realm = app.realm else { throw RealmError.userRealmUnavailable }
        if let user = realm.object(ofType: RealmUser.self, forPrimaryKey: app.defaultUser ) {
            return user
        } else {
            return try createDefaultUser()
        }
    }

    public func add(messages: [RealmMessage]) throws {
        guard let app = currentApp else { throw RealmError.currentAppInvalid }
        guard let realm = app.realm else { throw RealmError.userRealmUnavailable }
        let me = try defaultUser()
        try! realm.write {
            for message in messages {
                me.messages.insert(message, at: 0)
            }
        }
    }

    public func post(message: String) throws -> RealmMessage {
        guard let app = currentApp else { throw RealmError.currentAppInvalid }
        guard let realm = app.realm else { throw RealmError.userRealmUnavailable }

        let user = try defaultUser()

        let new = RealmMessage(user: user, message: message)
        try! realm.write {
            user.outgoing.append(new)
        }
        return new
    }

    public func didSendMessage(uuid: String) throws {
        guard let app = currentApp else { throw RealmError.currentAppInvalid }
        guard let realm = app.realm else { throw RealmError.userRealmUnavailable }

        let user = try defaultUser()

        if let sentMessage = realm.object(ofType: RealmMessage.self, forPrimaryKey: uuid),
            let index = user.outgoing.index(of: sentMessage) {
            try! realm.write {
                user.outgoing.remove(at: index)
                user.messages.insert(sentMessage, at: 0)
                user.sent += 1
            }
        }
    }

    public func addExam(subject: RealmSubject, date: Date) throws {
        guard let app = currentApp else { throw RealmError.currentAppInvalid }
        guard let realm = app.realm else { throw RealmError.userRealmUnavailable }
        let justAddedText = "just added"
        let exam = RealmExam(subject: subject.uuid, date: date)
        if let justAdded = realm.objects(RealmStatus.self).filter("status == %@", justAddedText).first {
            exam.statuses.append(justAdded)
        } else {
            exam.statuses.append(RealmStatus(status: justAddedText))
        }

        try realm.write {
            realm.add(exam)
        }

    }


    public func getExams() throws -> Results<RealmExam> {
        guard let app = currentApp else { throw RealmError.currentAppInvalid }
        guard let realm = app.realm else { throw RealmError.userRealmUnavailable }
        return realm.objects(RealmExam.self)
          .sorted(byKeyPath: "date", ascending: false)
    }

}
