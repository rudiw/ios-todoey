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
    
    let defaults = UserDefaults.standard;

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        if let upItemArray = defaults.array(forKey: "itemArray") as? [Item] {
//            self.itemArray = upItemArray;
//        }
//        let item1 = Item();
//        item1.title = "go to kitchen";
//        itemArray.append(item1);
//
//        let item2 = Item();
//        item2.title = "go to kitchen";
//        item2.done = true;
//        itemArray.append(item2);
//
//        let item3 = Item();
//        item3.title = "go to kitchen";
//        itemArray.append(item3);
        
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
            
            self.defaults.setValue(self.itemArray, forKey: "itemArray");
            
            self.tableView.reloadData();
            
        };
        alert.addAction(action);
        alert.addTextField { (alertTxtField) in
            txtField = alertTxtField;
            alertTxtField.placeholder = "Create new item";
        }
        
        present(alert, animated: true, completion: nil);
        
    }
    
    
}

