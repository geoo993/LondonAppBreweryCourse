//
//  Category.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 08/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
import RealmSwift

public class Category : Object {
    @objc dynamic var name : String = ""
    @objc dynamic var color : String = ""
    let items = List<TodoItem>()
    public convenience init(name: String, color: String) {
        self.init()
        self.name = name
        self.color = color
    }
}
