//
//  SearchViewController.swift
//  iRegex
//
//  Created by James Frost on 11/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import AppCore

class SearchViewController: UIViewController {
  
  struct Storyboard {
    struct Identifiers {
      static let SearchOptionsSegueIdentifier = "SearchOptionsSegue"
    }
  }
  
  var searchOptions: SearchOptions?
  
  @IBOutlet weak var textView: UITextView!
  
    @IBAction func unwindToTextHighlightViewController(_ segue: UIStoryboardSegue) {
        
        if let searchOptionsViewController = segue.source as? SearchOptionsViewController {
            
          if let options = searchOptionsViewController.searchOptions {
            performSearchWithOptions(searchOptions: options)
          }
        }
  }
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == Storyboard.Identifiers.SearchOptionsSegueIdentifier) {
          if let options = self.searchOptions {
            if let navigationController = segue.destination as? UINavigationController {
              if let searchOptionsViewController = navigationController.topViewController as? SearchOptionsViewController {
                searchOptionsViewController.searchOptions = options
              }
            }
          }
        }
  }
  
  //MARK: Text highlighting, and Find and Replace
  
  func performSearchWithOptions(searchOptions: SearchOptions) {
    self.searchOptions = searchOptions
    
    if let replacementString = searchOptions.replacementString {
        searchForText(searchText: searchOptions.searchString, replaceWith: replacementString, inTextView: textView)
    } else {
        highlightText(searchText: searchOptions.searchString, inTextView: textView)
    }
  }
  
  func searchForText(searchText: String, replaceWith replacementText: String, inTextView textView: UITextView) {
  }
  
  func highlightText(searchText: String, inTextView textView: UITextView) {
  }
  
  func rangeForAllTextInTextView() -> NSRange {
    return NSRange.init(location: 0, length: textView.text.count)
  }
  
  //MARK: Underline dates, times, and locations
  
  @IBAction func underlineInterestingData(_ sender: AnyObject) {
    underlineAllDates()
    underlineAllTimes()
    underlineAllLocations()
  }
  
  func underlineAllDates() {
  }
  
  func underlineAllTimes() {
  }
  
  func underlineAllLocations() {
  }
  
  func matchesForRegularExpression(regex: NSRegularExpression, inTextView textView: UITextView) -> [NSTextCheckingResult] {
    let string = textView.text
    let range = rangeForAllTextInTextView()
    return regex.matches(in: string!, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: range) 
  }
  
  func highlightMatches(matches: [NSTextCheckingResult]) {
    let attributedText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
    let attributedTextRange = NSMakeRange(0, attributedText.length)
    attributedText.removeAttribute(NSAttributedStringKey.backgroundColor, range: attributedTextRange)
    
    for match in matches {
      let matchRange = match.range
        attributedText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.blue, range: matchRange)
        attributedText.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: matchRange)
    }
    
    textView.attributedText = attributedText.copy() as! NSAttributedString
  }
}
