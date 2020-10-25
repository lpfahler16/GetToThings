//
//  RecurringViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/10/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class RecurringViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var recurringTable: UITableView!
    @IBOutlet var mainView: UIView!
    let header = ["SUN", "MON", "TUES", "WED", "THURS", "FRI", "SAT"]
    var recur: RecurThing = RecurThing()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBeforeRecur")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBeforeRecur")
            info()
        }

        recurringTable.sectionHeaderHeight = CGFloat(40)
        // Do any additional setup after loading the view.
        recurringTable.delegate = self
        recurringTable.dataSource = self
        
        //Color
        mainView.backgroundColor = UD.color()
    }
    
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    
    func info() {
        let alertController = UIAlertController(title: "Recurring", message:
           "Add things you want to get to on a regular basis to this list. They will show up on the Today page on the appropriate days.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }

    
    //MARK: - Table View
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecurringControl.getDayRecurs()[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recurCell")!
        
        let allRecurs = RecurringControl.getDayRecurs()
        
        cell.textLabel?.text = allRecurs[indexPath.section][indexPath.row].desc!
        
        if allRecurs[indexPath.section][indexPath.row].frequency == 1 {
            cell.detailTextLabel?.text = "Weekly"
        } else if allRecurs[indexPath.section][indexPath.row].frequency == 2 {
            cell.detailTextLabel?.text = "Biweekly"
        } else {
            cell.detailTextLabel?.text = "Monthly"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        recur = RecurringControl.getDayRecurs()[indexPath.section][indexPath.row]
        
        self.performSegue(withIdentifier: "recurDetail", sender: self)
    }
    
    
    //Slide to delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
         if editingStyle == .delete {
            
            let context = AppDelegate.viewContext
            context.delete(RecurringControl.getDayRecurs()[indexPath.section][indexPath.row])
            do {
                try context.save()
            } catch {
                print("**** Save failed ****")
            }
            
            //Maybe fix later?
            tableView.reloadData()
         }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        print("Recurring reloaded")
        recurringTable.reloadData()
    }

}
