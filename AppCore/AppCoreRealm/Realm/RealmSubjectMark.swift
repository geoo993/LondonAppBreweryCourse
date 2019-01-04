//
//  RealmSubjectMark.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 08/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
import Foundation
import RealmSwift

public class RealmSubjectMark: Object, SchemaVersioning {

    public static let schemaVersion: UInt64 = 1
    // MARK: - persisted properties
    @objc public dynamic var uuid: String = UUID().uuidString
    @objc public dynamic var name: String = ""
    @objc public dynamic var mark: String = ""

    // MARK: - convenience init
    public convenience init(uuid: String = UUID().uuidString, name: String, mark: String) {
        self.init()
        self.uuid = uuid
        self.name = name
        self.mark = mark
    }

    // MARK: - Meta
    public override static func primaryKey() -> String {
        return "uuid"
    }
}
