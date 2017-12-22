//
//  ViewController.swift
//  ToDory
//
//  Created by Michael on 2017/12/19.
//  Copyright © 2017年 Michael. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListTableViewController: SwipeCellTableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var realm = try! Realm()
    
    var itemResult:Results<Item>?
    
    var selectedCategory:Category?{
        didSet{
            loadItemList()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    //MARK: - TABLEVIEW DATASOURCE
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemResult?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if let item = itemResult?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
            let percentage = CGFloat(indexPath.row)/CGFloat((itemResult?.count)!)
            if let color = UIColor(hexString:selectedCategory!.hexColor)?.darken(byPercentage: percentage)
            {
                print(percentage,selectedCategory!.hexColor)
                cell.backgroundColor = color
                cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        }else{
            cell.textLabel?.text = "No ToDo item add yet!!!"
        }
        
        return cell
    }
    //MARK: - TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemResult?[indexPath.row]{
            do{
                try realm.write {
                    //swaping done check mark
                    item.done = !item.done
                }
            }catch{
                print("Realm item done change status error: \(error)")
            }
            tableView.reloadData()
        }
    }
    //MARK: - Button Actions
    @IBAction func addItemBtn(_ sender: UIBarButtonItem) {
        var itemTextField = UITextField()
        let alert = UIAlertController(title: "Add Memo Item", message: "Add TODO item to the list", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let text = itemTextField.text, let currentCategory = self.selectedCategory {
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = text
                        newItem.dateOfCreate = Date()
                        currentCategory.items.append(newItem)
                    }
                }catch{
                    print("realm append item error: \(error)")
                }
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (textField) in
            itemTextField = textField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - save and  load item list to file
    func loadItemList(){
        itemResult = selectedCategory?.items.sorted(byKeyPath: "dateOfCreate", ascending: false)
        tableView.reloadData()
    }
    //MARK: - SWIPE cell for Deletion
    override func updateModels(at index: IndexPath) {
        super.updateModels(at: index)
        //delete item selected
        if let itemForDeletion = itemResult?[index.row]{
            do{
                try realm.write {
                    realm.delete(itemForDeletion)
                }
            }catch{
                print("delet swipe item error: \(error)")
            }
        }
    }
}

//MARK: - SearchBAR extension
extension ToDoListTableViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemResult = itemResult?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateOfCreate", ascending: false)
        tableView.reloadData()
    }
//        let request:NSFetchRequest<Item> = Item.fetchRequest()
//        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItemList(with: request, predicate: predicate)

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count == 0{
            loadItemList()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}



