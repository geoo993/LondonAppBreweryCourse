//
//  ViewController.swift
//  Flash Chat
//
//  Created by Angela Yu on 29/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import FirebaseCore
import AppCore
import Chameleon

class ChatViewController: UIViewController {
    
    // Declare instance variables here
    var textfieldContainerOriginalHeight : CGFloat = 50.0
    var messagesArray = [MessageSender]()
    
    // We've pre-linked the IBOutlets
    @IBOutlet var heightConstraint: NSLayoutConstraint!
    @IBOutlet var sendButton: UIButton!
    @IBOutlet var messageTextfield: UITextField!
    @IBOutlet var messageTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        tableViewTapGesture()
        
        registerTableViewCell()
        configureTableView()
        retrieveMessagesAction()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(keyboardWillShow), 
                                               name: .UIKeyboardWillShow, 
                                               object: nil)
        NotificationCenter.default.addObserver(self, 
                                               selector: #selector(keyboardWillHide),
                                               name: NSNotification.Name.UIKeyboardWillHide, 
                                               object: nil)
        
    }
    
    override open func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow( _ notification: Notification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        expandTextfieldContainer(toHeight: keyboardHeight)
    }
    
    @objc func keyboardWillHide( _ notification: Notification) {
        shrinkTextFieldContainer()
    }
    
    
    //MARK: - Send & Recieve from Firebase
    func sendMessageAction () {
        if let currentUser = Auth.auth().currentUser?.email,
            let messageText = messageTextfield.text {
            
            endTextfieldEditing()
            messageTextfield.isEnabled = false
            sendButton.isEnabled = false
            
            // saving our message dictionary inside messages datadbase, under an automayically generated idenifier
            let messagesDB = Database.database().reference().child("Messages")
            let messageDictionary = ["Sender": currentUser, "MessageBody" : messageText]
            messagesDB
                .childByAutoId()
                .setValue(messageDictionary) { [weak self] (error, data) in
                    guard let this = self else { return }
                    if let error = error {
                        print("Error saving message in database", error)
                    } else {
                        print("Message saved successfully inside our databasa", data)
                    }
                    
                    this.messageTextfield.isEnabled = true
                    this.sendButton.isEnabled = true
                    this.messageTextfield.text = ""
            }
            
        }
    }
    
    func retrieveMessagesAction() {
        let messagesDB = Database.database().reference().child("Messages")
        messagesDB
            .observe(DataEventType.childAdded, with: { [weak self] (dataSnapShot) in
                guard let this = self else { return }
                
                if let data = dataSnapShot.value as? Dictionary<String,String>,
                    let user = data["Sender"],
                    let messageBody = data["MessageBody"] {
                    let message = MessageSender(sender:user , messageBody: messageBody)
                    this.messagesArray.append(message)
                    
                    
                    this.configureTableView()
                    this.messageTableView.reloadData()
                    this.messageTableView.scrollToBottom(animated: true)
                }
        })
        
    }
    
    @IBAction func sendPressed(_ sender: AnyObject) {
        sendMessageAction()
    }
    
    
    //MARK: - Logout from ChatViewController
    func logoutAction () {
        
        do {
            try Auth.auth().signOut()
            
        } catch let error {
            print("there was a problem signin out:",error)
        }
        
        guard (navigationController?.popToRootViewController(animated: true) != nil ) else {
            print("Could not return to root view controller")
            return 
        }
    }
    
    @IBAction func logOutPressed(_ sender: AnyObject) {
        logoutAction()
    }
    
}


//MARK: - TableView DataSource Methods
extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        messageTableView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView
            .dequeueReusableCell(withIdentifier: "customMessageCell", 
                                 for: indexPath) as! CustomMessageCell
        let message = messagesArray[indexPath.row]
        
        cell.backgroundColor = message.backgroundColor
        cell.senderUsername.text = message.user
        cell.messageBody.text = message.message
        cell.avatarImageView?.image = message.avatar
        cell.avatarImageView.backgroundColor = message.avatarColor
        cell.messageBackground.backgroundColor = message.messageBoxColor
        
        if let currentuser = Auth.auth().currentUser?.email, currentuser == message.user {
            cell.avatarImageView.backgroundColor = UIColor.flatMint() 
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        } 
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func tableViewTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(endTextfieldEditing))
        tapGesture.cancelsTouchesInView = false
        messageTableView.addGestureRecognizer(tapGesture)
    }
    
    func registerTableViewCell() {
        messageTableView.register(UINib(nibName: "MessageCell", bundle: nil) , 
                                  forCellReuseIdentifier: "customMessageCell")
    }
    
    func configureTableView() {
        let averageMessageHeight : CGFloat = 120.0
        messageTableView.rowHeight = UITableViewAutomaticDimension
        messageTableView.estimatedRowHeight = averageMessageHeight
    }
    
}

//MARK:- TextField Delegate Methods
extension ChatViewController: UITextFieldDelegate {
    
    func expandTextfieldContainer(toHeight : CGFloat) {
        UIView.animate(withDuration: 0.5, animations: { [weak self] () in
            guard let this = self else { return }
            this.heightConstraint.constant = this.textfieldContainerOriginalHeight + toHeight
            this.messageTableView.scrollToBottom(animated: true)
            this.view.layoutIfNeeded()
        })
    }
    
    func shrinkTextFieldContainer () {
        UIView.animate(withDuration: 0.5, animations: { [weak self] () in
            guard let this = self else { return }
            this.heightConstraint.constant = this.textfieldContainerOriginalHeight
            this.view.layoutIfNeeded()
        })
    }

    @objc func endTextfieldEditing() {
        messageTextfield.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
   
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMessageAction()
        return true
    }
    
}

