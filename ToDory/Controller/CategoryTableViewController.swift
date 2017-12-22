//
//  CategoryTableViewController.swift
//  ToDory
//
//  Created by Michael on 2017/12/20.
//  Copyright © 2017年 Michael. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryTableViewController: SwipeCellTableViewController {
    
    let realm = try! Realm()
    
    var nameResult:Results<Category>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNameList()
        
    }
    //MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameResult?.count ?? 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        cell.textLabel?.text = nameResult?[indexPath.row].name ?? "no Category"
        let color = UIColor(hexString: nameResult?[indexPath.row].hexColor ?? "6666FF")!
        cell.backgroundColor = color
        cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
        return cell
    }
    //MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showItemsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemsSegue"{
            
            let destinationVC = segue.destination as! ToDoListTableViewController
            if let indexPath = tableView.indexPathForSelectedRow{
                destinationVC.selectedCategory = nameResult?[indexPath.row]
            }
            
        }
    }
    
    //MARK: - Button Actions
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let alert = UIAlertController(title: "Add Memo Name", message: "Add TODO Name to the list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            if let text = itemTextField.text {
                let newName = Category()
                newName.name = text
                newName.hexColor = UIColor.randomFlat.hexValue()
                self.save(category:newName)
                self.tableView.reloadData()
            }
        }
        alert.addTextField { (textField) in
            itemTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - save and  load item list to file
    func save(category:Category){
        do{
            try realm.write {
                realm.add(category)
            }
        }catch{
            print("Error saveing Realm \(error)")
        }
    }
    func loadNameList(){
        
        nameResult = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    //MARK: - delete data from swipe
    override func updateModels(at index: IndexPath) {
        super.updateModels(at: index)
        if let categoryForDeletion = nameResult?[index.row]{
            do{
                try realm.write {
                    realm.delete(categoryForDeletion)
                }
            }catch{
                print("delete category error \(error)")
            }
        }
    }
}


