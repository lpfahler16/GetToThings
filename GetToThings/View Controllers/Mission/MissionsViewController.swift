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

    var mission: Thing = Thing()
    
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
        
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    func info() {
        let alertController = UIAlertController(title: "Missions", message:
           "A Mission is a Thing that you can complete within the day. Add any short-term tasks to this list.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Table View Setup
    func numberOfSections(in missionsTable: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ missionsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MissionControl.getMissions().count
    }
    
    func tableView(_ missionsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = missionsTable.dequeueReusableCell(withIdentifier: "thingList")!
        let text = MissionControl.getMissions()[indexPath.row].desc
        cell.textLabel?.text = text
        
        return cell
    }
    
    //Deselect row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionsTable.deselectRow(at: indexPath, animated: true)
        mission = MissionControl.getMissions()[indexPath.row]
        self.performSegue(withIdentifier: "missionDetail", sender: self)
    }
    
    //Slide to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            let context = AppDelegate.viewContext
            context.delete(MissionControl.getMissions()[indexPath.row])
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
            secondViewController.thing = mission
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

