//
//  Story.swift
//  Destiny
//
//  Created by GEORGE QUENTIN on 28/12/2017.
//  Copyright © 2017 Geo Games. All rights reserved.
//

import Foundation

public class Story {
    let story : String
    let answerA : String 
    let answerB : String
    
    init(text: String, answerA : String, answerB : String) {
        self.story = text
        self.answerA = answerA
        self.answerB = answerB
    }
}
