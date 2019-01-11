//
//  Grid.swift
//  WordConnect
//
//  Created by GEORGE QUENTIN on 09/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

public struct Grid {
    let columns: Int
    let rows: Int
    let spacing: CGFloat
    var size: Int {
        return columns * rows
    }
}

public class GridLayout {
    static func createGrid(with container: CGRect,
                           grid: Grid, insectBy: CGFloat = 2)
        -> (size: CGSize, frame: [(rect: CGRect, index: Int)]) {
        // border insect
        let insets = UIEdgeInsets(top: insectBy, left: insectBy, bottom: insectBy, right: insectBy)
        
        // available size is the total of the widths and heights of your cell views:
        // bounds.width/bounds.height minus edge insets minus spacing between cells
        let availableSize = CGSize(
            width: container.width - insets.left - insets.right - (CGFloat(grid.columns - 1) * grid.spacing),
            height: container.height - insets.top - insets.bottom - (CGFloat(grid.rows - 1) * grid.spacing))
        
        // maximum width and height that will fit
        let maxChildWidth = floor(availableSize.width / CGFloat(grid.columns))
        let maxChildHeight = floor(availableSize.height / CGFloat(grid.rows))
        
        // childSize should be square
        let childSize = CGSize(
            width: maxChildWidth, //min(maxChildWidth, maxChildHeight),
            height: maxChildHeight) //min(maxChildWidth, maxChildHeight))
        
        // total area occupied by the cell views, including spacing inbetween
        let totalChildArea = CGSize(
            width: childSize.width * CGFloat(grid.columns) + (CGFloat(grid.columns - 1) * grid.spacing),
            height: childSize.height * CGFloat(grid.rows) + (CGFloat(grid.rows - 1) * grid.spacing))
        
        // center everything in GridView
        let topLeftCorner = CGPoint(
            x: floor((container.size.width - totalChildArea.width) / 2),
            y: floor((container.size.height - totalChildArea.height) / 2))
        
        var iterator = 0
        var frames = [(CGRect, Int)]()
        
        for row in 0 ..< grid.rows {
            for col in 0 ..< grid.columns {
                let frame = CGRect(
                    x: topLeftCorner.x + CGFloat(col) * (childSize.width + grid.spacing),
                    y: topLeftCorner.y + CGFloat(row) * (childSize.height + grid.spacing),
                    width: childSize.width,
                    height: childSize.height)
                frames.append((frame, iterator))
                iterator += 1
            }
        }
        return (availableSize, frames)
    }
    
    public static func verticalGrid(columns: Int, rows: Int) -> [[Int]] {
        var indexes = [[Int]]()
        for index in 0 ..< columns {
            let col = (index % columns)
            var tempArr = [Int]()
            for iterator in 0 ..< rows {
                tempArr.append(col + (columns * iterator))
            }
            indexes.append(tempArr)
        }
        return indexes
    }
    
    public static func horizontalGrid(rows: Int, columns: Int) -> [[Int]] {
        var indexes = [[Int]]()
        for row in 0 ..< rows {
            var tempArr = [Int]()
            for iterator in 0 ..< columns {
                tempArr.append((row * columns) + iterator)
            }
            indexes.append(tempArr)
        }
        return indexes
    }
    
    public static func positiveDiagonalGrid(columns: Int, rows: Int) -> [[Int]] {
        if abs(columns - rows) > 1 { return [] }
        
        var indexes = [[Int]]()
        let length = columns + 1
        for index in 0 ..< columns {
            var tempArrPositive = [Int]()
            let placesOnTheRight = columns - index
            for iterator in 0 ..< placesOnTheRight {
                tempArrPositive.append(index + (iterator * length))
            }
            indexes.append(tempArrPositive)
            
            var tempArrNegative = [Int]()
            let placesOnTheLeft = rows - index
            for iterator in 0 ..< placesOnTheLeft where index > 0 {
                let diag = (index * columns) + (iterator * length)
                tempArrNegative.append(diag)
            }
            indexes.append(tempArrNegative)
        }
        return indexes
    }
    
    public static func negativeDiagonalGridPositions(columns: Int, rows: Int) -> [[Int]] {
        if abs(columns - rows) > 1 { return [] }
        
        var indexes = [[Int]]()
        let length = columns - 1
        for index in 0 ..< columns {
            var tempArrPositive = [Int]()
            let placesOnTheLeft = columns - index
            for iterator in 0 ..< placesOnTheLeft {
                tempArrPositive.append(((iterator + 1) * length) - index)
            }
            indexes.append(tempArrPositive)
            var tempArrNegative = [Int]()
            let placesOnTheRight = rows - index
            for iterator in 0 ..< placesOnTheRight where index > 0 {
                let diag = (index * columns + length) + (iterator * length)
                tempArrNegative.append(diag)
            }
            indexes.append(tempArrNegative)
        }
        return indexes
    }
    
    public static func randomRange(of word: String, within size: Int) -> Range<Int> {
        let characterCount = word.count
        let min = Int.random(min: 0, max: size - word.count)
        let max = min + characterCount
        return min ..< max
    }
    
    public static func can(words: [String], fitInto areas: [[Int]]) -> Bool {
        var canFit = false
        for word in words {
            for area in areas where word.count <= area.count {
                canFit = true
                break
            }
        }
        return canFit
    }
    
    public static func shouldAddToGrid(when position: Range<Int>,
                                       isWithin areas: [Int],
                                       using occupiedList: [Bool]) -> Bool {
        var addToGrid = true
        for (index, area) in areas.enumerated()
            where position.contains(index) && occupiedList.count < area && occupiedList[area] == true {
                addToGrid = false
                break
        }
        return addToGrid
    }
    
    public static func character(in word: String, at pos: Int) -> Character {
        return word[word.index(word.startIndex, offsetBy: pos)]
    }
    
    public static func randomCharacter() -> Character {
        let characters = "ABCDEFGHIJKLKMNOPQRSTUVWXYZ"
        let randomPosition = Int.random(min: 0, max: characters.count - 1)
        return characters[randomPosition]
    }
    
    public static func remainingSpaces(inside area: [Int], using positions: Range<Int>) -> [[Int]] {
        let first = positions.lowerBound
        let last = positions.upperBound
        if first != last {
            let first = area.split(after: first).0
            let second = area.split(after: last).1
            return [first, second]
        } else {
            return []
        }
    }
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    public static func calculateWordsToSearch(with words: [String],
                                              rows: Int,
                                              columns: Int) -> [(word: String, lettersIndexes: [Int])] {
        guard words.isEmpty == false, let maxCharacter = [rows, columns].min() else { return [] }
        
        let uniqueWords = words.removeRepeatedWords()
            .getWords(withMinimumCharacterCount: 2, withMaximumCharacterCount: maxCharacter)
            
        let vert = verticalGrid(columns: columns, rows: rows)
        let hori = horizontalGrid(rows: rows, columns: columns)
        //let posDiag = positiveDiagonalGrid(columns: columns, rows: rows)
        //let negDiag = negativeDiagonalGridPositions(columns: columns, rows: rows)
        var tempAreas = (vert + hori) //+ negDiag + posDiag)
        
        var maxSize = (rows * columns), whileLoop = 0
        var wordsToSearch = [(word: String, lettersIndexes: [Int])]()
        var templist = Array(0 ..< maxSize).map({ (character: randomCharacter(), index: $0, isOccupied: false) })
        var tempWords = uniqueWords
        
        while whileLoop < 100 {
            // for safety, stop searching for words when the loop goes on for longer than 100
            whileLoop += 1
            
            // check if tempAreas is not empty or if there is no word that can go in the remaining areas
            if tempAreas.isEmpty || tempWords.isEmpty { break }
            
            let canWordsFitInAvailableAreas = can(words: tempWords, fitInto: tempAreas)
            
            if canWordsFitInAvailableAreas == false { continue }
            
            // filter those that are not already in wordsToSearch list
            let wordsToSearchIndexes = wordsToSearch.flatMap({ $0.lettersIndexes })
            let temp = tempAreas.filter({ $0.map({ wordsToSearchIndexes.contains($0) }).contains(true) == false })
            
            // get random area
            guard var tempArea = temp.chooseOneRandomly() else { continue }
            
            // get a word that is in range of the random area or can fit in the random area
            let getWords = tempWords.filter({ $0.count <= tempArea.count })
            
            // check if a word is not available
            if getWords.isEmpty { continue }
            
            // choose a word from the list of words
            guard let tempWord = getWords.chooseOneRandomly() else { continue }
            
            // remove word at from the list of words
            if let index = tempWords.index(of: tempWord) { tempWords.remove(at: index) }
            
            // get a random position for the word in a range between 0 and the size
            let tempWordPosition = randomRange(of: tempWord, within: tempArea.count)
            
            // check if we can add the word in the temparea in the grid, whether the spot is already taken
            let addToGrid = shouldAddToGrid(when: tempWordPosition, isWithin: tempArea,
                                            using: templist.map({ $0.isOccupied }))
            
            // add the word in the grid after checking
            if addToGrid {
                //this has the index of each character of a word
                var gridPositionOfWordToAdd = [Int]()
                let tempWordPositionArray = Array(tempWordPosition.lowerBound ..< tempWordPosition.upperBound)
                
                for tempAreaIndex in 0 ..< tempArea.count {
                    if let firstIndex = tempWordPositionArray.first(where: { $0 == tempAreaIndex }),
                        let wordToAddIndex = tempWordPositionArray.index(of: firstIndex) {
                        let index = tempArea[firstIndex]
                        templist[index].character = character(in: tempWord, at: wordToAddIndex)
                        templist[index].isOccupied = true
                        gridPositionOfWordToAdd.append(index)
                    }
                }
                
                // add the word in the words to search list
                wordsToSearch.append((tempWord, gridPositionOfWordToAdd))
                
                // get the remaining spaces in the current area that can still take a word
                let remainingSpacesInArea = remainingSpaces(inside: tempArea, using: tempWordPosition)
                
                // insert remaining spaces if any and add to the tempArea spaces
                for remainingSpaceinArea in remainingSpacesInArea where remainingSpacesInArea.isEmpty == false {
                    tempAreas.append(remainingSpaceinArea)
                }
            }
        }
        
        return wordsToSearch
    }
}
