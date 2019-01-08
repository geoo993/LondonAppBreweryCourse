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
import RealmSwift


public func imageUrlForName(_ name: String) -> URL {
    return URL(string: "https://api.adorable.io/avatars/150/" + name.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics)! + ".png")!
}

public class RealmUser: Object, SchemaVersioning {
    public static let schemaVersion: UInt64 = 1

    public var avatarUrl: URL {
        return imageUrlForName(self.name)
    }

    // MARK: - Properties
    @objc public dynamic var uuid: String = UUID().uuidString
    @objc public dynamic var name = "Unknown"
    @objc public dynamic var sent = 0

    // MARK: - Collections
    public let messages = List<RealmMessage>()
    public let outgoing = List<RealmMessage>()

    // MARK: - Init
    public convenience init(uuid: String = UUID().uuidString, name: String) {
        self.init()
        self.uuid = uuid
        self.name = name
    }

    // MARK: - Meta
    override public static func primaryKey() -> String {
        return "uuid"
    }

    /*
    // MARK: - Etc
    private static func createDefaultUser(in realm: Realm) -> RealmUser {
        let me = RealmUser(name: "me")
        try! realm.write {
            realm.add(me)
        }
        return me
    }

    @discardableResult
    static func defaultUser(in realm: Realm) -> RealmUser {
        return realm.object(ofType: RealmUser.self, forPrimaryKey: "uuid")
            ?? createDefaultUser(in: realm)
    }
 */

}