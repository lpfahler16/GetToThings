//
//  RecurringViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/10/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class RecurringViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //MARK: - Outlets / Instance Variables
    @IBOutlet weak var recurringTable: UITableView!
    @IBOutlet var mainView: UIView!
    
    var recur: RecurThing = RecurThing()
    
    //Data Setup
    var returnedRecurs:[[RecurThing]] = []
    
    // Table View information
    let header = ["SUN", "MON", "TUES", "WED", "THURS", "FRI", "SAT"]
    var numberOfSections:Int = 7
    var rowsForSection:[Int] = []
    
    //MARK: - Initial Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLaunch() // Checks if launched before and sets up info
        setupView() // Sets up what to show and what colors
        reloadView() // Fetches proper elements to populate table
        
        recurringTable.delegate = self
        recurringTable.dataSource = self
    }
    
    //MARK: - Initial Setup Helper
    
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    private func initialLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBeforeRecur")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBeforeRecur")
            info()
        }
    }
    
    private func setupView() {
        recurringTable.sectionHeaderHeight = CGFloat(40)
        mainView.backgroundColor = UD.color()
    }
    
    func info() {
        let alertController = UIAlertController(title: "Recurring", message:
           "Add things you want to get to on a regular basis to this list. They will show up on the Today page on the appropriate days.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }

    
    //MARK: - Table View Setup
    
    // Number of sections
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    // Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsForSection[section]
    }
    
    // Section Titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    // Setting Row Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let thing = returnedRecurs[indexPath.section][indexPath.row]
        return buildCell(thing)
    }
    
    // Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        recur = returnedRecurs[indexPath.section][indexPath.row]
        self.performSegue(withIdentifier: "recurDetail", sender: self)
    }
    
    //Slide to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            RecurringControl.removeDayOfRecur(recur: returnedRecurs[indexPath.section][indexPath.row] as! WeekRecur, day: indexPath.section)
            
            //Maybe fix later?
            reloadData()
            tableView.deleteRows(at: [indexPath], with: .fade)
         }
    }
    
    //MARK: - Table View Helpers
    
    //Build Cell
    private func buildCell(_ thing: RecurThing) -> UITableViewCell {
        let cell = recurringTable.dequeueReusableCell(withIdentifier: "recurCell")!
        let theThing = thing as! WeekRecur
        cell.textLabel?.text = theThing.desc!
        if theThing.frequency == 1 {
            cell.detailTextLabel?.text = "Weekly"
        } else if theThing.frequency == 2 {
            cell.detailTextLabel?.text = "Biweekly"
        } else {
            cell.detailTextLabel?.text = "Monthly"
        }
        return cell
    }
    
    
    // MARK: - Segue
    
    private func reloadView() {
        print("Recurring reloaded")
        reloadData()
        recurringTable.reloadData()
    }

    private func reloadData() {
        returnedRecurs = RecurringControl.getDayRecurs()
        rowsForSection = [returnedRecurs[0].count,
                          returnedRecurs[1].count,
                          returnedRecurs[2].count,
                          returnedRecurs[3].count,
                          returnedRecurs[4].count,
                          returnedRecurs[5].count,
                          returnedRecurs[6].count,]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "recurDetail") {
            // get a reference to the second view controller
            let secondViewController = segue.destination as! RecurDetailTableViewController
            
            // set a variable in the second view controller with the data to pass
            secondViewController.recur = recur as! WeekRecur
        }
    }
    
    @IBAction func unwindToMain (_ sender:UIStoryboardSegue) {
        print("unwindToMain")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        setupView()
    }

}
