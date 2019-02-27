//
//  ViewController.swift
//  Todoey
//
//  Created by Rudi Wijaya on 26/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import CoreData

class VCTodoList: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var itemArray: [Item] = [Item]();
    
//    use user defaults
    //var itemArray: [String] = ["Go to kitchen", "Make a coffe", "Come back"]
//    let defaults = UserDefaults.standard;
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    
    let context = ( (UIApplication.shared.delegate) as! AppDelegate ).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self;
        
//        print("Data file path: \(dataFilePath)");
        print("document dir: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)")
     
        loadItems();
        
//        use user defaults
//        itemArray = defaults.stringArray(forKey: "itemArray") ?? [String]()
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
        
//        context.delete(itemArray[indexPath.row]);
//        self.itemArray.remove(at: indexPath.row);
        
        self.saveItems();

//use user defaults
//        self.itemArray.append(txtField.text!);
//        self.defaults.setValue(self.itemArray, forKey: "itemArray");
        
        tableView.deselectRow(at: indexPath, animated: true);
    }

    
    @IBAction func btnAddPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert);

        var txtField = UITextField();
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            print(txtField.text);
            
            let item = Item(context: self.context);
            item.title = txtField.text!;
            item.done = false;
            self.itemArray.append(item);
            
            self.saveItems();
            
            
        };
        alert.addAction(action);
        alert.addTextField { (alertTxtField) in
            txtField = alertTxtField;
            alertTxtField.placeholder = "Create new item";
        }
        
        present(alert, animated: true, completion: nil);
        
    }
    
    func saveItems() {
//        let encoder = PropertyListEncoder();
//        do {
//            let data = try encoder.encode(self.itemArray);
//            try data.write(to: self.dataFilePath!)
//        } catch {
//            print("Failed to encod data to document: \(error)");
//        }
        
        do {
            try context.save()
        } catch {
            print("Failed to save items: \(error)");
        }
        
        tableView.reloadData();
    }
    
    func loadItems(with reqItems: NSFetchRequest<Item> = Item.fetchRequest()) {
//        do {
//            if let data = try? Data(contentsOf: dataFilePath!) {
//                let decoder = PropertyListDecoder();
//                self.itemArray = try decoder.decode([Item].self, from: data);
//            }
//        } catch {
//            print("Failed to load items: \(error)");
//        }
        
        do {
            self.itemArray = try context.fetch(reqItems);
            
            self.tableView.reloadData();
        } catch {
            print("Failed to fetch items: \(error)");
        }
    }
    
}

extension VCTodoList: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let reqItems: NSFetchRequest<Item> = Item.fetchRequest();
//        print("reqItems: \(reqItems)");
//        print("searchBar.text: \(searchBar.text)");
        
        if (searchBar.text != nil && searchBar.text != "") {
            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
            reqItems.predicate = predicate;
        }
        
        let sort = NSSortDescriptor(key: "title", ascending: true);
        reqItems.sortDescriptors = [sort];
        
        loadItems(with: reqItems);
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchBar.text?.count == 0) {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder();
            }
        }
    }
}

