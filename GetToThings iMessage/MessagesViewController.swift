//
//  MessagesViewController.swift
//  GetToThings iMessage
//
//  Created by Logan Pfahler on 7/30/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import Messages
import CoreData

class MessagesViewController: MSMessagesAppViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var mainTable: UITableView!
    
    var returnedMissions:[Thing] = []
    var returnedGoals:[Thing] = []
    let headerNames = ["Your Tasks", "Your Goals"]
    var returnedThings:[[Thing]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        returnedMissions = ExtensionControl.getMissions()
        returnedGoals = ExtensionControl.getGoals()
        
        returnedThings = [returnedMissions, returnedGoals]
        
        mainTable.delegate = self
        mainTable.dataSource = self
    }
    
    //MARK: - Main interface setup
    
    //Table view setup
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return returnedThings[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = returnedThings[indexPath.section][indexPath.row].desc
        
        return cell
    }
}
