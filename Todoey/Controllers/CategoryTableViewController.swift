//
//  CategoryTableViewController.swift
//  Todoey
//
//  Created by Tanaka Mazivanhanga on 7/19/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    let realm = try! Realm()
    
    var categories: Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }
    
    func loadCategories(){
        categories = realm.objects(Category.self)
        tableView.reloadData()
        
    }
    
    func saveCategories(withCategory category: Category){
        
        do{
            try realm.write {
                realm.add(category)
            }
            
        }catch{
            print("error saving context \(error)")
        }
        self.tableView.reloadData()
        
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            if let text = textField.text{
                //self.itemArray.append(text)
                if text != ""{
                    let newCategory = Category()
                    newCategory.name = text
                    
                    
                    self.saveCategories(withCategory: newCategory)
                }else{
                    textField.endEditing(true)
                    
                }
            }
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
//    func fetchRequest(request: NSFetchRequest<Category>){
//        do {
//            categories = try context.fetch(request)
//        } catch  {
//            print("error \(error)")
//        }
//
//    }
    
    
    
    
    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        if let category = categories?[indexPath.row]{
        cell.textLabel?.text = category.name
        }else{
            cell.textLabel?.text = "No Categories Added Yet"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "gotoItem", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow, let category = categories?[indexPath.row]{
            
            destinationVC.selectedCategory = category
        }
    }
    

  
}
