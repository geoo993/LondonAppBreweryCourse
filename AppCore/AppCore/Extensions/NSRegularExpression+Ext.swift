//
//  NSRegularExpression+Ext.swift
//  AppCore
//
//  Created by GEORGE QUENTIN on 13/01/2019.
//  Copyright © 2019 Geo Games. All rights reserved.
//

extension NSRegularExpression {
    
    convenience init(pattern: String) {
        try! self.init(pattern: pattern, options: [])
    }
}
