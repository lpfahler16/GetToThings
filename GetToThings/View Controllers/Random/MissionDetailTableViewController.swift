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

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var goodWeather: UISwitch!
    @IBOutlet var missionDetailTable: UITableView!
    @IBOutlet weak var replace: UISwitch!
    @IBOutlet weak var completedRatio: UILabel!
    @IBOutlet weak var deleteButton: UITableViewCell!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var taskRow: UITableViewCell!
    @IBOutlet weak var goalRow: UITableViewCell!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    var thing: Thing = Thing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleField.delegate = self
        
        titleField.text = thing.desc
        goodWeather.isOn = thing.needsGoodWeather
        replace.isOn = thing.replacement
        completedRatio.text = "\(thing.numCompleted)/\(thing.numGenerated)"
        
        if thing.isMission {
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    //Deletion
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionDetailTable.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                taskRow.accessoryType = .checkmark
                goalRow.accessoryType = .none
                thing.isMission = true
            } else {
                taskRow.accessoryType = .none
                goalRow.accessoryType = .checkmark
                thing.isMission = false
            }
        }
        
        print(indexPath)
    }
    
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
                
                do {
                    try context.save()
                } catch {
                    print("**** Save failed ****")
                }
            }
            secondViewController.missionsTable.reloadData()
        }
    }
}
