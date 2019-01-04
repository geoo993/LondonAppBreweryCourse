//
//  SeaFood.swift
//  SeaFood
//
//  Created by GEORGE QUENTIN on 20/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import Foundation
//import AppCore
import VisualRecognitionV3

struct SeaFood {
    static var food : [String] {
      return [
        "Abalone",
        "Anchovy",
        "Arctic Char",
        "Barracuda",
        "Barramundi",
        "Bass",
        "Bass, Blue Gill",
        "Bass, Sea, Lake",
        "Bass, Striped",
        "Black Drum",
        "Black Sea Bass",
        "Bluefish",
        "Bluenose",
        "Bullhead",
        "Butterfish",
        "Capelin",
        "Carp",
        "Catfish",
        "Caviar",
        "Chilean Seabass",
        "Chub",
        "Clam",
        "Cobia",
        "Cod",
        "Conch",
        "Corvina",
        "Crab",
        "Crayfish",
        "Croaker",
        "Cusk",
        "Dab",
        "Drum",
        "Eel",
        "Escolar",
        "Flounder",
        "Frog",
        "Gray Sole",
        "Greater Amberjack",
        "Grenadier",
        "Grouper",
        "Haddock",
        "Hake",
        "Halfmoon Fish",
        "Halibut",
        "Harvest Fish",
        "Herring",
        "Imitation Crab",
        "Jellyfish, dried/Salted",
        "Lingcod",
        "Lobster",
        "Mackerel, Atlantic",
        "Mackerel, Spanish",
        "Mahi-mahi",
        "Marlin",
        "Monkfish",
        "Mullet",
        "Muskellunge",
        "Mussel",
        "Mussels",
        "Ocean Pout",
        "Octopus",
        "Opah",
        "Opaleye",
        "Orange Roughy",
        "Oyster",
        "Pangasius",
        "Parrotfish",
        "Perch Fish",
        "Perch",
        "Perch, Ocean",
        "Pickerel",
        "Pike",
        "Pilchards",
        "Plaice",
        "Pomfret",
        "Pompano",
        "Pollock, Atlantic",
        "Porgy",
        "Red Porgy",
        "Red Snapper",
        "Rockfish",
        "Rosefish",
        "Sablefish",
        "Salmon, Atlantic, Wild",
        "Salmon, Chinook",
        "Salmon, Farmed",
        "Salmon, Sockeye",
        "Sanddabs",
        "Sardine",
        "Scad",
        "Scallops",
        "Scrod",
        "Scup",
        "Sea Beam",
        "Sea Turtle",
        "Sea Urchin",
        "Seatrout",
        "Shellfish",
        "Shad",
        "Shark",
        "Sheepshead fish",
        "Shrimp",
        "Skate",
        "Smelt Spearfish",
        "Snail",
        "Escargot",
        "Sole",
        "Squid",
        "Calamari",
        "Striped Bass",
        "Sturgeon",
        "Sucker",
        "Sunfish",
        "Pumpkinseed",
        "Swai",
        "Swordfish",
        "Tatoaba",
        "Tilapia",
        "Tilefish",
        "Trevally/Jack",
        "Trout, Rainbow, Wild",
        "Trout, Sea",
        "Trout, Steelhead, Wild",
        "Tuna, Albacore",
        "Tuna, Bigeye",
        "Tuna, Blackfin",
        "Tuna, Bluefin",
        "Tuna, Canned Tuna, Skipjack",
        "Tuna, Tongol",
        "Tuna, Yellowfin",
        "Turbot, European",
        "Turtle",
        "Wahoo",
        "Walleye",
        "Weakfish",
        "White Seabass",
        "Whitefish",
        "Whiting",
        "Wolfish, Atlantic",
        "Wreckfish",
        "Yellowtail",
        ]
    }
    
    static func isSeaFood (classiffierWithTypeHierachy: ClassResult) -> Bool {
    
        if let seafoodHierachy = seaFoodCategory(classiffierWithTypeHierachy: classiffierWithTypeHierachy) {
            let seafoodCategoryWords = uniqueWordsInSeaFoodFound(classiffierWithTypeHierachy: classiffierWithTypeHierachy)
            let allPotentialSeaFoodNames = [seafoodHierachy] + seafoodCategoryWords
            
            for currentSeafood in allPotentialSeaFoodNames {
                if isSeaFood(with: currentSeafood) {
                    return true
                }
            }
        }
        
        return false
    }
    
    private static func isSeaFood(with item: String) -> Bool {
        return food
            .flatMap({ $0
                .lowercased()
                .toWordsFromRegexIncludingSpecialCharactersWithinWords() })
            .contains(item)
    }
    
    static func seaFoodCategory (classiffierWithTypeHierachy: ClassResult) -> String? {
        return classiffierWithTypeHierachy
            .typeHierarchy?
            .components(separatedBy: "/")
            .dropLast()
            .last
    }
    
    static func uniqueWordsInSeaFoodFound(classiffierWithTypeHierachy: ClassResult) -> [String] {
        return classiffierWithTypeHierachy
            .className //.classification
            .lowercased()
            .toWordsFromRegexIncludingSpecialCharactersWithinWords()
    }
    
}
