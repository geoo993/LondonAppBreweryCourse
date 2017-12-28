//
//  Question.swift
//  Quizzler
//
//  Created by GEORGE QUENTIN on 28/12/2017.
//  Copyright © 2017 Geo Games. All rights reserved.
//

import Foundation

public class Question {
    let questionText : String
    let answer : Bool
    
    init(text: String, correctAnswer: Bool) {
        self.questionText = text
        self.answer = correctAnswer
    }
    
}
