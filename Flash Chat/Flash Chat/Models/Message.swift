//
//  Message.swift
//  Flash Chat
//
//  This is the model class that represents the blueprint for a message
import UIKit

public protocol Message {
    var user : String { get }
    var message : String { get }
    var avatar : UIImage { get }
    var avatarColor : UIColor { get }
    var backgroundColor : UIColor { get }
    var messageBoxColor : UIColor { get }
}

public class MessageSender : Message {
    
    public var user: String
    public var message: String
    public var avatar: UIImage
    public var avatarColor: UIColor
    public var backgroundColor: UIColor
    public var messageBoxColor: UIColor
    
    init(sender : String, messageBody : String) {
        self.user = sender
        self.message = messageBody
        self.avatar = #imageLiteral(resourceName: "egg")
        self.avatarColor = .bbciplayerPink
        self.backgroundColor = .white
        self.messageBoxColor = .goldenrod
    }
}

