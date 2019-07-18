//
//  ViewController.swift
//  Todoey
//
//  Created by Tanaka Mazivanhanga on 7/18/19.
//  Copyright © 2019 Tanaka Mazivanhanga. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var items = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let defaults = UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadItems()

        
        print(dataFilePath!)
//        if let items1 = defaults.array(forKey: "TodoListArray")  as? [Item]{
//            items = items1
//        }
        // Do any additional setup after loading the view.
    }
    func loadItems(){
        
        if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
        do {
            items = try decoder.decode([Item].self, from: data)
        } catch  {
            print("\(error)")
        }
        }
    }
    
    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath)
        let item = items[indexPath.row]
        cell.textLabel?.text = item.title
//        lengthy if else
//        if item.done {
//             cell.accessoryType = .checkmark
//        }else{
//             cell.accessoryType = .none
//        }
        cell.accessoryType = item.done ? .checkmark: .none
        
        return cell
    }
    
    //MARK - Tableview Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
         let item = items[indexPath.row]
//        if item.done == false{
//            item.done = true
//        }else{
//            item.done = false
//        }
        item.done = !item.done
        saveItems(filePath: dataFilePath!)
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK - Add new Item
    func saveItems(filePath: URL){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.items)
            try data.write(to: filePath)
            
        }catch{
            print("error encoding\(error)")
        }
        self.tableView.reloadData()
    
    }
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = textField.text{
                //self.itemArray.append(text)
                self.items.append(Item(title: text))
                self.saveItems(filePath: self.dataFilePath!)
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

