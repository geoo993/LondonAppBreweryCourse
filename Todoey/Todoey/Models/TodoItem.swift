//
//  TodoItem.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 07/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation

// Encodable classes mist have standard data types
//struct TodoItem: Encodable, Decodable {
struct TodoItem: Codable {
    let title : String
    var done : Bool 
    init(title: String, done: Bool) {
        self.title = title
        self.done = done
    }
}
