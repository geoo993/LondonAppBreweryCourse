//
//  RegexEx.swift
//  RegularExpressions
//
//  Created by GEORGE QUENTIN on 15/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//
// https://www.raywenderlich.com/86205/nsregularexpression-swift-tutorial

import Foundation
import UIKit
import AppCore

public class RegEx {
    
    func highlightMatches(pattern: String, inString string: String) -> NSAttributedString {
        let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options(rawValue: 0))
        let matches = (regex?
        .matches(in: string, 
                 options: NSRegularExpression.MatchingOptions(rawValue: 0), 
                 range: string.nsRange) )!
        
        let attributedText = NSMutableAttributedString(string: string)
        
        for match in matches {
            attributedText.addAttribute(NSAttributedStringKey.backgroundColor, value: UIColor.yellow, range: match.range)
        }
        
        return attributedText.copy() as! NSAttributedString
    }
    
    func listMatches(pattern: String, inString string: String) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern, 
                                             options: NSRegularExpression.Options(rawValue: 0))
        let matches = (regex?
        .matches(in: string, 
                 options: NSRegularExpression.MatchingOptions(rawValue: 0), 
                 range: string.nsRange) )!
        
        return matches.map {
            let range = $0.range
            return (string as NSString).substring(with: range)
        }
    }
    
    func listGroups(pattern: String, inString string: String) -> [String] {
        let regex = try? NSRegularExpression(pattern: pattern,
                                        options: NSRegularExpression.Options(rawValue: 0))
        let matches = (regex?
            .matches(in: string, 
                     options: NSRegularExpression.MatchingOptions(rawValue: 0), 
                     range: string.nsRange) )!
        
        var groupMatches = [String]()
        for match in matches {
            let rangeCount = match.numberOfRanges
            
            for group in 0..<rangeCount {
                groupMatches.append((string as NSString).substring(with: match.range(at: group)))
            }
        }
        
        return groupMatches
    }
    
    func containsMatch(pattern: String, inString string: String) -> Bool {
        let regex = try? NSRegularExpression(pattern: pattern, 
                                             options: NSRegularExpression.Options(rawValue: 0))
        return regex?.firstMatch(in: string,
                                 options: NSRegularExpression.MatchingOptions(rawValue: 0), 
                                 range: string.nsRange) != nil
    }
    
    func replaceMatches(pattern: String, inString string: String, withString replacementString: String) -> String? {
        let regex = try? NSRegularExpression(pattern: pattern, 
                                             options: NSRegularExpression.Options(rawValue: 0))
        return regex?.stringByReplacingMatches(in: string,
                                               options: NSRegularExpression.MatchingOptions(rawValue: 0), 
                                               range: string.nsRange,
                                               withTemplate: replacementString)
    }

}
