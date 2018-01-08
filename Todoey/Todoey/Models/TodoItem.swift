//
//  TodoItem.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 08/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import RealmSwift

public class TodoItem : Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var date : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    public convenience init(title: String, done: Bool, date: Date = Date()) {
        self.init()
        self.title = title
        self.done = done
        self.date = date
    }
}
