//
//  TodoeyViewController.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 06/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import CoreData

public class TodoeyViewController: UITableViewController {
    
    let context = 
        (UIApplication.shared.delegate as! AppDelegate)
        .persistentContainer
        .viewContext
    let cellIdentifier = "todoItemCell"
    
    var selectedCategory : Category? {
        didSet {
            fetchTodoItems()
        }
    }
    var itemsArray = [TodoItem]()
    
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

}


//MARK: - CoreData SQL DataBase implemetation
extension TodoeyViewController {
    
    // MARK: - Create new TodoItem in SQL DataBase
    func add( todoItem item : String){
        let todoItem = TodoItem(context: context)
        todoItem.title = item
        todoItem.done = false
        todoItem.parentCategory = selectedCategory
        itemsArray.append(todoItem)
        saveTodoItems()
    }
    
    // MARK: - Save TodoItem changes in SQL DataBase
    func saveTodoItems() {
        do {
            try context.save()
            tableView.reloadData()
        }catch {
            print("Error saving context", error)
        }
    }
    
    // MARK: - Read from TodoItem SQL DataBase
    func fetchTodoItems(with request : NSFetchRequest<TodoItem> = TodoItem.fetchRequest(), predicate : NSPredicate? = nil) {
        guard let selectedCategoryName = selectedCategory?.name else { return }
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategoryName)
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate, categoryPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemsArray = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch data from context. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Update TodoItem in SQL DataBase
    func update(todoItem item: TodoItem) {
        item.setValue(!item.done, forKey: "done")
        saveTodoItems()
    }
    
    // MARK: - Destroy TodoItem in SQL DataBase
    func destroy(todoItem item: TodoItem) {
        guard let index = itemsArray.index(of: item) else { return }
        itemsArray.remove(at: index)
        context.delete(item)
        saveTodoItems()
    }
    
    func move(todoItem item: TodoItem, toIndex: Int) {
        let itemToMove = item
        //let itemAtToIndex = itemsArray[toIndex]
        //        
        //        item.setValue(itemAtToIndex.title, forKey: "title")
        //        item.setValue(itemAtToIndex.done, forKey: "done")
        //        
        //        itemAtToIndex.setValue(itemToMove.title, forKey: "title")
        //        itemAtToIndex.setValue(itemToMove.done, forKey: "done")
        
        
        guard let index = itemsArray.index(of: item) else { return }
        itemsArray.remove(at: index)
        itemsArray.insert(itemToMove, at: toIndex)
        
        saveTodoItems()
    }
    
    // MARK: - Delete all TodoItem in SQL DataBase
    func deleteAllTodoItems() {
        let deleteFetch : NSFetchRequest<NSFetchRequestResult> = TodoItem.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error deleting all records in data model")
        }
    }
    
}

extension TodoeyViewController {
    
    //MARK: - TableView DataSource Methods
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = itemsArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let item = itemsArray[indexPath.row]
            destroy(todoItem: item)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override public func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override public func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let item = itemsArray[fromIndexPath.row]
        move(todoItem: item, toIndex: to.row)
    }
    
    //MARK: - TableView Delegate Methods
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsArray[indexPath.row]
        update(todoItem: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: SearchBar Delegate mathods
extension TodoeyViewController: UISearchBarDelegate {
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, text.count > 0 else { 
            fetchTodoItems()
            dismissKeyboard(with: searchBar)
            return 
        }
        let fetchRequest : NSFetchRequest<TodoItem> = TodoItem.fetchRequest()
        
        // look for items that contains this (searchbar.text) result
        // for more on predicates http://nshipster.com/nspredicate/
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", text)
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        fetchTodoItems(with: fetchRequest, predicate: predicate)
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

