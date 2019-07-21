//
//  ViewController.swift
//  Todoey
//
//  Created by Tanaka Mazivanhanga on 7/18/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    var items : Results<Item>?
    let realm = try! Realm()
    var selectedCategory: Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    func loadItems(){
        //soecify data type
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            
            cell.accessoryType = item.done ? .checkmark: .none
        }else{
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        if let item = items?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                    
                }
           
            }catch{
                
            }
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            
            
            do {
                if let item = items?[indexPath.row] {
                    try realm.write {
                         realm.delete(item)
                    }
                }
                
            }
            catch{
                
            }
            
        }
        self.tableView.reloadData()
        
    }
    //MARK - Add new Item
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text{
                //self.itemArray.append(text)
                if text != ""{
                    if let currentCategory = self.selectedCategory{
                        do{
                            try self.realm.write {
                                let newItem = Item()
                                newItem.title = text
                                newItem.dateCreated = Date()
                                
                                currentCategory.items.append(newItem)
                            }
                            
                        }catch{
                            print("error saving context \(error)")
                        }
                    }
                    self.tableView.reloadData()
                }else{
                    textField.endEditing(true)
                    
                    
                }
            }
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    
}
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            if searchText == ""{
                searchBar.endEditing(true)
            }else{
                items  = items?.filter("title CONTAINS[cd] %@", searchText).sorted(byKeyPath: "dateCreated", ascending: true)
                tableView.reloadData()
            }
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

