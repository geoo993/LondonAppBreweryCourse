//
//  UserService.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 05/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift

public extension HasMarksService {
    public static var marksService: MarksService {
        return RealmMarksService()
    }
}

public protocol MarksService {
    func addSubjectMark(name: String, mark: String) throws
    func getSubjectMarks(key: String) throws -> Results<RealmSubjectMark>
}

public protocol HasMarksService {
    static var marksService: MarksService { get }
}

public class RealmMarksService: MarksService {

    private typealias Constants = RealmServerConfig.Constants
    private static var key: String = ""

    private var marksRealm: Realm? {
        guard let syncUser = SyncUser.current else { return nil }
        let subjectConfig = RealmConfig.marks(user: syncUser, key: RealmMarksService.key).configuration
        guard let realm = try? Realm(configuration: subjectConfig) else { return nil }
        return realm
    }

    public init() { }

    public func addSubjectMark(name: String, mark: String) throws {
        guard let realm = marksRealm else { throw RealmError.marksRealmUnavailable }
        let subjectMark = RealmSubjectMark(name: name, mark: mark)
        try realm.write {
            realm.add(subjectMark)
        }
    }

    public func getSubjectMarks(key: String) throws -> Results<RealmSubjectMark> {
        RealmMarksService.key = key
        guard let realm = marksRealm else { throw RealmError.marksRealmUnavailable }
        return realm.objects(RealmSubjectMark.self)
    }
}
