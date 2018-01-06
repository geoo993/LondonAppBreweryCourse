//
//  Song.swift
//  MusicHitList
//
//  Created by GEORGE QUENTIN on 06/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation

public enum Song: String {
    case unforgetable = "Unforgettable"
    case signOfTheTimes = "Sign Of The Times" 
    case ordinaryLove = "Ordinary Love"
    case millionaire = "Millionaire" 
    case miEnte = "Mi Gente"
    case fellItStill = "Feel It Still"
    case theGreatest = "The Greatest"
    case none = "none"
    
    public static func artist (ofSong: Song) -> String {
        switch ofSong {
        case .unforgetable:
            return "French Montana"
        case .signOfTheTimes:
            return "Harry Styles"
        case .ordinaryLove:
            return "U2"
        case .millionaire:
            return "Chris Stapleton"
        case .miEnte:
            return "J Balvin & Willy William"
        case .fellItStill:
            return "Portugal. The Man"
        case .theGreatest: 
            return "Sia"
        case .none:
            return ""
        }
    }
    
    public static func song(ofArtist: String) -> Song {
        switch ofArtist {
        case "French Montana":
            return .unforgetable
        case "Harry Styles":
            return .signOfTheTimes
        case "U2":
            return .ordinaryLove
        case "Chris Stapleton":
            return .millionaire
        case "J Balvin & Willy William":
            return .miEnte
        case "Portugal. The Man":
            return .fellItStill
        case "Sia":
            return .theGreatest
        default:
            return .none
        }
    }
    
}
