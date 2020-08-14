//
//  RecurDetailTableViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/13/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class RecurDetailTableViewController: UITableViewController, UITextFieldDelegate {
    
    
    var recur: RecurringThing = RecurringThing()
    
    @IBOutlet weak var thingText: UITextField!
    @IBOutlet weak var startDate: UILabel!
    @IBOutlet weak var completedRatio: UILabel!
    
    @IBOutlet weak var deleteButton: UITableViewCell!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var sundayRow: UITableViewCell!
    @IBOutlet weak var mondayRow: UITableViewCell!
    @IBOutlet weak var tuesdayRow: UITableViewCell!
    @IBOutlet weak var wednesdayRow: UITableViewCell!
    @IBOutlet weak var thursdayRow: UITableViewCell!
    @IBOutlet weak var fridayRow: UITableViewCell!
    @IBOutlet weak var saturdayRow: UITableViewCell!
    var allDays:[UITableViewCell] = []
    
    @IBOutlet weak var everyWeekRow: UITableViewCell!
    @IBOutlet weak var everyOtherWeekRow: UITableViewCell!
    @IBOutlet weak var everyFourWeeksRow: UITableViewCell!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        thingText.delegate = self
        allDays = [sundayRow, mondayRow, tuesdayRow, wednesdayRow, thursdayRow, fridayRow, saturdayRow]
        
        thingText.text = recur.desc!
        completedRatio.text = "\(recur.numCompleted)/\(recur.numGenerated)"
        if recur.frequency == 1 {
            everyWeekRow.accessoryType = .checkmark
        } else if recur.frequency == 2 {
            everyOtherWeekRow.accessoryType = .checkmark
        } else {
            everyFourWeeksRow.accessoryType = .checkmark
        }
        
        //Start Date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        startDate.text = formatter.string(from: recur.dateAdded!)
        
        //Days of week
        var dayCount = 0
        for day in allDays {
            if recur.daysOfWeek!.contains(String(dayCount)) {
                day.accessoryType = .checkmark
            }
            dayCount += 1
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            let cell = tableView.cellForRow(at: indexPath)!
            if cell.accessoryType == .none {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        } else if indexPath.section == 2 {
            let cell = tableView.cellForRow(at: indexPath)!
            
            everyWeekRow.accessoryType = .none
            everyOtherWeekRow.accessoryType = .none
            everyFourWeeksRow.accessoryType = .none
            
            cell.accessoryType = .checkmark
            
        }
        
        print(indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("Spot 1")
        if let secondViewController = segue.destination as? RecurringViewController {
            print("Spot 2")
            let context = AppDelegate.viewContext
            if(sender as? UITableViewCell == deleteButton) {
                context.delete(recur)
                
                do {
                    try context.save()
                } catch {
                    print("**** Save failed ****")
                }
            }
            if(sender as? UIBarButtonItem == saveButton) {
                print("Spot 3")
                //Days Of Week
                var days:String = ""
                var dayCount = 0
                for day in allDays {
                    if day.accessoryType == .checkmark {
                        days.append(String(dayCount))
                    }
                    dayCount += 1
                }
                if days.count == 0 {
                    days.append("0")
                }
                recur.daysOfWeek = days
                
                //Frequency
                var freq:Int16 = 1
                if everyOtherWeekRow.accessoryType == .checkmark {
                    freq = 2
                } else if everyFourWeeksRow.accessoryType == .checkmark {
                    freq = 4
                }
                recur.frequency = freq
                
                recur.desc = thingText.text!
                
                do {
                    try context.save()
                } catch {
                    print("**** Save failed ****")
                }
                print("Saved!")
            }
            secondViewController.recurringTable.reloadData()
        }
    }

}
