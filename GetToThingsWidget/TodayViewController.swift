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
    
    //MARK: - Outlets / Instance Variables
    @IBOutlet weak var noText: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    
    var returnedMissions:[RandomTask] = []
    var returnedGoals:[RandomGoal] = []
    var returnedRecurs:[RecurThing] = []
    let headerNames = ["Missions", "Goals"]
    var returnedThings:[AllThing] = []
    var numRows = 2
    
    //MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        reloadView() // Fetches proper elements to populate table
        
        mainTable.delegate = self
        mainTable.dataSource = self
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    //MARK: - Initial Setup Helpers
    private func reloadView() {
        returnedMissions = ExtensionControl.getTodayMissions()
        returnedGoals = ExtensionControl.getTodayGoals()
        returnedRecurs = ExtensionControl.getTodayRecurs()
        
        returnedThings = returnedMissions as [RandomThing] + returnedGoals as [RandomThing] + returnedRecurs
    }
    
    //MARK: - Widget Update
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        setupView() // Sets up what to show and what colors
        
        reloadView()
        mainTable.reloadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    // MARK: - Widget Update Helpers
    private func setupView() {
        let sameDay = Calendar.current.isDate(UD.genDate(), inSameDayAs: Date())
        if !UD.generated() || !sameDay {
            numRows = 0
            noText.isHidden = false
            mainTable.isHidden = true
        } else {
            noText.isHidden = true
            mainTable.isHidden = false
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        
        let totalLength = returnedThings.count
        
        if expanded || totalLength < 2 {
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
    
    func tableView(_ todayThingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "main")
        
        let thing = returnedThings[indexPath.row]
        
        if(thing.isDone) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        let text = thing.desc
        cell?.textLabel?.text = text
        
        return cell!
    }
    
    //Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        //Save
        ExtensionControl.saveContext()
    }
    
}
