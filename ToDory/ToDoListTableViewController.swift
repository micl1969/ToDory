//
//  ViewController.swift
//  ToDory
//
//  Created by Michael on 2017/12/19.
//  Copyright © 2017年 Michael. All rights reserved.
//

import UIKit

class ToDoListTableViewController: UITableViewController {

    let itemArray = ["egg","milk","soup"]
    override func viewDidLoad() {
        super.viewDidLoad()
  
    }
    //MARK: - TABLEVIEW DATASOURCE
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    //MARK: - TABLEVIEW DELEGATE
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }else{
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath , animated: true)
    }
}

