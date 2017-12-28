//
//  QuizzlerViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit

public class QuizzlerViewController: UIViewController {
    
    let questionbank = QuestionBank()
    var pickedAnswer = false
    var questionNumber = 0
    var correctAnswers = 0
    let pointPerAnswer = 100
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet var correctAnswersProgressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    @IBAction func answerPressed(_ sender: AnyObject) {
        pickedAnswer = (sender.tag == 1)
        
        checkAnswer()
        
        questionNumber += 1
        
        nextQuestion()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        nextQuestion()
    }

    func updateUI() {
        progressLabel.text = "\(questionNumber + 1)/\(questionbank.list.count)"
        scoreLabel.text = "Score: \(correctAnswers * pointPerAnswer)"
        
        progressBar.frame.size.width = (view.frame.width / CGFloat(questionbank.list.count)) 
            * CGFloat(questionNumber + 1)
        correctAnswersProgressBar.frame.size.width = (view.frame.width / CGFloat(questionbank.list.count)) 
            * CGFloat(correctAnswers)
    }
    
    func alertPopUp() {
        let alert = UIAlertController(title: "Great!", message: "Do you want to start over?", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Restart", style: .default) { [weak self] response in
            self?.startOver()
        }
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    func nextQuestion() {
        if questionNumber >= questionbank.list.count { 
            alertPopUp()
        } else {
            questionLabel.text = questionbank.list[questionNumber].questionText
            updateUI()
        }
    }
    
    func checkAnswer() {
        let correctAnswer = questionbank.list[questionNumber].answer
        if correctAnswer == pickedAnswer {
            ProgressHUD.showSuccess("Correct")
            correctAnswers += 1
        } else {
            ProgressHUD.showError("Wrong")
        }
    }
    
    func startOver() {
        questionNumber = 0
        correctAnswers = 0
        nextQuestion()
    }

}
