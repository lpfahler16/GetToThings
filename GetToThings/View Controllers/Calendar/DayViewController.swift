//
//  DayViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 7/14/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import UIKit

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Instance Variables / Outlets
    
    @IBOutlet weak var pageTitle: UINavigationItem!
    @IBOutlet weak var thingTable: UITableView!
    var day:Day? = nil
    var date:Date? = nil
    
    // Table Data
    var allThings:[SimpleThing] = []
    
    // Table View information
    var numberOfSections:Int = 1
    var rowsForSection:[Int] = []

    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView() // Sets up what to show and what colors
        reloadView() // Fetches proper elements to populate table
        
        thingTable.dataSource = self
        thingTable.delegate = self
    }
    
    // MARK: - Initial Setup Helpers
    
    private func setupView() {
        // Do any additional setup after loading the view.
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        
        pageTitle.title = formatter.string(from: date!)
    }
    
    private func reloadView() {
        if day == nil {
            numberOfSections = 1
            rowsForSection = [1]
        } else {
            allThings = day?.theThings?.allObjects as! [SimpleThing]
            numberOfSections = 2
            rowsForSection = [day!.theThings!.count, 1]
        }
    }
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return numberOfSections
    }
    
    //Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsForSection[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if day != nil {
            if indexPath.section == 0 {
                return thingCell(allThings[indexPath.row])
            } else {
                return percentCell()
            }
        } else {
            return noneCell()
        }
    }
    
    // MARK: - Table View Helpers
    private func thingCell(_ thing: SimpleThing) -> UITableViewCell {
        let cell = thingTable.dequeueReusableCell(withIdentifier: "normal")
        if(thing.completed) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        let text = thing.desc
        cell?.textLabel?.text = text
        return cell!
    }
    
    private func percentCell() -> UITableViewCell {
        let cell = thingTable.dequeueReusableCell(withIdentifier: "detail")
        cell?.textLabel?.text = "Completed:"
        
        let percent = Int((day!.ratio)*100)
        
        cell?.detailTextLabel?.text = "\(percent)%"
        return cell!
    }
    
    private func noneCell() -> UITableViewCell {
        let cell = thingTable.dequeueReusableCell(withIdentifier: "normal")
        cell?.textLabel?.textAlignment = .center
        cell?.textLabel?.text = "No data to display"
        return cell!
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
