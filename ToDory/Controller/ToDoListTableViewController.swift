//
//  ViewController.swift
//  ToDory
//
//  Created by Michael on 2017/12/19.
//  Copyright © 2017年 Michael. All rights reserved.
//

import UIKit
import CoreData

class ToDoListTableViewController: UITableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    var itemArray:[Item] = []
    var selectedCategory:Category?{
        didSet{
            loadItemList()
        }
    }
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    //MARK: - TABLEVIEW DATASOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    //MARK: - TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        context.delete(itemArray[indexPath.row])
        itemArray.remove(at: indexPath.row)
        //itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItemList()
        tableView.reloadData()
    }

    //MARK: - Button Actions
    @IBAction func addItemBtn(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let alert = UIAlertController(title: "Add Memo Item", message: "Add TODO item to the list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = itemTextField.text {
                let newItem = Item(context: self.context)
                newItem.title = text
                newItem.done = false
                newItem.parentCategory = self.selectedCategory
                self.itemArray.append(newItem)
                self.saveItemList()
                //self.defaultData.set(self.itemArray, forKey: "ToDoListArray")
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
    func saveItemList(){
        do{
            try context.save()
        }catch{
            print("Error saveing context \(error)")
        }
    }
    func loadItemList(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate:NSPredicate? = nil){
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [additionalPredicate,categoryPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        do{
            itemArray = try context.fetch(request)
        }catch{
            fatalError("Fetch core data error \(error)")
        }
        tableView.reloadData()
    }
}
//MARK: - SearchBAR extension
extension ToDoListTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request:NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]

        loadItemList(with: request, predicate: predicate)

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            loadItemList()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


