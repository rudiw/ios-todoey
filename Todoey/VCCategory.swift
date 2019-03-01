//
//  VCCategory.swift
//  Todoey
//
//  Created by Rudi Wijaya on 27/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift
import SwipeCellKit
import ChameleonFramework


class VCCategory: SwipeTableViewController {
    
//    var categoryArray: [Category] = [Category]();
    var categoryArray: Results<Category>?;
    
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;
    let realm = try! Realm();

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories();
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if (self.categoryArray != nil) {
            if (self.categoryArray!.count > 0) {
                return self.categoryArray!.count;
            }
        }
        return 1;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (categoryArray != nil) {
            if (categoryArray!.count > 0) {
                performSegue(withIdentifier: "goToItems", sender: self);
            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vcItems = segue.destination as! VCTodoList;
        if let indexPath = self.tableView.indexPathForSelectedRow {
            vcItems.selectedCategory = self.categoryArray?[indexPath.row];
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath) as! SwipeTableViewCell;
    
        var category: Category?
        if (categoryArray != nil) {
            if (categoryArray!.count > 0) {
                category = categoryArray?[indexPath.row];
                
                cell.backgroundColor = UIColor(hexString: category?.colorHex ?? UIColor.randomFlat.hexValue());
                cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true);
                
                cell.delegate = self;
            } else {
                cell.delegate = nil;
            }
        } else {
            cell.delegate = nil;
        }
        
        cell.textLabel?.text = category?.name ?? "No categories added yet.";
        
        return cell;
    }
    
    override func removeRow(at indexPath: IndexPath) {
        if let deletingCategory = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(deletingCategory);
                    
                    if (self.categoryArray?.count ?? 0 > 0) {
                        tableView.deleteRows(at: [indexPath], with: .automatic);
                    } else {
                        print("no more categories");
                        tableView.reloadRows(at: [indexPath], with: .automatic);
                    }
                    
                }
            } catch {
                print("Failed to remove category: \(error)");
            }
        }
    }
    
    
//    func loadCategories(with reqCategories: NSFetchRequest<Category> = Category.fetchRequest()) {
//        do {
//            self.categoryArray = try context.fetch(reqCategories);
//        } catch {
//            print("Faile to load categories: \(error)");
//        }
//        self.tableView.reloadData();
//    }
    
    func loadCategories() {
        do {
            self.categoryArray = try realm.objects(Category.self);
        } catch {
            print("Failed to load categories: \(error)");
        }
        self.tableView.reloadData();
    }
    
    @IBAction func btnAddPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert);
        var txtCategory: UITextField = UITextField();
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
//            let category = Category(context: self.context);
            
            let newCategory = Category();
            newCategory.name = txtCategory.text!;
            newCategory.colorHex = UIColor.randomFlat.hexValue();

//            self.categoryArray.append(newCategory);

            self.saveCategories(category: newCategory);
        }
        alert.addAction(action);
        alert.addTextField { (txt) in
            txt.placeholder = "New Category";
            
            txtCategory = txt;
        }
        
        present(alert, animated: true, completion: nil);
        
    }
    
    func saveCategories(category: Category) {
        do {
//            try context.save();
            try realm.write {
                realm.add(category);
            }
        } catch {
            print("Failed to save categories: \(error)");
        }
        
        self.tableView.reloadData();
    }
    
}


