//
//  SearchOptionsViewController.swift
//  iRegex
//
//  Created by James Frost on 12/10/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit

struct SearchOptions {
  let searchString: String
  var replacementString: String?
  let matchCase: Bool
  let wholeWords: Bool
}

class SearchOptionsViewController: UITableViewController {
  
  var searchOptions: SearchOptions?
  
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var replacementTextField: UITextField!
    @IBOutlet weak var replaceTextSwitch: UISwitch!
    @IBOutlet weak var matchCaseSwitch: UISwitch!
    @IBOutlet weak var wholeWordsSwitch: UISwitch!

    struct Storyboard {
        struct Identifiers {
            static let UnwindSegueIdentifier = "UnwindSegue"
        }
    }
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let options = searchOptions {
          searchTextField.text = options.searchString
          replacementTextField.text = options.replacementString
            replaceTextSwitch.isOn = (options.replacementString != nil)
            matchCaseSwitch.isOn = options.matchCase
            wholeWordsSwitch.isOn = options.wholeWords
        }
    
        searchTextField.becomeFirstResponder()
  }
  
    @IBAction func cancelTapped(_ sender: AnyObject) {
        searchOptions = nil
    
        performSegue(withIdentifier: Storyboard.Identifiers.UnwindSegueIdentifier, sender: self)
    }
  
    @IBAction func searchTapped(_ sender: AnyObject) {
        searchOptions = SearchOptions(searchString: searchTextField.text!,
                                      replacementString: (replaceTextSwitch.isOn) ? replacementTextField.text : nil,
                                      matchCase: matchCaseSwitch.isOn,
                                      wholeWords: wholeWordsSwitch.isOn )
        
        performSegue(withIdentifier: Storyboard.Identifiers.UnwindSegueIdentifier, sender: self)
    }
  
    @IBAction func replaceTextSwitchToggled(_ sender: AnyObject) {
        replacementTextField.isEnabled = replaceTextSwitch.isOn
    }
}
