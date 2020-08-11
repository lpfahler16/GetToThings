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
    let header = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        recurringTable.delegate = self
        recurringTable.dataSource = self
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
            cell.detailTextLabel?.text = "Every week"
        } else if allRecurs[indexPath.section][indexPath.row].frequency == 2 {
            cell.detailTextLabel?.text = "Every other week"
        } else {
            cell.detailTextLabel?.text = "Every Month"
        }
        
        return cell
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
    
    override func viewWillAppear(_ animated: Bool) {
        recurringTable.reloadData()
    }

}
