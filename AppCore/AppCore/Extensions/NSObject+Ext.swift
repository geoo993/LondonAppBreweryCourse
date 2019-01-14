//
//  NSObject+Ext.swift
//  AppCore
//
//  Created by GEORGE QUENTIN on 14/01/2019.
//  Copyright © 2019 Geo Games. All rights reserved.
//

import Foundation

extension NSObject {
 
    public var className: String {
        return String(describing: type(of: self))
    }
    
    public class var className: String {
        return String(describing: type(of: self))
    }
        
}
