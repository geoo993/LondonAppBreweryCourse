//
//  RoadSections.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 29/05/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

@objc public class RoadSection: NSObject {
    let path: UIBezierPath
    public let type: SectionType
    public let instance: Int

    init(path: UIBezierPath, type: SectionType, instance: Int) {
        self.path = path
        self.type = type
        self.instance = instance
    }
}

struct RoadSections {
    let fullPath: UIBezierPath
    let sections: [RoadSection]
}
