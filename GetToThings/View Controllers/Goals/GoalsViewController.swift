//
//  MissionsViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 4/9/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class GoalsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets / Instance Variables
    @IBOutlet weak var goalsTable: UITableView!
    
    var goal: Thing = Thing()
    let goalControl = GoalControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBeforeGoal")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBeforeGoal")
            info()
        }
        
        // Do any additional setup after loading the view.
        goalsTable.delegate = self
        goalsTable.dataSource = self
        
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    func info() {
        let alertController = UIAlertController(title: "Goals", message:
           "A Goal is a Thing that you are working towards but is never entirely completed. Add any long-term goals to this list.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Table View Setup
    func numberOfSections(in goalsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ goalsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goalControl.getGoals().count
    }
    
    func tableView(_ goalsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = goalsTable.dequeueReusableCell(withIdentifier: "thingList")!
        let text = goalControl.getGoals()[indexPath.row].desc
        cell.textLabel?.text = text
        
        return cell
    }
    
    //Deselect row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        goalsTable.deselectRow(at: indexPath, animated: true)
        goal = goalControl.getGoals()[indexPath.row]
        self.performSegue(withIdentifier: "goalDetail", sender: self)
    }
    
    //Slide to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            let context = AppDelegate.viewContext
            context.delete(goalControl.getGoals()[indexPath.row])
            do {
                try context.save()
            } catch {
                print("**** Save failed ****")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {if (segue.identifier == "goalDetail") {
            // get a reference to the second view controller
            let secondViewController = segue.destination as! GoalDetailTableViewController
            
            // set a variable in the second view controller with the data to pass
            secondViewController.thing = goal
        }
    }

    @IBAction func unwindToMain (_ sender:UIStoryboardSegue) {
        print("unwindToMain")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Goals reloaded")
        goalsTable.reloadData()
    }

}

