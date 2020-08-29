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

class MissionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets / Instance Variables
    @IBOutlet weak var missionsTable: UITableView!
    @IBOutlet weak var thingSelector: UISegmentedControl!
    
    var thing: Thing = Thing()
    var setToMission = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBeforeMission")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBeforeMission")
            info()
        }
        
        missionsTable.delegate = self
        missionsTable.dataSource = self
        
        setToMission = thingSelector.selectedSegmentIndex == 0
        
        
        //Color Setting
        thingSelector.backgroundColor = UD.color
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    @IBAction func changeThing(_ sender: Any) {
        setToMission = thingSelector.selectedSegmentIndex == 0
        print(setToMission)
        missionsTable.reloadData()
    }
    
    
    func info() {
        let alertController = UIAlertController(title: "Random", message:
           "Add short-term tasks and long-term goals to these lists. Each day, some will be selected at random to appear on your Today page.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Table View Setup
    func numberOfSections(in missionsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ missionsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        if setToMission {
            return MissionControl.getMissions().count
        } else {
            return GoalControl.getGoals().count
        }
    }
    
    func tableView(_ missionsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = missionsTable.dequeueReusableCell(withIdentifier: "thingList")!
        let text: String
        if setToMission {
            text = MissionControl.getMissions()[indexPath.row].desc!
        } else {
            text = GoalControl.getGoals()[indexPath.row].desc!
        }
        cell.textLabel?.text = text
        
        return cell
    }
    
    //Deselect row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionsTable.deselectRow(at: indexPath, animated: true)
        
        if setToMission {
            thing = MissionControl.getMissions()[indexPath.row]
        } else {
            thing = GoalControl.getGoals()[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "missionDetail", sender: self)
    }
    
    //Slide to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            let context = AppDelegate.viewContext
            if setToMission {
                context.delete(MissionControl.getMissions()[indexPath.row])
            } else {
                context.delete(GoalControl.getGoals()[indexPath.row])
            }
            do {
                try context.save()
            } catch {
                print("**** Save failed ****")
            }
            
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "missionDetail") {
            // get a reference to the second view controller
            let secondViewController = segue.destination as! MissionDetailTableViewController
            
            // set a variable in the second view controller with the data to pass
            secondViewController.thing = thing
        }
    }

    @IBAction func unwindToMain (_ sender:UIStoryboardSegue) {
        print("unwindToMain")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("Missions reloaded")
        missionsTable.reloadData()
        
        
//        //Testing
//        let request: NSFetchRequest<Day> = Day.fetchRequest()
//        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
//
//        let context = AppDelegate.viewContext
//        context.refreshAllObjects()
//        let allDays = try? context.fetch(request)
//
//        for day in allDays! {
//            print(day.date!)
//            for simple in day.theThings! {
//                print((simple as! SimpleThing).description)
//            }
//        }
    }

}

