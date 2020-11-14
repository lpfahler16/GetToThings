//
//  SettingsViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 4/9/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController {

    // MARK: - Outlets / Instance Variables
    @IBOutlet var settingsTable: UITableView!
    
    @IBOutlet weak var goalsLabel: UILabel!
    @IBOutlet weak var goalsStepper: UIStepper!
    
    @IBOutlet weak var missionsLabel: UILabel!
    @IBOutlet weak var missionsStepper: UIStepper!
    
    
    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Goals Stepper Setup
        goalsStepper.value = UD.numGoals()
        goalsLabel.text = String(Int(goalsStepper.value))
        
        //Missions Stepper Setup
        missionsStepper.value = UD.numTasks()
        missionsLabel.text = String(Int(missionsStepper.value))
        
    }
    
    // MARK: - Steppers
    @IBAction func stepperClicked(_ sender: Any) {
        goalsLabel.text = String(Int(goalsStepper.value))
        UserDefaults.standard.set(goalsStepper.value, forKey: "numGoals")
    }
    @IBAction func missionsStepperClicked(_ sender: Any) {
        missionsLabel.text = String(Int(missionsStepper.value))
        UserDefaults.standard.set(missionsStepper.value, forKey: "numMissions")
    }
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        settingsTable.deselectRow(at: indexPath, animated: true)
        
        print(indexPath)
        
        if indexPath.section == 2 && indexPath.row == 0 {
            if let requestUrl = NSURL(string: "https://sites.google.com/view/gettothings/privacy-policy") {
                 UIApplication.shared.open(requestUrl as URL)
            }
        }
        
        if indexPath.section == 1 && indexPath.row == 0 {
            
        }
    }

}

