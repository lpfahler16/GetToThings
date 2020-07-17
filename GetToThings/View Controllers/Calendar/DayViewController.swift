//
//  DayViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 7/14/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit

class DayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var pageTitle: UINavigationItem!
    @IBOutlet weak var thingTable: UITableView!
    var day:Day? = nil
    var date:Date? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        
        pageTitle.title = formatter.string(from: date!)
        
        thingTable.dataSource = self
        thingTable.delegate = self
    }
    
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return 1
    }
    
    //Number of rows in each section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if day != nil {
            return day!.theThings!.count
        } else {
            return 1
        }
    }
    
    
    
    //Setting Row Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "normal")
        let things = day?.theThings?.allObjects
        if things != nil {
            let thing = things![indexPath.row] as! SimpleThing
            if(thing.completed) {
                cell?.accessoryType = .checkmark
            } else {
                cell?.accessoryType = .none
            }
            
            let text = thing.desc
            cell?.textLabel?.text = text
        } else {
            cell?.textLabel?.textAlignment = .center
            cell?.textLabel?.text = "No data to display"
        }
        
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
