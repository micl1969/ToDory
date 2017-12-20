//
//  CategoryTableViewController.swift
//  ToDory
//
//  Created by Michael on 2017/12/20.
//  Copyright © 2017年 Michael. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var nameArray:[Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNameList()
    }
    //MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = nameArray[indexPath.row].name
        
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
                destinationVC.selectedCategory = nameArray[indexPath.row]
            }
            
        }
    }
    
    //MARK: - Button Actions
    @IBAction func addBtnTapped(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let alert = UIAlertController(title: "Add Memo Name", message: "Add TODO Name to the list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Name", style: .default) { (action) in
            if let text = itemTextField.text {
                let newName = Category(context: self.context)
                newName.name = text
                self.nameArray.append(newName)
                self.saveNameList()
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
    func saveNameList(){
        do{
            try context.save()
        }catch{
            print("Error saveing context \(error)")
        }
    }
    func loadNameList(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        do{
            nameArray = try context.fetch(request)
        }catch{
            fatalError("Fetch core data error \(error)")
        }
        tableView.reloadData()
    }
    

}
