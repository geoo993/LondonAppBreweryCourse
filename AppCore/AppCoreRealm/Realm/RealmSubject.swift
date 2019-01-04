//
//  RealmSubject.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 07/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
import Foundation
import RealmSwift

public class RealmSubject: Object, SchemaVersioning {

    public static let schemaVersion: UInt64 = 1
    // MARK: - persisted properties
    @objc public dynamic var uuid: String = UUID().uuidString
    @objc public dynamic var name = ""

    // MARK: - convenience init
    public convenience init(uuid: String = UUID().uuidString, name: String) {
        self.init()
        self.uuid = uuid
        self.name = name
    }

    // MARK: - Meta
    override public static func primaryKey() -> String {
        return "uuid"
    }
}
