//
//  CategoryViewController.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 08/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import RealmSwift
import Chameleon

public class CategoryViewController: SwipeTableViewController {

    let originalColor = UIColor.randomFlat()
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
            guard let text = textfield.text, let randomColor = UIColor.randomFlat().hexValue() else { return }
            self.add(categoryItem: text, color: randomColor)
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
  
        if let colorHex = originalColor?.hexValue() {
            updateNavBar(withHexColor: colorHex)
        }
        
        fetchCategoryItems()
    }
    
    //MARK: - update swipe model
    override func updateCellDeleteAction(at indexPath: IndexPath ) {
        super.updateCellDeleteAction(at: indexPath)
        if let category = self.categories?[indexPath.row] {
            self.delete(categoryItem: category, reload: false)
        }
    }
}


//MARK: - CoreData SQL DataBase implemetation
extension CategoryViewController {
    
    // MARK: - Create a new category item in Realm DataBase
    func add(categoryItem category : String, color : String){
        let categoryItem = Category(name: category, color: color)
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
    
    // MARK: - Delete category item in Realm DataBase
    func delete(categoryItem category: Category, reload : Bool = true ) {
        do {
            try realm.write {
                realm.delete(category)
                if reload {
                    tableView.reloadData()
                }
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
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        let category = categories?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No category added yet"
        cell.backgroundColor = UIColor(hexString: category?.color ?? "1D9BF6")
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor ?? .white, returnFlat: true)
        return cell
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
