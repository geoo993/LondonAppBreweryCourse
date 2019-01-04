//
//  RealmStatus.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 08/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmStatus: Object, SchemaVersioning {

    public static let schemaVersion: UInt64 = 1

    // MARK: - persisted properties
    @objc public dynamic var status = ""

    // MARK: - convenience init
    public convenience init(status: String) {
        self.init()
        self.status = status
    }

    // MARK: - Meta
    override public static func primaryKey() -> String {
        return "status"
    }
}
