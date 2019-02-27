//
//  VCCategory.swift
//  Todoey
//
//  Created by Rudi Wijaya on 27/02/19.
//  Copyright © 2019 Rudi Wijaya. All rights reserved.
//

import UIKit
import CoreData


class VCCategory: UITableViewController {
    
    var categoryArray: [Category] = [Category]();
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext;

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories();
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categoryArray.count;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self);
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vcItems = segue.destination as! VCTodoList;
        if let indexPath = self.tableView.indexPathForSelectedRow {
            vcItems.selectedCategory = self.categoryArray[indexPath.row];
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath);
        
        let category = categoryArray[indexPath.row];
        
        cell.textLabel?.text = category.name;
        
        return cell;
    }
    
    func loadCategories(with reqCategories: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            self.categoryArray = try context.fetch(reqCategories);
        } catch {
            print("Faile to load categories: \(error)");
        }
        self.tableView.reloadData();
    }
    
    @IBAction func btnAddPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert);
        var txtCategory: UITextField = UITextField();
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let category = Category(context: self.context);
            category.name = txtCategory.text;
            
            self.categoryArray.append(category);
            
            self.saveCategories();
        }
        alert.addAction(action);
        alert.addTextField { (txt) in
            txt.placeholder = "New Category";
            
            txtCategory = txt;
        }
        
        present(alert, animated: true, completion: nil);
        
    }
    
    func saveCategories() {
        do {
            try context.save();
        } catch {
            print("Failed to save categories: \(error)");
        }
        
        self.tableView.reloadData();
    }
    
}
