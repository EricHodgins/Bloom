//
//  CreateDataManager.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-02.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit
import CoreData

protocol CreateDataManagerDelegate: class {
    func createDataManagerCellSelectedInAddExcerciseView(excerciseTemplate: ExcerciseTemplate)
}


class CreateDataManager: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var excerciseTemplates: [ExcerciseTemplate] = []
    let isSearching: Bool
    let tableView: UITableView!
    
    var selectedRows: [Bool] = []
    var detailCell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
    
    weak var delegate: CreateDataManagerDelegate?
    
    init(withManagedContext managedContext: NSManagedObjectContext, isSearching: Bool, tableView: UITableView, withExcerciseTemplates templates: [ExcerciseTemplate]?) {
        self.isSearching = isSearching
        self.tableView = tableView
        super.init()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        if isSearching {
            guard let exercises = BloomFilter.fetchAllExcercises(inManagedContext: managedContext) else { return }
            self.tableView.allowsMultipleSelection =  true
            selectedRows = Array(repeating: false, count: exercises.count)
            excerciseTemplates = exercises
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        } else {
            guard let excercises = templates else { return }
            excerciseTemplates = excercises
            tableView.isEditing = true
            tableView.allowsSelectionDuringEditing = true
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return excerciseTemplates.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //TODO: - Don't like this; will need a custom cell eventually
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        let excercise = excerciseTemplates[indexPath.row]
        let name = "\(excercise.name ?? "")"
        var detailText = "\(excercise.isRecordingSets ? "S" : "") "
        detailText += "\(excercise.isRecordingReps ? "R" : "") "
        detailText += "\(excercise.isRecordingWeight ? "W" : "") "
        detailText += "\(excercise.isRecordingDistance ? "D" : "") "
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = detailText
        cell.textLabel?.textColor = UIColor.white
        cell.tintColor = UIColor.white
        cell.backgroundColor = UIColor.clear
        
        if isSearching {
            if selectedRows[indexPath.row] == true {
                let backgroundView = GradientView()
                backgroundView.startColor = UIColor.addStart
                backgroundView.endColor = UIColor.addEnd
                cell.selectedBackgroundView = backgroundView
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isSearching {
            if let cell = tableView.cellForRow(at: indexPath) {
                let backgroundView = GradientView()
                backgroundView.startColor = UIColor.addStart
                backgroundView.endColor = UIColor.addEnd
                cell.selectedBackgroundView = backgroundView
                cell.accessoryType = .checkmark
                selectedRows[indexPath.row] = true
            }
        }
        
        if !isSearching {
            if let _ = tableView.cellForRow(at: indexPath) {
                let template = excerciseTemplates[indexPath.row]
                delegate?.createDataManagerCellSelectedInAddExcerciseView(excerciseTemplate: template)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if isSearching {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        excerciseTemplates.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if !isSearching {
            let movedWorkout = excerciseTemplates[sourceIndexPath.row]
            excerciseTemplates.remove(at: sourceIndexPath.row)
            excerciseTemplates.insert(movedWorkout, at: destinationIndexPath.row)
        }
    }
    
    
    public func fetchChosenExercises() -> [ExcerciseTemplate]? {
        var choosen: [ExcerciseTemplate] = []
        
        if isSearching {
            for (isChoosen, name) in zip(selectedRows, excerciseTemplates) {
                if isChoosen {
                    choosen.append(name)
                }
            }
        } else {
            choosen = excerciseTemplates
        }
        
        if choosen.count == 0 { return nil }
        return choosen
    }
}



















