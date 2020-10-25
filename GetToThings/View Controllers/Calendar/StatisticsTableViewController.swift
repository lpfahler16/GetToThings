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
        
        //Get days
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let context = AppDelegate.viewContext
        context.refreshAllObjects()
        var allDays = (try? context.fetch(request))!
        
        
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Current Generation Streak"
                
                //Reverse array
                allDays.reverse()
                
                //loop to find current gen streak
                var CGnumDays = 0
                var CGpreviousDay:Day? = nil
                print("\nCurrent Generation Streak")
                for day in allDays {
                    
                    print(day.date!)
                    
                    if CGpreviousDay == nil {
                        
                        //First day in the loop
                        print("Day 1 check")
                        let CGdayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: day.date!)).day
                        if CGdayDifference == -1 {
                            CGnumDays += 1
                            CGpreviousDay = day
                            print("Day 1")
                        }
                        
                    } else {
                        print("Day after check")
                        let CGdayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: CGpreviousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                        if CGdayDifference == -1 {
                            CGnumDays += 1
                            CGpreviousDay = day
                            print("Day after")
                        }
                        
                    }
                    
                }
                
                cell?.detailTextLabel?.text = "\(CGnumDays) days"
            } else if indexPath.row == 1 {
                cell?.textLabel?.text = "Longest Generation Streak"
                
                //loop to find current gen streak
                var LGnumDays = 0
                var LGhighestNumDays = 0
                var LGpreviousDay:Day? = nil
                print("\nLongest Generation Streak")
                for day in allDays {
                    
                    print(day.date!)
                    
                    if LGpreviousDay == nil {
                        
                        //First day in the loop
                        LGnumDays += 1
                        LGpreviousDay = day
                        print("Day 1")
                        
                    } else {
                        print("Day after check")
                        let LGdayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: LGpreviousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                        if LGdayDifference == 1 {
                            LGnumDays += 1
                            LGpreviousDay = day
                            print("Day after")
                        } else {
                            LGnumDays = 1
                            LGpreviousDay = day
                            print("Failed: reset")
                        }
                        
                    }
                    
                    if LGnumDays > LGhighestNumDays {
                        LGhighestNumDays = LGnumDays
                    }
                    
                }
                
                cell?.detailTextLabel?.text = "\(LGhighestNumDays) days"
            } else if indexPath.row == 2 {
                cell?.textLabel?.text = "Current 100% Streak"
                
                //Reverse array
                allDays.reverse()
                
                //loop to find current 100 streak
                var C1numDays = 0
                var C1previousDay:Day? = nil
                print("\nCurrent 100% Streak")
                for day in allDays {
                    
                    print(day.date!)
                    
                    if C1previousDay == nil {
                        
                        //First day in the loop
                        print("Day 1 check")
                        let C1dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: day.date!)).day
                        if C1dayDifference == -1 && day.ratio == 1 {
                            C1numDays += 1
                            C1previousDay = day
                            print("Day 1")
                        }
                        
                    } else {
                        print("Day after check")
                        let C1dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: C1previousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                        if C1dayDifference == -1 && day.ratio == 1 {
                            C1numDays += 1
                            C1previousDay = day
                            print("Day after")
                        }
                        
                    }
                    
                }
                
                cell?.detailTextLabel?.text = "\(C1numDays) days"
            } else if indexPath.row == 3 {
                cell?.textLabel?.text = "Longest 100% Streak"
                
                //loop to find current gen streak
                var L1numDays = 0
                var L1highestNumDays = 0
                var L1previousDay:Day? = nil
                print("\nLongest 100% Streak")
                for day in allDays {
                    
                    print(day.date!)
                    
                    if L1previousDay == nil {
                        
                        //First day in the loop
                        print("Day 1 check")
                        if day.ratio == 1 {
                            L1numDays += 1
                            L1previousDay = day
                            print("Day 1")
                        }
                        
                    } else {
                        print("Day after check")
                        let L1dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: L1previousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                        if day.ratio == 1 {
                            if L1dayDifference == 1 {
                                L1numDays += 1
                                L1previousDay = day
                                print("Day after")
                            } else {
                                L1numDays = 1
                                L1previousDay = day
                                print("Failed: reset")
                            }
                        }
                        
                    }
                    
                    if L1numDays > L1highestNumDays {
                        L1highestNumDays = L1numDays
                    }
                    
                }
                
                cell?.detailTextLabel?.text = "\(L1highestNumDays) days"
            }
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                cell?.textLabel?.text = "Total Percentage Completed"
                
                
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
                
                let firstDate = UD.firstLaunch
                let dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: firstDate()), to: Calendar.current.startOfDay(for: Date())).day
                
                
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
