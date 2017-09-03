//
//  CreateDataManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-02.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

class CreateDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var excerciseNames: [String] = []
    let isSearching: Bool
    let tableView: UITableView!
    
    var selectedRows: [Bool] = []
    
    init(withManagedContext managedContext: NSManagedObjectContext, isSearching: Bool, tableView: UITableView) {
        self.isSearching = isSearching
        self.tableView = tableView
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if isSearching {
            guard let names = BloomFilter.fetchAllExcercises(inManagedContext: managedContext) else { return }
            self.tableView.allowsMultipleSelection =  true
            selectedRows = Array(repeating: false, count: names.count)
            excerciseNames = names
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return excerciseNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = excerciseNames[indexPath.row]
        cell.textLabel?.textColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        
        if selectedRows[indexPath.row] == true {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            selectedRows[indexPath.row] = true
        }
    }
}
