//
//  MemeoryLeaksController.swift
//  Portfolio
//
//  Created by GEORGE QUENTIN on 14/01/2019.
//  Copyright © 2019 GEORGE QUENTIN. All rights reserved.
//

import UIKit
import AppCore

// https://www.youtube.com/watch?v=sp8qEMY9X6Q&feature=youtu.be
// https://www.youtube.com/watch?v=q0-DIJszYRo&feature=youtu.be

// Retain Cycle, and Strong and Weak reference types
class GreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show Red", style: .plain, target: self, action: #selector(GreenViewController.handleShowRedController))
    }
    
    @objc func handleShowRedController() {
        self.navigationController?.pushViewController(RedController(), animated: true)
    }
}

class Service {
    // by default all variables are strong references so they will alway retain reference when called from other classes.
    // however when it is a weak variable it become weak reference meaning that the reference is stoped when the other calles with the object get destroyed
    weak var redController: RedController?
}

class RedController: UITableViewController {
    let service = Service()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        service.redController = self
        
        
        // notification center retain cycle with closure
        NotificationCenter
            .default
            .addObserver(forName: NSNotification.Name(rawValue: "Check news"), object: nil, queue: .main) { [unowned self] (notification) in
                
                // Created retain clycle by doing this, because the notification is capturing self as a strong reference
                //self.showAlert()
                
                // the retain cycle is no longer there because we now have a weak reference from the notification center closure. which creates an optional self which will be nilled out when the viewcontroller is destroyed
                //self?.showAlert()
                
                // using unowned self means that you are guaranteeing that the self will not be nil when the show allert is called and at the same time have a weak reference to RedController
                self.showAlert()
        }
    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Alert", message: "Message", preferredStyle: .alert)
        present(alertController, animated: true, completion: nil)
    }
    
    deinit {
         String.printLog("OS Reclaiming memory for RedController")
    }
    
}
