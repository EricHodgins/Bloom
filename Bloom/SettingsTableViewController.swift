//
//  SettingsTableViewController.swift
//  Bloom
//
//  Created by Eric Hodgins on 2017-09-09.
//  Copyright © 2017 Eric Hodgins. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {

    fileprivate enum MetricChange {
        case weight
        case distance
        case speed
        case pace
        case none
    }
    
    fileprivate var metricChange: MetricChange = .none
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var weightButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var speedButton: UIButton!
    @IBOutlet weak var paceButton: UIButton!
    
    let userDefaults = UserDefaults.standard
    var isMetric: Bool = Locale.current.usesMetricSystem
    
    var weightPickerData = ["kg", "lbs"]
    var distancePickerData = ["km", "mi"]
    var speedPickerData = ["km/hr", "mi/hr"]
    var pacePickerData = ["min/km", "min/mi"]
    var selection: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        configureButtons()
        
    }
    
    @IBAction func customTapPressed(_ sender: Any) {
        pickerView.isHidden = true
        switch metricChange {
        case .weight:
            userDefaults.set(selection, forKey: "WeightUnit")
        case .distance:
            userDefaults.set(selection, forKey: "DistanceUnit")
        case .speed:
            userDefaults.set(selection, forKey: "SpeedUnit")
        case .pace:
            userDefaults.set(selection, forKey: "PaceUnit")
        default:
            break
        }
        
        configureButtons()
    }
    
    func configureButtons() {
        if userDefaults.object(forKey: "WeightUnit") == nil {
            if isMetric {
                weightButton.setTitle("kg", for: .normal)
            } else {
                weightButton.setTitle("lbs", for: .normal)
            }
        } else {
            let metric = userDefaults.value(forKey: "WeightUnit") as! String
            weightButton.setTitle(metric, for: .normal)
        }
        
        if userDefaults.object(forKey: "DistanceUnit") == nil {
            if isMetric {
                distanceButton.setTitle("km", for: .normal)
            } else {
                distanceButton.setTitle("mi", for: .normal)
            }
        } else {
            let metric = userDefaults.value(forKey: "DistanceUnit") as! String
            distanceButton.setTitle(metric, for: .normal)
        }

        
        if userDefaults.object(forKey: "SpeedUnit") == nil {
            if isMetric {
                speedButton.setTitle("km/hr", for: .normal)
            } else {
                speedButton.setTitle("mi/hr", for: .normal)
            }
        } else {
            let metric = userDefaults.value(forKey: "SpeedUnit") as! String
            speedButton.setTitle(metric, for: .normal)
        }

        
        if userDefaults.object(forKey: "PaceUnit") == nil {
            if isMetric {
                paceButton.setTitle("min/km", for: .normal)
            } else {
                paceButton.setTitle("min/mi", for: .normal)
            }
        } else {
            let metric = userDefaults.value(forKey: "PaceUnit") as! String
            paceButton.setTitle(metric, for: .normal)
        }

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func weightButtonPressed(_ sender: Any) {
        pickerView.isHidden = false
        selection = weightPickerData[pickerView.selectedRow(inComponent: 0)]
        metricChange = .weight
        pickerView.reloadAllComponents()
    }
    
    @IBAction func distanceButtonPushed(_ sender: Any) {
        pickerView.isHidden = false
        selection = distancePickerData[pickerView.selectedRow(inComponent: 0)]
        metricChange = .distance
        pickerView.reloadAllComponents()
    }
    
    @IBAction func speedButtonPushed(_ sender: Any) {
        pickerView.isHidden = false
        selection = speedPickerData[pickerView.selectedRow(inComponent: 0)]
        metricChange = .speed
        pickerView.reloadAllComponents()
    }
    
    @IBAction func paceButtonPushed(_ sender: Any) {
        pickerView.isHidden = false
        selection = pacePickerData[pickerView.selectedRow(inComponent: 0)]
        metricChange = .pace
        pickerView.reloadAllComponents()
    }
    
}


extension SettingsTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch metricChange {
        case .weight:
            return weightPickerData.count
        case .distance:
            return distancePickerData.count
        case .speed:
            return speedPickerData.count
        case .pace:
            return pacePickerData.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch metricChange {
        case .weight:
            return weightPickerData[row]
        case .distance:
            return distancePickerData[row]
        case .speed:
            return speedPickerData[row]
        case .pace:
            return pacePickerData[row]
        default:
            return ""
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch metricChange {
        case .weight:
            selection = weightPickerData[row]
        case .distance:
            selection = distancePickerData[row]
        case .speed:
            selection = speedPickerData[row]
        case .pace:
            selection = pacePickerData[row]
        default:
            selection = ""
        }
    }
}




















