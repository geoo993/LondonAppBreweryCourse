//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 08/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import Chameleon

public class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {
    let cellIdentifier = "swipeCell"
    var realm : Realm {
        return AppDelegate.realm
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Setup Nav Bar
    func updateNavBar (withHexColor colorHex : String) {
        if let navController = navigationController, let navBarColor = UIColor(hexString:  colorHex) {
            let constrastColor = ContrastColorOf(navBarColor, returnFlat: true)
            navController.navigationBar.tintColor = constrastColor
            navController.navigationBar.barTintColor = navBarColor
            navController.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: constrastColor]
        }
    }
    
    //MARK: - update swipe model
    func updateCellDeleteAction(at indexPath: IndexPath ) {
        
    }
    
    //MARK: - TableView DataSource Methods
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SwipeTableViewCell {
            cell.delegate = self
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    // MARK: - SwipeTableViewCell delegate methods
    public func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [unowned self] action, indexPath in
            // handle action by updating model with deletion
            self.updateCellDeleteAction(at: indexPath)
        }
        
        // customize the action appearance
        deleteAction.image = #imageLiteral(resourceName: "Trash")
        
        return [deleteAction]
    }
    
    public func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        return options
    }
}
