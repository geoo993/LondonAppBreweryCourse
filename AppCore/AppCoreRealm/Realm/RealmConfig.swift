/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import RxSwift
import RealmSwift
import CryptoSwift

public enum RealmConfig {
    private typealias Constants = RealmServerConfig.Constants
    // MARK: - enum cases
    case user(user: SyncUser)
    case subjects(user: SyncUser)
    case marks(user: SyncUser, key: String)

  // MARK: - current configuration
  var configuration: Realm.Configuration {
    switch self {
    case .user(let user):
      return RealmConfig.getUserConfig(user: user)
    case .subjects(let user):
        return RealmConfig.getSubjectsConfig(user: user)
    case .marks(let user, let key):
        return RealmConfig.getMarksConfig(user: user, key: key)
    }
  }

    private static func getUserConfig(user: SyncUser) -> Realm.Configuration {
        var config = user.configuration(
            realmURL: Constants.USER_URL,
            fullSynchronization: true,
            enableSSLValidation: false)
        config.objectTypes = RealmUserSchema.objectTypes
        config.migrationBlock = RealmConfig.migrate
        return config
    }

    private static func getSubjectsConfig(user: SyncUser) -> Realm.Configuration {
        var config = user.configuration(
            realmURL: Constants.SUBJECTS_URL,
            fullSynchronization: true,
            enableSSLValidation: false)
        config.objectTypes = RealmSubjectsSchema.objectTypes
        return config
    }

    private static func getMarksConfig(user: SyncUser, key: String) -> Realm.Configuration {
        var config = user.configuration(
            realmURL: Constants.MARKS_URL,
            fullSynchronization: true,
            enableSSLValidation: false)
        config.objectTypes = RealmMarksSchema.objectTypes
        config.encryptionKey = key.data(using: .utf8)!.sha512()
        return config
    }

    public static func asyncOpen(configuration: Realm.Configuration) -> Single<Realm> {
        return Single<Realm>.create { (single) -> Disposable in
            SyncManager.shared.errorHandler = { err, _ in
                single(.error(err))
                SyncManager.shared.errorHandler = nil
            }
            Realm.asyncOpen(configuration: configuration, callback: { (realm, error) in
                if let error = error {
                    single(.error(error))
                } else if let realm = realm {
                    single(.success(realm))
                } else {
                    single(.error(RealmError.realmUnavailable(configuration)))
                }
            })
            return Disposables.create { }
            }
            .timeout(2, scheduler: MainScheduler.instance)
            .catchError { err in
                do {
                    let realm = try Realm(configuration: configuration)
                    return .just(realm)
                } catch let err {
                    fatalError("\(err)")
                }
        }
    }




    // MARK: - migration helpers

    fileprivate static var migratedStatuses: [String: MigrationObject]?

    // MARK: - migration
    // https://medium.com/@shenghuawu/realm-lightweight-migration-4559b9920487
    // https://stackoverflow.com/questions/34891743/realm-migrations-in-swift
    static func migrate(_ migration: Migration, fileSchemaVersion: UInt64) {

        migratedStatuses = [:]

        if fileSchemaVersion == 1 {
            print("migrate from version 1")

            let now = Date()
            let thePast = Date(timeIntervalSince1970: 0)

            migration.enumerateObjects(ofType: "RealmExam", { oldObject, newObject in

                var statuses = [MigrationObject]()

                if let newObject = newObject {
                    if let date = newObject["date"] as? Date {

                        let statusText: String

                        if date.compare(now) == .orderedDescending {
                            statusText = "pending"
                        } else {
                            statusText = "completed"
                        }

                        let completeness = migration.create("RealmStatus",
                                                            value: ["status": statusText])
                        statuses.append(completeness)
                    }

                    newObject["icon"] = "🙈"

                    if let oldObject = oldObject,
                        let multi = oldObject["multipleChoice"] as? Bool, multi {
                        //newObject["name"] = "\(newObject["name"]!)(multiple choice)"
                        let multipleChoice = addOrReuseStatus(migration, text: "multiple choice")
                        statuses.append(multipleChoice)
                    }

                    // fix broken dates
                    if let date = newObject["date"] as? NSDate,
                        date.compare(thePast) == .orderedAscending {
                        newObject["date"] = now
                    }

                    newObject["statuses"] = statuses
                }
            })
        }

        if fileSchemaVersion == 2 {
            print("migrate from 2 to 3")

            migration.renameProperty(onType: "RealmExam", from: "emoji", to: "icon")

            migration.enumerateObjects(ofType: "RealmExam", { oldObject, newObject in
                if let newObject = newObject, let statusText = oldObject?["status"] as? String {
                    let completeness = addOrReuseStatus(migration, text: statusText)
                    newObject["statuses"] = [completeness]
                }
            })
        }

        migratedStatuses = nil
    }

    fileprivate static func addOrReuseStatus(_ migration: Migration, text: String) -> MigrationObject {
        if let existingStatus = migratedStatuses?[text] {
            return existingStatus
        } else {
            let status = migration.create("RealmStatus", value: ["status": text])
            migratedStatuses?[text] = status
            return status
        }
    }

}
