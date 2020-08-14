//
//  NewRecurringTableViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/12/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class NewRecurringTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var thingText: UITextField!
    
    @IBOutlet weak var dateText: UITextField!
    let datePicker = UIDatePicker()
    
    //Days of week
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
        createDatePicker()
        
        //Date field
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        datePicker.date = Date()
        dateText.text = formatter.string(from: datePicker.date)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //Date Picker Stuff
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        dateText.inputAccessoryView = toolbar
        
        datePicker.datePickerMode = .date
        dateText.inputView = datePicker
    }
    @objc func donePressed() {
        //Formatter
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        dateText.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    
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
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondViewController = segue.destination as? RecurringViewController {
            if(sender as? UIBarButtonItem == saveButton) {
                //Days of week
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
                
                //Frequency
                var freq:Int16 = 1
                if everyOtherWeekRow.accessoryType == .checkmark {
                    freq = 2
                } else if everyFourWeeksRow.accessoryType == .checkmark {
                    freq = 4
                }
                
                RecurringControl.newRecur(thingText.text!, days, freq, datePicker.date)
                
                secondViewController.recurringTable.reloadData()
            }
        }
    }

}
