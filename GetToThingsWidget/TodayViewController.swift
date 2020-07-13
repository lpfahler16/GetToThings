//
//  TodayViewController.swift
//  GetToThingsWidget
//
//  Created by Logan Pfahler on 6/28/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var noText: UILabel!
    @IBOutlet weak var mainTable: UITableView!
    
    var returnedMissions:[Thing] = []
    var returnedGoals:[Thing] = []
    let headerNames = ["Missions", "Goals"]
    var returnedThings:[Thing] = []
    var numRows = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        returnedMissions = getTodayMissions()
        returnedGoals = getTodayGoals()
        
        returnedThings = returnedMissions + returnedGoals
        
        mainTable.delegate = self
        mainTable.dataSource = self
        extensionContext?.widgetLargestAvailableDisplayMode = .expanded
    }
    
    //MARK: - Widget Specific Functionss
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        returnedMissions = getTodayMissions()
        returnedGoals = getTodayGoals()
        
        returnedThings = returnedMissions + returnedGoals
        
        let sameDay = Calendar.current.isDate(UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date, inSameDayAs: Date())
        
        if UserDefaults(suiteName: "group.GetToThings")!.bool(forKey: "generated") == false || !sameDay {
            numRows = 0
            noText.isHidden = false
            mainTable.isHidden = true
        } else {
            noText.isHidden = true
            mainTable.isHidden = false
        }
        
        mainTable.reloadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        let expanded = activeDisplayMode == .expanded
        print("It changed")
        if activeDisplayMode == .expanded || returnedThings.count < 2 {
            numRows = returnedThings.count
        } else if UserDefaults(suiteName: "group.GetToThings")!.bool(forKey: "generated") == false {
            numRows = 0
        } else {
            numRows = 2
        }
        mainTable.reloadData()
        
        preferredContentSize = expanded ? CGSize(width: maxSize.width, height: mainTable.contentSize.height) : maxSize
    }
    
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return 1
    }
    
    //Number of rows in each section
    func tableView(_ todayThingsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numRows
    }
    
    //Section Titles
    /*func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }*/
    
    func tableView(_ todayThingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "main")
        
        let thing = returnedThings[indexPath.row]
        
        if(thing.isDone) {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
        
        let text = thing.desc
        cell?.textLabel?.text = text
        
        return cell!
    }
    
    //Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let thing = returnedThings[indexPath.row]
        
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                thing.isDone = false
            } else {
                cell.accessoryType = .checkmark
                thing.isDone = true
            }
        }
        
        //Save
        let context = self.persistentContainer.viewContext
        do {
            try context.save()
            print("Saved")
        } catch {
            print("**** Save failed ****")
        }
    }
    
    //MARK: - Get Things
    func getTodayMissions() -> [Thing]{
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let missionPredicate = NSPredicate(format: "isMission = %d", true)
        let todayPredicate = NSPredicate(format: "today = %d", true)
        let predicates = [missionPredicate, todayPredicate]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let context = self.persistentContainer.viewContext
        let todayMissions = try? context.fetch(request)
        return todayMissions!
    }
    
    func getTodayGoals() -> [Thing]{
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let goalPredicate = NSPredicate(format: "isMission = %d", false)
        let todayPredicate = NSPredicate(format: "today = %d", true)
        let predicates = [goalPredicate, todayPredicate]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let context = self.persistentContainer.viewContext
        let todayGoals = try? context.fetch(request)
        return todayGoals!
    }
    
    
    //MARK: - Core Data
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSCustomPersistentContainer(name: "Model")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}
