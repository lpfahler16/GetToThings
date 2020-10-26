//
//  EndDayViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 6/29/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class EndDayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets and Instance Data
    @IBOutlet weak var todayThingsTable: UITableView!
    @IBOutlet weak var endDayHeader: UILabel!
    @IBOutlet weak var endDayButton: UIButton!
    
    var returnedMissions:[RandomTask] = []
    var returnedGoals:[RandomGoal] = []
    var returnedRecurs:[WeekRecur] = []
    var returnedThings:[[AllThing]] = []
    
    // Table View Information
    var headerNames:[String] = []
    var numOfSections:Int = 4
    var rowsForSection:[Int] = []
    
    
    //MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setHeaders() // Sets header information
        setupView() // Sets up what to show and what colors
        reloadView() // Fetches proper elements to populate table
        
        // Delegates and data sources
        self.todayThingsTable.delegate = self
        self.todayThingsTable.dataSource = self
        
    }
    
    //MARK: - Initial Setup Helpers
    private func setHeaders(){
        // initialize the date formatter and set the style
        let date = UD.genDate
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        headerNames = [formatter.string(from: date()), "Tasks", "Goals", "Recurring"]
    }
    
    private func setupView(){
        endDayHeader.textColor = UD.color()
        endDayButton.backgroundColor = UD.color()
    }
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return numOfSections
    }
    
    //Number of rows in each section
    func tableView(_ todayThingsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsForSection[section]
    }
    
    //Section Titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    
    //Setting Row Data
    func tableView(_ todayThingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thing = returnedThings[indexPath.section - 1][indexPath.row]
        return buildCell(thing)
    }
    
    //Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todayThingsTable.deselectRow(at: indexPath, animated: true)
        
        let thing = returnedThings[indexPath.section - 1][indexPath.row]
        
        if let cell = todayThingsTable.cellForRow(at: indexPath) as? TodayTableViewCell {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                thing.isDone = false
            } else {
                cell.accessoryType = .checkmark
                thing.isDone = true
            }
        }
        
        //Save
        let context = AppDelegate.viewContext
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
    }
    
    //MARK: - Table View Helpers
    
    //Build Cell
    private func buildCell(_ thing: AllThing) -> TodayTableViewCell {
        let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "thingDisplay") as! TodayTableViewCell
        if(thing.isDone) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        let text = thing.desc
        cell.label.text = text
        
        return cell
    }
    
    // Fetches proper elements to populate table
    private func reloadView() {
        returnedMissions = MissionControl.getTodayMissions()
        returnedGoals = GoalControl.getTodayGoals()
        returnedRecurs = RecurringControl.getThisDayRecurs(passedDate: UD.genDate())
        returnedThings = [returnedMissions, returnedGoals, returnedRecurs]
        rowsForSection = [0, returnedMissions.count, returnedGoals.count, returnedRecurs.count]
        
        todayThingsTable.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
