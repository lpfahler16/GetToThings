//
//  TodayViewController.swift
//  GetToThingsWidget
//
//  Created by Logan Pfahler on 6/28/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noText: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    
    var returnedMissions:[Thing] = []
    var returnedGoals:[Thing] = []
    var returnedRecurs:[RecurringThing] = []
    let headerNames = ["Missions", "Goals"]
    var returnedThings:[Thing] = []
    var numRows = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        returnedMissions = ExtensionControl.getTodayMissions()
        returnedGoals = ExtensionControl.getTodayGoals()
        returnedRecurs = ExtensionControl.getTodayRecurs()
        
        returnedThings = returnedMissions + returnedGoals
        
        mainTable.delegate = self
        mainTable.dataSource = self
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    //MARK: - Widget Specific Functionss
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        returnedMissions = ExtensionControl.getTodayMissions()
        returnedGoals = ExtensionControl.getTodayGoals()
        returnedRecurs = ExtensionControl.getTodayRecurs()
        print(returnedRecurs.count)
        returnedThings = returnedMissions + returnedGoals
        
        let sameDay = Calendar.current.isDate(UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date, inSameDayAs: Date())
        
        if UserDefaults(suiteName: "group.GetToThings")!.bool(forKey: "generated") == false || !sameDay {
            numRows = 0
            noText.isHidden = false
            mainTable.isHidden = true
        } else {
            noText.isHidden = true
            mainTable.isHidden = false
        }
        
        mainTable.reloadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        print("It changed")
        
        let totalLength = returnedRecurs.count + returnedThings.count
        
        if activeDisplayMode == .expanded || totalLength < 2 {
            numRows = totalLength
        } else if UserDefaults(suiteName: "group.GetToThings")!.bool(forKey: "generated") == false {
            numRows = 0
        } else {
            numRows = 2
        }
        mainTable.reloadData()
        
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: mainTable.contentSize.height) : maxSize
    }
    
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return 1
    }
    
    //Number of rows in each section
    func tableView(_ todayThingsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    //Section Titles
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }*/
    
    func tableView(_ todayThingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "main")
        
        if indexPath.row < returnedThings.count {
            let thing = returnedThings[indexPath.row]
            
            if(thing.isDone) {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            
            let text = thing.desc
            cell?.textLabel?.text = text
            
            return cell!
        } else {
            let recur = returnedRecurs[indexPath.row - returnedThings.count]
            
            if(recur.isDone) {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            
            let text = recur.desc
            cell?.textLabel?.text = text
            
            return cell!
        }
    }
    
    //Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < returnedThings.count {
            let thing = returnedThings[indexPath.row]
            
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    thing.isDone = false
                } else {
                    cell.accessoryType = .checkmark
                    thing.isDone = true
                }
            }
        } else {
            let recur = returnedRecurs[indexPath.row - returnedThings.count]
            if let cell = tableView.cellForRow(at: indexPath) {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    recur.isDone = false
                } else {
                    cell.accessoryType = .checkmark
                    recur.isDone = true
                }
            }
        }
        
        //Save
        ExtensionControl.saveContext()
    }
    
}
