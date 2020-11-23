//
//  MissionDetailTableViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 6/26/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import CoreData

class MissionDetailTableViewController: UITableViewController, UITextFieldDelegate {

    //MARK: - Outlets / Instance Variables
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var goodWeather: UISwitch!
    @IBOutlet weak var disableSwitch: UISwitch!
    @IBOutlet var missionDetailTable: UITableView!
    @IBOutlet weak var replace: UISwitch!
    @IBOutlet weak var completedRatio: UILabel!
    @IBOutlet weak var deleteButton: UITableViewCell!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskRow: UITableViewCell!
    @IBOutlet weak var goalRow: UITableViewCell!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var thing: RandomThing = RandomThing()
    
    //MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView() // Sets up what to show and what colors
        
        // Delegates
        titleField.delegate = self
    }
    
    //MARK: - Initial Setup Helpers
    
    private func setupView() {
        titleField.text = thing.desc
        goodWeather.isOn = thing.needsGoodWeather
        disableSwitch.isOn = thing.disabled
        replace.isOn = thing.replacement
        completedRatio.text = "\(thing.numCompleted)/\(thing.numGenerated)"
        
        if let _ = thing as? RandomTask {
            taskRow.accessoryType = .checkmark
            goalRow.accessoryType = .none
        } else {
            taskRow.accessoryType = .none
            goalRow.accessoryType = .checkmark
        }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        if let date = thing.dateAdded {
            dateLabel.text = "Added \(formatter.string(from: date))"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Table View Setup
    
    //Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionDetailTable.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                taskRow.accessoryType = .checkmark
                goalRow.accessoryType = .none
                
                if let _ = thing as? RandomGoal {
                    CoreControl.convertRandomType(theThing: thing)
                }
            } else {
                taskRow.accessoryType = .none
                goalRow.accessoryType = .checkmark
                
                if let _ = thing as? RandomTask {
                    CoreControl.convertRandomType(theThing: thing)
                }
            }
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondViewController = segue.destination as? MissionsViewController {
            let context = AppDelegate.viewContext
            if(sender as? UITableViewCell == deleteButton) {
                context.delete(thing)
                
                do {
                    try context.save()
                } catch {
                    print("**** Save failed ****")
                }
            }
            if(sender as? UIBarButtonItem == saveButton) {
                thing.desc = titleField.text
                thing.needsGoodWeather = goodWeather.isOn
                thing.replacement = replace.isOn
                thing.disabled = disableSwitch.isOn
                
                do {
                    try context.save()
                } catch {
                    print("**** Save failed ****")
                }
            }
            secondViewController.reloadView()
        }
    }
}
