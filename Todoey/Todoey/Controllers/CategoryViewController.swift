//
//  CategoryViewController.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 08/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import RealmSwift

public class CategoryViewController: UITableViewController {

    var realm : Realm {
        return AppDelegate.realm
    }
    
    let cellIdentifier = "categoryCell"
    let segueIdentifier = "gotoItems"
    var categories : Results<Category>?
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        // Create the alert controller
        let alertController = UIAlertController(title: "Add New Category", 
                                                message: "", 
                                                preferredStyle: .alert)
        // Create the actions
        let action1 = UIAlertAction(title: "Add", style: .default) { [unowned self] action in
            guard let text = textfield.text else { return }
            self.add(categoryItem: text)
        }
        let action2 = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancel")
        }
        alertController.addTextField { alertTextfield in
            alertTextfield.placeholder = "Create new Category"
            textfield = alertTextfield
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        present(alertController, animated: true, completion: nil)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     
        fetchCategoryItems()
    }
}


//MARK: - CoreData SQL DataBase implemetation
extension CategoryViewController {
    
    // MARK: - Create a new category item in Realm DataBase
    func add(categoryItem category : String){
        let categoryItem = Category(name: category)
        do {
            try realm.write {
                realm.add(categoryItem)
            }
            tableView.reloadData()
        }catch {
            print("Error saving context", error)
        }
    }
    
    // MARK: - Read from category Realm DataBase
    func fetchCategoryItems() {
        categories = realm.objects(Category.self) 
        tableView.reloadData()
    }
    
    // MARK: - Destroy category item in Realm DataBase
    func destroy(categoryItem category: Category) {
        do {
            try realm.write {
                realm.delete(category)
                tableView.reloadData()
            }
        } catch {
            print("Error deleting todo item in Realm \(error)")
        }
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

extension CategoryViewController {
    
    //MARK: - TableView DataSource Methods
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 1
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No category added yet"
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let category = categories?[indexPath.row] {
                destroy(categoryItem: category)
            }
        } 
    }
 
    //MARK: - TableView Delegate Methods
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
    // MARK: - Navigation
     
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == segueIdentifier {
            if let destinationVC = segue.destination as? TodoeyViewController,
                let indexPath = tableView.indexPathForSelectedRow, 
                let category = categories?[indexPath.row] {
                destinationVC.selectedCategory = category
                destinationVC.title = category.name + " Items"
            }
        }
    }
    
}
