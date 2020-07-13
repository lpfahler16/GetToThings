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
    
    //MARK: - Mission Information
    @IBOutlet weak var missionTitle: UITextField!
    @IBOutlet weak var goodWeather: UISwitch!
    @IBOutlet weak var replacement: UISwitch!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let missionControl = MissionControl()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        missionTitle.delegate = self

        newMissionsTable.allowsSelection = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondViewController = segue.destination as? MissionsViewController {
            if(sender as? UIBarButtonItem == saveButton) {
                missionControl.newMission(missionTitle.text!, goodWeather.isOn, replacement.isOn)
                secondViewController.missionsTable.reloadData()
            }
        }
    }
    

}
