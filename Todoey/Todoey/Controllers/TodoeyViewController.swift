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
    var itemsArray = [TodoItem]()
    let itemsArrayKey = "ToDoListArray"
    let dataFilePath : URL? = FileManager
        .default
        .urls(for: .documentDirectory, in: .userDomainMask)
        .first?.appendingPathComponent("TodoItems.plist")
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Add new ToDoey Item", 
                                                message: "", 
                                                preferredStyle: .alert)
        // Create the actions
        let action1 = UIAlertAction(title: "Add Item", style: .default) { [unowned self] action in
            guard let text = textfield.text else { return }
            self.addItemInTodoList(with: text)
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
    
    //MARK: - Model manipulation
    func addItemInTodoList( with item : String){
        let todoItem = TodoItem(title: item, done: false)
        itemsArray.append(todoItem)
        saveItemInTodoList(with: todoItem)
    }
    
    func saveItemInTodoList(with item : TodoItem) {
        guard let dataUrl = dataFilePath else { return }
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemsArray)
            try data.write(to: dataUrl)
            tableView.reloadData()
        }catch {
            print("Encoding Error: Could not create todo list property list", error)
        }
    }
    
    func loadTodoListItems() {
        if let dataUrl = dataFilePath, let data = try? Data(contentsOf: dataUrl) {
            do {
                let encoder = PropertyListDecoder()
                itemsArray = try encoder.decode([TodoItem].self, from: data)
            } catch {
                print("Error decoding item array, \(error)")
            }
        }
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadTodoListItems()
    }
}

extension TodoeyTableViewController {
    
    //MARK: - TableView DataSource Methods
    
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
    
    //MARK: - TableView Delegate Methods
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itemsArray[indexPath.row]
        itemsArray[indexPath.row].done = !item.done
        saveItemInTodoList(with: item)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
