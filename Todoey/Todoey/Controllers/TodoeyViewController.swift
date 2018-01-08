//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 06/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import RealmSwift
import  Chameleon

public class TodoeyViewController: SwipeTableViewController {
   
    var selectedCategory : Category? {
        didSet {
            fetchTodoItems()
        }
    }
    var todoItems : Results<TodoItem>?
    @IBOutlet weak var todoItemSearchbar : UISearchBar!
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Add new ToDoey Item", 
                                                message: "", 
                                                preferredStyle: .alert)
        // Create the actions
        let action1 = UIAlertAction(title: "Add Item", style: .default) { [unowned self] action in
            guard let text = textfield.text else { return }
            self.add(todoItem: text)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancel")
        }
        alertController.addTextField { alertTextfield in
            alertTextfield.placeholder = "Create new item"
            textfield = alertTextfield
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        self.isEditing = !self.isEditing
    }
    
    //MARK: - update swipe model
    override func updateCellDeleteAction(at indexPath: IndexPath ) {
        super.updateCellDeleteAction(at: indexPath)
        if let item = todoItems?[indexPath.row] {
            delete(todoItem: item, reload: false)
        }
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let navController = navigationController,
            let searchBar = todoItemSearchbar, 
            let colorHex = selectedCategory?.color {
           
            updateNavBar(withHexColor: colorHex)
            searchBar.barTintColor = navController.navigationBar.barTintColor
        }
    }

}


//MARK: - CoreData SQL DataBase implemetation
extension TodoeyViewController {
    
    // MARK: - Add TodoItem in Realm DataBase
    func add( todoItem item : String){
        if let currentCategory = selectedCategory {
            do {
                try realm.write {
                    let todoItem = TodoItem(title: item, done: false)
                    currentCategory.items.append(todoItem)
                }
                tableView.reloadData()
            }catch {
                print("Error saving context", error)
            }
        }
    }
    
    // MARK: - Read from TodoItem Realm DataBase
    func fetchTodoItems() {
        if let currentCategory = selectedCategory {
            todoItems = currentCategory.items.sorted(byKeyPath: "title", ascending: true)
            tableView.reloadData()
        }
    }
    
    // MARK: - Update TodoItem in Realm DataBase
    func update(todoItem item: TodoItem) {
        do {
            try realm.write {
                item.done = !item.done
                tableView.reloadData()
            }
        } catch {
            print("Error updating todo item in Realm \(error)")
        }
    }
    
    // MARK: - Delete TodoItem in Realm DataBase
    func delete(todoItem item: TodoItem, reload : Bool = true ) {
        do {
            try realm.write {
                realm.delete(item)
                if reload {
                    tableView.reloadData()
                }
            }
        } catch {
            print("Error deleting todo item in Realm \(error)")
        }
    }
    
    // MARK: - Move a TodoItem in Realm DataBase
    func move(todoItem item: TodoItem, toIndex: Int) {
        //let itemToMove = item
       
        //guard let index = todoItems?.index(of: item) else { return }
        //todoItems.remove(at: index)
        //todoItems.insert(itemToMove, at: toIndex)
        //tableView.reloadData()

    }
    
    // MARK: - Delete all TodoItem in Realm DataBase
    func deleteAllTodoItems() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            print("Error deleting all todo items in Realm \(error)")
        }
    }
    
}

extension TodoeyViewController {
    
    //MARK: - TableView DataSource Methods
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = todoItems?[indexPath.row] { 
            if let colorName = selectedCategory?.color,
            
               let numberOfTodoItems = todoItems?.count {
                cell.backgroundColor =  UIColor(hexString: colorName).darken(byPercentage: 
                    (CGFloat(indexPath.row) / CGFloat(numberOfTodoItems)) )
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor ?? .white, returnFlat: true)
            }
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let item = todoItems?[indexPath.row] {
                delete(todoItem: item)
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    /*
    override public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    override public func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        //if let item = todoItems?[fromIndexPath.row] {
        //    move(todoItem: item, toIndex: to.row)
        //}
    }
    */
    
    //MARK: - TableView Delegate Methods
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = todoItems?[indexPath.row] {
            update(todoItem: item)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: SearchBar Delegate mathods
extension TodoeyViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text, text.count > 0 { 
            
            // look for items that contains this (searchbar.text) result
            // for more on predicates http://nshipster.com/nspredicate/
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
            let tempTodoItems = todoItems?
                .filter(predicate)
                //.sorted(byKeyPath: "title", ascending: true)
                .sorted(byKeyPath: "date", ascending: true)
            todoItems = tempTodoItems
            tableView.reloadData()
        } else {
            fetchTodoItems()
        }
        
        dismissKeyboard(with: searchBar)
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        fetchTodoItems()
    }
    
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            fetchTodoItems()
        }
    }
    
    func dismissKeyboard(with view: UIView) {
        // run in main thread
        DispatchQueue.main.async {
            view.resignFirstResponder()
        }
    }
}

