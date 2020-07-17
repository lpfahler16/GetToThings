//
//  NewGoalTableViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 6/27/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class NewGoalTableViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet var newGoalsTable: UITableView!
    
    //MARK: - Mission Information
    @IBOutlet weak var goalTitle: UITextField!
    @IBOutlet weak var goodWeather: UISwitch!
    @IBOutlet weak var replacement: UISwitch!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTitle.delegate = self

        newGoalsTable.allowsSelection = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondViewController = segue.destination as? GoalsViewController {
            if(sender as? UIBarButtonItem == saveButton) {
                GoalControl.newGoal(goalTitle.text!, goodWeather.isOn, replacement.isOn)
                secondViewController.goalsTable.reloadData()
            }
        }
    }
    

}
