//
//  NewMissionTableViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 6/26/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class NewMissionTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var newMissionsTable: UITableView!
    
    //MARK: - Outlets / Instance Variables
    var typeOfRandom: Int!
    
    // Mission Information
    @IBOutlet weak var missionTitle: UITextField!
    @IBOutlet weak var goodWeather: UISwitch!
    @IBOutlet weak var replacement: UISwitch!
    
    @IBOutlet weak var taskRow: UITableViewCell!
    @IBOutlet weak var goalRow: UITableViewCell!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    //MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView() // Sets up what to show and what colors
        
        // Delegates
        missionTitle.delegate = self
    }
    
    //MARK: - Initial Setup Helpers
    
    private func setupView() {
        if typeOfRandom == 0 {
            taskRow.accessoryType = .checkmark
            goalRow.accessoryType = .none
        } else {
            taskRow.accessoryType = .none
            goalRow.accessoryType = .checkmark
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - Table View Setup
    
    // Selection
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 1 {
            if indexPath.row == 0 {
                taskRow.accessoryType = .checkmark
                goalRow.accessoryType = .none
            } else {
                taskRow.accessoryType = .none
                goalRow.accessoryType = .checkmark
            }
        }
    }
    
    //MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondViewController = segue.destination as? MissionsViewController {
            if(sender as? UIBarButtonItem == saveButton) {
                if taskRow.accessoryType == .checkmark {
                    MissionControl.newMission(missionTitle.text!, goodWeather.isOn, replacement.isOn)
                } else {
                    GoalControl.newGoal(missionTitle.text!, goodWeather.isOn, replacement.isOn)
                }
                secondViewController.missionsTable.reloadData()
            }
        }
    }
    

}
