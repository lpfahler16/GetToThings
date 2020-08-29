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
    
    var returnedMissions:[Thing] = []
    var returnedGoals:[Thing] = []
    var returnedRecurs:[RecurringThing] = []
    let headerNames = ["Tasks", "Goals", "Recurring"]
    var returnedThings:[[Thing]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        returnedMissions = MissionControl.getTodayMissions()
        returnedGoals = GoalControl.getTodayGoals()
        returnedRecurs = RecurringControl.getThisDayRecurs(passedDate: UD.genDate)
        returnedThings = [returnedMissions, returnedGoals]
        
        self.todayThingsTable.delegate = self
        self.todayThingsTable.dataSource = self
        
        endDayHeader.textColor = UD.color
        endDayButton.backgroundColor = UD.color
        
    }
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return 4
    }
    
    //Number of rows in each section
    func tableView(_ todayThingsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else if section == 3{
            return returnedRecurs.count
        } else {
            return returnedThings[section - 1].count
        }
    }
    
    //Section Titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            let date = UD.genDate

            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long

            // get the date time String from the date object
            return formatter.string(from: date) // October 8, 2016 at 10:48:53 PM
        } else {
            return headerNames[section - 1]
        }
    }
    
    //Setting Row Data
    func tableView(_ todayThingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "thingDisplay") as! TodayTableViewCell
        if indexPath.section != 3 {
            let thing = returnedThings[indexPath.section - 1][indexPath.row]
            if(thing.isDone) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            let text = thing.desc
            cell.label.text = text
        } else {
            let thing = returnedRecurs[indexPath.row]
            if(thing.isDone) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            let text = thing.desc
            cell.label.text = text
        }
        return cell
    }
    
    //Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todayThingsTable.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section != 3 {
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
        } else {
            let thing = returnedRecurs[indexPath.row]
            
            if let cell = todayThingsTable.cellForRow(at: indexPath) as? TodayTableViewCell {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    thing.isDone = false
                } else {
                    cell.accessoryType = .checkmark
                    thing.isDone = true
                }
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
