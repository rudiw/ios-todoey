//
//  ViewController.swift
//  Todoey
//
//  Created by Rudi Wijaya on 26/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit

class VCTodoList: UITableViewController {
    
    var itemArray: [String] = ["Go to kitchen", "Make a coffe", "Come back"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoItemCell", for: indexPath);
        cell.textLabel?.text = itemArray[indexPath.row];
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected cell \(itemArray[indexPath.row])");
        
        let cell = tableView.cellForRow(at: indexPath);
        cell?.accessoryType = cell?.accessoryType == UITableViewCell.AccessoryType.checkmark ? UITableViewCell.AccessoryType.none : UITableViewCell.AccessoryType.checkmark
        
        tableView.deselectRow(at: indexPath, animated: true);
    }

    
    @IBAction func btnAddPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert);

        var txtField = UITextField();
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            print(txtField.text);
            self.itemArray.append(txtField.text!);
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

