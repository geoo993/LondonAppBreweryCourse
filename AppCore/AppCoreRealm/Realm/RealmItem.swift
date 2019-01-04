//
//  RealmItem.swift
//  ProjectStemView
//
//  Created by GEORGE QUENTIN on 05/08/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmItem: Object {

    @objc public dynamic var itemId: String = UUID().uuidString
    @objc public dynamic var body: String = ""
    @objc public dynamic var isDone: Bool = false
    @objc public dynamic var timestamp: Date = Date()

    override public static func primaryKey() -> String? {
        return "itemId"
    }

}
