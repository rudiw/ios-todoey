//
//  ViewController.swift
//  Todoey
//
//  Created by Rudi Wijaya on 26/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit


class VCTodoList: SwipeTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    let realm = try! Realm();
    
    var selectedCategory: Category? {
        didSet {
            loadItems();
        }
    }
//    var itemArray: [Item] = [Item]();
    var itemArray: Results<Item>?;
    
//    use user defaults
    //var itemArray: [String] = ["Go to kitchen", "Make a coffe", "Come back"]
//    let defaults = UserDefaults.standard;
    
//    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist");
    
//    let context = ( (UIApplication.shared.delegate) as! AppDelegate ).persistentContainer.viewContext;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self;
        
//        print("Data file path: \(dataFilePath)");
//        print("document dir: \(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first)")
     
//        loadItems();
        
//        use user defaults
//        itemArray = defaults.stringArray(forKey: "itemArray") ?? [String]()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (itemArray != nil && itemArray!.count > 0) {
            return itemArray!.count;
        }
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "todoItemCell");
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! SwipeTableViewCell;
        
        if (itemArray?.count ?? 0 > 0 ) {
            let item = itemArray![indexPath.row]
            
            cell.textLabel?.text = item.title;
            cell.accessoryType = item.done ? .checkmark : .none;
            
            cell.delegate = self;
        } else {
            cell.textLabel?.text = "No items added yet.";
            cell.accessoryType = .none;
            
            cell.delegate = nil;
        }
        
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected cell \(itemArray[indexPath.row])");
        
//        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        if (itemArray?.count ?? 0 > 0 ) {
            let item = itemArray![indexPath.row]
      
            do {
                try realm.write {
                    item.done = !item.done;
//                    try realm.delete(item);
                }
            } catch {
                print("Failed to update item: \(error)");
            }
        }
        
//        tableView.reloadData();
        tableView.beginUpdates();
        
        tableView.reloadRows(at: [indexPath], with: .automatic);
        
//        if (itemArray?.count ?? 0 > 0) {
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//        } else {
//            tableView.reloadRows(at: [indexPath], with: .automatic)
//        }
        
        tableView.endUpdates();
        
//        context.delete(itemArray[indexPath.row]);
//        self.itemArray.remove(at: indexPath.row);
        
//        self.saveItems();

//use user defaults
//        self.itemArray.append(txtField.text!);
//        self.defaults.setValue(self.itemArray, forKey: "itemArray");
        
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    override func removeRow(at indexPath: IndexPath) {
        if (itemArray?.count ?? 0 > 0 ) {
            let item = itemArray![indexPath.row]
            
            do {
                try realm.write {
                    realm.delete(item);
                    
                    if (self.itemArray?.count ?? 0 > 0) {
                        tableView.deleteRows(at: [indexPath], with: .automatic);
                    } else {
                        print("no more categories");
                        tableView.reloadRows(at: [indexPath], with: .automatic);
                    }
                }
            } catch {
                print("Failed to update item: \(error)");
            }
        }
    }

    
    @IBAction func btnAddPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert);

        var txtField = UITextField();
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
//            print(txtField.text);
            
//            let item = Item(context: self.context);
            if let curCategor = self.selectedCategory {
                do {
                    try self.realm.write {
                        let item = Item();
                        item.title = txtField.text!;
                        item.dateCreated = Date();
                        curCategor.items.append(item);
                    }
                } catch {
                    print("Failed to save items: \(error)");
                }
                
            }
            
            self.tableView.reloadData();
            
//            self.itemArray.append(item);
    
//            self.saveItems();
            
        };
        alert.addAction(action);
        alert.addTextField { (alertTxtField) in
            txtField = alertTxtField;
            alertTxtField.placeholder = "Create new item";
        }
        
        present(alert, animated: true, completion: nil);
        
    }
    
//    func saveItems() {
////        let encoder = PropertyListEncoder();
////        do {
////            let data = try encoder.encode(self.itemArray);
////            try data.write(to: self.dataFilePath!)
////        } catch {
////            print("Failed to encod data to document: \(error)");
////        }
//
//        do {
//            try context.save()
//        } catch {
//            print("Failed to save items: \(error)");
//        }
//
//        tableView.reloadData();
//    }
    
    func loadItems() {
        itemArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true);
        
        tableView.reloadData();
    }
    
//    func loadItems(with reqItems: NSFetchRequest<Item> = Item.fetchRequest()) {
////        do {
////            if let data = try? Data(contentsOf: dataFilePath!) {
////                let decoder = PropertyListDecoder();
////                self.itemArray = try decoder.decode([Item].self, from: data);
////            }
////        } catch {
////            print("Failed to load items: \(error)");
////        }
//
//        do {
//            let predicateByCategory = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!);
//
//            if let predicate = reqItems.predicate {
//
//                let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicateByCategory])
//                reqItems.predicate = compound;
//            } else {
//                reqItems.predicate = predicateByCategory;
//            }
//
//
//            self.itemArray = try context.fetch(reqItems);
//
//            self.tableView.reloadData();
//        } catch {
//            print("Failed to fetch items: \(error)");
//        }
//    }
    
}

extension VCTodoList: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let reqItems: NSFetchRequest<Item> = Item.fetchRequest();
////        print("reqItems: \(reqItems)");
////        print("searchBar.text: \(searchBar.text)");
//
//        if (searchBar.text != nil && searchBar.text != "") {
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!);
//            reqItems.predicate = predicate;
//        }
//
//        let sort = NSSortDescriptor(key: "title", ascending: true);
//        reqItems.sortDescriptors = [sort];
//
//        loadItems(with: reqItems);
        
        itemArray = itemArray?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true);
        
        tableView.reloadData()
        
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

