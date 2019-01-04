//
//  SectionType.swift
//  StoryView
//
//  Created by GEORGE QUENTIN on 29/05/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

@objc public enum SectionType: Int {
    case exercise
    case game
    case finish
    case empty

    public var name: String {
        switch self {
        case .exercise: return "Exercise"
        case .game: return "Game"
        case .finish: return "Finish"
        case .empty: return "Empty"
        }
    }
    public var isExercise: Bool {
        switch self {
        case .exercise: return true
        default: return false
        }
    }
    public var isGame: Bool {
        switch self {
        case .game: return true
        default: return false
        }
    }
}
