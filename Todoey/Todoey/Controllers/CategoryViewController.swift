//
//  CategoryViewController.swift
//  Todoey
//
//  Created by GEORGE QUENTIN on 08/01/2018.
//  Copyright © 2018 Geo Games. All rights reserved.
//

import UIKit
import CoreData

public class CategoryViewController: UITableViewController {

    let context = 
        (UIApplication.shared.delegate as! AppDelegate)
            .persistentContainer
            .viewContext
    
    let cellIdentifier = "categoryCell"
    let segueIdentifier = "gotoItems"
    var categories = [Category]()
    
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
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory,in: .userDomainMask))
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchCategoryItems()
    }
}


//MARK: - CoreData SQL DataBase implemetation
extension CategoryViewController {
    
    // MARK: - Create new category item in SQL DataBase
    func add(categoryItem category : String){
        let categoryItem = Category(context: context)
        categoryItem.name = category
        
        categories.append(categoryItem)
        saveCategory()
    }
    
    // MARK: - Save categories changes in SQL DataBase
    func saveCategory() {
        do {
            try context.save()
            tableView.reloadData()
        }catch {
            print("Error saving context", error)
        }
    }
    
    // MARK: - Read from category SQL DataBase
    func fetchCategoryItems(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch let error as NSError {
            print("Could not fetch data from context. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    // MARK: - Destroy category item in SQL DataBase
    func destroy(categoryItem category: Category) {
        guard let index = categories.index(of: category) else { return }
        categories.remove(at: index)
        context.delete(category)
        saveCategory()
    }
   
    
    // MARK: - Delete all category items in SQL DataBase
    func deleteAllCategoryItems() {
        let deleteFetch : NSFetchRequest<NSFetchRequestResult> = Category.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
        } catch {
            print ("There was an error deleting all records in data model")
        }
    }
    
}

extension CategoryViewController {
    
    //MARK: - TableView DataSource Methods
    
    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let category = categories[indexPath.row]
            destroy(categoryItem: category)
            //tableView.deleteRows(at: [indexPath], with: .fade)
        } 
    }
 
    //MARK: - TableView Delegate Methods
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: segueIdentifier, sender: self)
    }
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == segueIdentifier {
            if let destinationVC = segue.destination as? TodoeyViewController,
                let indexPath = tableView.indexPathForSelectedRow {
                let category = categories[indexPath.row]
                destinationVC.selectedCategory = category
                destinationVC.title = (category.name ?? "") + " Items"
            }
            
        }
    }
    
}
