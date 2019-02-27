//
//  ViewController.swift
//  Todoey
//
//  Created by Rudi Wijaya on 26/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit

class VCTodoList: UITableViewController {
    
    var itemArray: [Item] = [Item]();
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        print("Data file path: \(dataFilePath)");
     
        loadItems();
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "todoItemCell");
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath);
        cell.textLabel?.text = itemArray[indexPath.row].title;
        cell.accessoryType = itemArray[indexPath.row].done ? .checkmark : .none;
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected cell \(itemArray[indexPath.row])");
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        self.saveItems();
        
        tableView.reloadData();
        
        tableView.deselectRow(at: indexPath, animated: true);
    }

    
    @IBAction func btnAddPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert);

        var txtField = UITextField();
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            print(txtField.text);
            let item = Item();
            item.title = txtField.text!;
            self.itemArray.append(item);
            
            self.saveItems();
            
            self.tableView.reloadData();
            
        };
        alert.addAction(action);
        alert.addTextField { (alertTxtField) in
            txtField = alertTxtField;
            alertTxtField.placeholder = "Create new item";
        }
        
        present(alert, animated: true, completion: nil);
        
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder();
        do {
            let data = try encoder.encode(self.itemArray);
            try data.write(to: self.dataFilePath!)
        } catch {
            print("Failed to encod data to document: \(error)");
        }
    }
    
    func loadItems() {
        do {
            if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder();
                self.itemArray = try decoder.decode([Item].self, from: data);
            }
        } catch {
            print("Failed to load items: \(error)");
        }
    }
    
    
}

