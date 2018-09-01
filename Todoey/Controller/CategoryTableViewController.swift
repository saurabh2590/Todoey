//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Saurabh Gupta on 01.09.18.
//  Copyright © 2018 Saurabh Gupta. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    var categoryList = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        loadCategory()
    }

    //MARK: TableView Data provider
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryList[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    //MARK: Table Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("table item was clicked")
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destination.selectedCategory = categoryList[indexPath.row]
        }
    }
    //MARK: Table Data Manipulation with data
    
    func loadCategory() {
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        do {
            categoryList = try context.fetch(request)
        } catch {
            print("Cannot load data due to \(error)")
        }
    }
    
    func saveCategory() {
        do {
            try context.save()
        } catch {
            print("Cannot save due to \(error)")
        }
        self.tableView.reloadData()
    }
    
    //MARK: Add add button handler
    
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        print("add button pressed")
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.categoryList.append(newCategory)
            self.saveCategory()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type in new category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}
