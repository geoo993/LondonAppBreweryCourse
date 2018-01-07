//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 06/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit

public class TodoeyTableViewController: UITableViewController {

    let cellIdentifier = "todoItemCell"
    let itemsArray = ["Sir", "Miss", "Doctor"]
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

}

extension TodoeyTableViewController {
    
    //MARK: - TableView DataSource Methods
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = itemsArray[indexPath.row]
        return cell
    }
    
    //MARK: - TableView Delegate Methods
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
