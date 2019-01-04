//
//  RealmSchemaProtocols.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 05/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

public protocol SchemaVersioning {
    static var schemaVersion: UInt64 { get }
}

public protocol SchemaManaging {
    static var objectTypes: [RealmSwift.Object.Type] { get }
    static var schemaVersion: UInt64 { get }
}

public extension SchemaManaging {
    public static var schemaVersion: UInt64 {
        return RealmUserSchema.objectTypes.reduce(UInt64(0)) { sum, objectType in
            // WARN: ☢️ This will crash if the realm class doesn't implement SchemaVersionable
            // This guarantees that we won't get more difficult problems on the object server side!
            let schemaVersion = (objectType as? SchemaVersioning.Type)!.schemaVersion
            // INFO: We (+1) so that any new object added (with schemaVersion set at zero) bumps the total version
            return sum + schemaVersion + 1
        }
    }
}
