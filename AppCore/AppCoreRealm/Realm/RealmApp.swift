//
//  RealmApp.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 05/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import RealmSwift

public final class RealmApp: Object, SchemaVersioning {
    public static let schemaVersion: UInt64 = 1
    @objc public dynamic var uuid: String = UUID().uuidString
    @objc public dynamic var name: String = ""
    @objc public dynamic var password: String = ""
    @objc public dynamic var defaultUser: String = ""
    var users: List<RealmUser> = List<RealmUser>()
    convenience init(uuid: String = UUID().uuidString, name: String, password: String) {
        self.init()
        self.uuid = uuid
        self.name = name
        self.password = password
    }
    
    override public static func primaryKey() -> String {
        return "uuid"
    }

    override public class func ignoredProperties() -> [String] {
        return ["password"]
    }
}
