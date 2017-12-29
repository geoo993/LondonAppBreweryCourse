//
//  DestinyViewController.swift
//  Destiny
//
//  Created by GEORGE QUENTIN on 28/12/2017.
//  Copyright © 2017 Geo Games. All rights reserved.
//

import UIKit

public enum StoryState {
    case 
    part1(String, String, String), 
    part2(String, String, String), 
    part3(String, String, String),
    part4(String),
    part5(String),
    part6(String)
}

public enum Events {
    case start, p1a, p1b, p2a, p2b, p3a, p3b
}

public class DestinyViewController: UIViewController {
    
    let destinystory = DestinyStory()
    var event : Events = .start {
        didSet {
            
            switch event {
            case .start:
                story = .part1(destinystory.story1.story, 
                               destinystory.story1.answerA, 
                               destinystory.story1.answerB)
            case .p1a:
                story = .part3(destinystory.story3.story, 
                               destinystory.story3.answerA, 
                               destinystory.story3.answerB)
            case .p1b:
                story = .part2(destinystory.story2.story, 
                               destinystory.story2.answerA, 
                               destinystory.story2.answerB)
            case .p2a:
                story = .part3(destinystory.story3.story, 
                               destinystory.story3.answerA, 
                               destinystory.story3.answerB)
            case .p2b:
                story = .part4(destinystory.story4.story)
            case .p3a:
                story = .part6(destinystory.story6.story)
            case .p3b:
                story = .part5(destinystory.story5.story)
            }
        }
    }
    
    var story : StoryState? {
        didSet {
            guard let destiny = story else { return }
            switch destiny {
            case .part1(let story, let answer1a, let answer1b):
                updateButtonsUI(text: story,
                                answerA: answer1a, 
                                answerB: answer1b)
            case .part2(let story, let answer2a, let answer2b):
                updateButtonsUI(text: story,
                                answerA: answer2a, 
                                answerB: answer2b)
            case .part3(let story, let answer3a, let answer3b):
                updateButtonsUI(text: story,
                                answerA: answer3a, 
                                answerB: answer3b)
            case .part4(let story):
                updateButtonsUI(text: story,
                                answerA: nil, 
                                answerB: nil)
            case .part5(let story):
                updateButtonsUI(text: story,
                                answerA: nil, 
                                answerB: nil)
            case .part6(let story):
                updateButtonsUI(text: story,
                                answerA: nil, 
                                answerB: nil)
            }
        }
    }
    
    // UI Elements linked to the storyboard
    @IBOutlet weak var skyButton: UIButton!         // Has TAG = 1
    @IBOutlet weak var seaButton: UIButton!         // Has TAG = 2
    @IBOutlet weak var restartButton: UIButton! 
    @IBOutlet weak var storyTextView: UILabel!
    
    // User presses one of the buttons
    @IBAction func buttonPressed(_ sender: UIButton) {
        let answerSelected = (sender.tag == 1)
        guard let destiny = story else { return }
        switch destiny {
        case .part1:
            event = answerSelected ? .p1a : .p1b
        case .part2:
            event = answerSelected ? .p2a : .p2b
        case .part3:
            event = answerSelected ? .p3a : .p3b
        case .part4:
            event = .start
        case .part5:
            event = .start
        case .part6:
            event = .start
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.event = .start
    }
    
    func updateButtonsUI (text: String, answerA : String?, answerB : String?) {
        
        self.storyTextView.text = text
        self.skyButton.setTitle(answerA, for: .normal)
        self.seaButton.setTitle(answerB, for: .normal)
        
        self.skyButton.isHidden = (answerA == nil)
        self.seaButton.isHidden = (answerB == nil)
        self.restartButton.isHidden = !(answerA == nil && answerB == nil)
    }

    
}

