//
//  StatisticsTableViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 7/17/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import CoreData

class StatisticsTableViewController: UITableViewController {
    
    // MARK: - Instance Variables / Outlets
    let headerNames = ["Streaks", "Totals"]
    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
    // MARK: - Table View Setup
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 3
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal")
        
        //Get days
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let context = AppDelegate.viewContext
        context.refreshAllObjects()
        let allDays = (try? context.fetch(request))!
        
        let stats = Stats(all: allDays)
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Current Generation Streak"
                cell?.detailTextLabel?.text = "\(stats.currGenStreak()) days"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Longest Generation Streak"
                cell?.detailTextLabel?.text = "\(stats.longGenStreak()) days"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Current 100% Streak"
                cell?.detailTextLabel?.text = "\(stats.curr100Streak()) days"
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = "Longest 100% Streak"
                cell?.detailTextLabel?.text = "\(stats.long100Streak()) days"
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Total Percentage Completed"
                cell?.detailTextLabel?.text = "\(stats.totPercentComplete())%"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Total Days"
                cell?.detailTextLabel?.text = "\(stats.totDays()) days"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Total Days Generated"
                cell?.detailTextLabel?.text = "\(stats.totDaysGen()) days"
            }
            
        }
        return cell!
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
