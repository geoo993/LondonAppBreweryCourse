//
//  Date+Ext.swift
//  StoryCore
//
//  Created by Daniel Asher on 29/07/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import Foundation

extension Date: Then { }

public extension Date {
    func toString(format: String) -> String {
        let date = DateFormatter().then {
            $0.dateFormat = "HH:mm:ss"
        }
        return date.string(from: self)
    }
}
