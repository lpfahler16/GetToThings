//
//  RandomViewController.swift
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
    
    var thing: RandomThing = RandomThing()
    var returnedThings:[RandomThing] = []
    
    // Table View Information
    var numOfSections:Int = 1
    var rowsForSection:[Int] = []
    
    // MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialLaunch() // Checks if launched before and sets up info
        setupView() // Sets up what to show and what colors
        reloadView() // Fetches proper elements to populate table
        
        missionsTable.delegate = self
        missionsTable.dataSource = self
    }
    
    // MARK: - Initial Setup Helpers
    
    private func initialLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBeforeMission")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBeforeMission")
            info()
        }
    }
    
    private func setupView() {
        //Color Setting
        thingSelector.backgroundColor = UD.color()
    }
    
    // MARK: - Buttons
    
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    @IBAction func changeThing(_ sender: Any) {
        reloadView()
    }
    
    func info() {
        let alertController = UIAlertController(title: "Random", message:
           "Add short-term tasks and long-term goals to these lists. Each day, some will be selected at random to appear on your Today page.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    //MARK: - Table View Setup
    
    // Number of sections
    func numberOfSections(in missionsTable: UITableView) -> Int {
        return numOfSections
    }
    
    // Rows in section
    func tableView(_ missionsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsForSection[section]
    }
    
    // Setting Row Data
    func tableView(_ missionsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thing = returnedThings[indexPath.row]
        return buildCell(thing)
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        missionsTable.deselectRow(at: indexPath, animated: true)
        
        thing = returnedThings[indexPath.row]
        
        self.performSegue(withIdentifier: "missionDetail", sender: self)
    }
    
    //Slide to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            let context = AppDelegate.viewContext
            context.delete(returnedThings[indexPath.row])
            
            // Save
            do {
                try context.save()
            } catch {
                print("**** Save failed ****")
            }
            
            reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
    }
    
    // MARK: - Table View Helpers
    
    // Build Cell
    private func buildCell(_ thing: AllThing) -> UITableViewCell {
        let cell = missionsTable.dequeueReusableCell(withIdentifier: "thingList")!
        cell.textLabel?.text = thing.desc!
        return cell
    }
    
    // Fetches proper elements to populate table
    func reloadView() {
        print("Mission reloaded")
        reloadData()
        
        missionsTable.reloadData()
    }
    
    // Fetches proper elements
    private func reloadData(){
        if thingSelector.selectedSegmentIndex == 0 {
            returnedThings = CoreControl.getThing(type: .randomTask) as! [RandomThing]
        } else {
            returnedThings = CoreControl.getThing(type: .randomGoal) as! [RandomThing]
        }
        rowsForSection = [returnedThings.count]
    }
    
    //MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "missionDetail") {
            // get a reference to the second view controller
            let secondViewController = segue.destination as! MissionDetailTableViewController
            
            // set a variable in the second view controller with the data to pass
            secondViewController.thing = thing
        }
        if (segue.identifier == "newThing") {
            let navVC = segue.destination as? UINavigationController

            let tableVC = navVC?.viewControllers.first as! NewMissionTableViewController

            tableVC.typeOfRandom = thingSelector.selectedSegmentIndex
        }
    }
    

    @IBAction func unwindToMain (_ sender:UIStoryboardSegue) {
        print("unwindToMain")
        reloadView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        setupView()
        
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

