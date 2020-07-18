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
    
    let headerNames = ["Streaks", "Totals"]
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }
    
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
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Current Generation Streak"
                cell?.detailTextLabel?.text = "0 days"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Longest Generation Streak"
                cell?.detailTextLabel?.text = "0 days"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Current 100% Streak"
                cell?.detailTextLabel?.text = "0 days"
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = "Longest 100% Streak"
                cell?.detailTextLabel?.text = "0 days"
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Total Percentage Completed"
                
                let request: NSFetchRequest<Day> = Day.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

                let context = AppDelegate.viewContext
                context.refreshAllObjects()
                let allDays = (try? context.fetch(request))!
                
                var totalRatio:Double = 0.0
                
                for day in allDays {
                    totalRatio += day.ratio
                }
                
                if allDays.count != 0 {
                    totalRatio = totalRatio/Double(allDays.count)
                }
                
                let percentage = Int(totalRatio*100)
                cell?.detailTextLabel?.text = "\(percentage)%"
                
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Total Days"
                
                let firstDate = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "firstLaunchDate") as! Date
                let dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: firstDate), to: Calendar.current.startOfDay(for: Date())).day
                
                
                cell?.detailTextLabel?.text = "\(dayDifference!) days"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Total Days Generated"
                
                let request: NSFetchRequest<Day> = Day.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

                let context = AppDelegate.viewContext
                context.refreshAllObjects()
                let allDays = (try? context.fetch(request))!
                cell?.detailTextLabel?.text = "\(allDays.count) days"
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
