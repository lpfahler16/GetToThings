//
//  TodayViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 4/9/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import AVFoundation

class TodayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    //MARK: - Outlets / Instance Variables
    @IBOutlet weak var genButton: UIView!
    @IBOutlet weak var todayThingsTable: UITableView!
    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var weatherButton: UIButton!
    @IBOutlet weak var realGenButton: UIButton!
    
    //Color Setup
    @IBOutlet var mainView: UIView!
    
    
    
    let colors = [UIColor(named: "Cal 1"),
        UIColor(named: "Cal 2"),
        UIColor(named: "Cal 3"),
        UIColor(named: "Cal 4"),
        UIColor(named: "Cal 5"),
        UIColor(named: "Cal 6"),
        UIColor(named: "Cal 7"),
        UIColor(named: "Cal 8"),
        UIColor(named: "Cal 9"),
        UIColor(named: "Cal 10"),
        UIColor(named: "Cal 11")]
    
    var returnedMissions:[RandomTask] = []
    var returnedGoals:[RandomGoal] = []
    var returnedRecurs:[WeekRecur] = []
    let headerNames = ["Tasks", "Goals", "Recurring"]
    var returnedThings:[[AllThing]] = []
    var goodWeather = true
    
    var numOfSections:Int = 4
    
    //MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Check if launched before
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            print("Not first launch.")
            
            //Update fixes
            if UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") == nil {
                UserDefaults(suiteName: "group.GetToThings")!.set(UserDefaults.standard.object(forKey: "generateDate") as! Date, forKey: "generateDate")
            }
            if UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "firstLaunchDate") == nil {
                UserDefaults(suiteName: "group.GetToThings")!.set(Date(), forKey: "firstLaunchDate")
            }
            if !(UserDefaults.standard.bool(forKey: "converted")) {
                Conversion.convertAll()
                UserDefaults.standard.set(true, forKey: "converted")
            }
        } else { // FIRST LAUNCH
            print("First launch, setting UserDefault.")
            
            //Settings
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            UserDefaults.standard.set(1, forKey: "numMissions")
            UserDefaults.standard.set(1, forKey: "numGoals")
            UserDefaults.standard.set(0, forKey: "color")
            UserDefaults.standard.set(true, forKey: "converted")
            
            //Dates
            UserDefaults(suiteName: "group.GetToThings")!.set(false, forKey: "generated")
            UserDefaults(suiteName: "group.GetToThings")!.set(Date(), forKey: "generateDate")
            UserDefaults(suiteName: "group.GetToThings")!.set(Date(), forKey: "firstLaunchDate")
            
            //Initial Data
            MissionControl.newMission("Ex 1: Go for a walk", true, true)
            MissionControl.newMission("Ex 2: Try a new recipe", false, true)
            GoalControl.newGoal("Ex 1: Learn to play an instrument", false, true)
            GoalControl.newGoal("Ex 2: Learn to draw", false, true)
            RecurringControl.newRecur("Ex: Give a compliment!", "0123456", 1, Date())
            
            //Alert
            let alertController = UIAlertController(title: "Welcome!", message:
                "\nWelcome to GetToThings, an app that allows you to prioritize the things that you may not otherwise be getting to. \n\nGetToThings will provide you with a random and recurring selection of short-term tasks and long-term Goals each day, allowing you to get back to the things you really want to be doing.", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                //run your function here
                self.info()
            }))

            self.present(alertController, animated: true, completion: nil)
        }
        
        //Setup view
        if UD.generated {
            tableContainer.isHidden = false
            genButton.isHidden = true
            
            returnedMissions = MissionControl.getTodayMissions()
            returnedGoals = GoalControl.getTodayGoals()
            returnedRecurs = RecurringControl.getThisDayRecurs(passedDate: UD.genDate)
        } else {
            tableContainer.isHidden = true
            genButton.isHidden = false
        }
        
        returnedThings = [returnedMissions, returnedGoals]
        
        
        todayThingsTable.dataSource = self
        todayThingsTable.delegate = self
        
        checkDate()
        
        numOfSections = 4
        //Foreground stuff
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        //Colors
        mainView.backgroundColor = UD.color
        realGenButton.backgroundColor = UD.color
        weatherButton.tintColor = UD.color
        
        
        Conversion.convertAll()
    }
    
    @objc func appMovedToForeground() {
        reloadView()
        checkDate()
    }
    
    
    //MARK: - Generation
    
    //Checks if new day
    func checkDate() {
        let sameDay = Calendar.current.isDate(UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date, inSameDayAs: Date(/*For testing:timeIntervalSince1970: 0*/))
        
        if UD.generated && !sameDay {
            self.performSegue(withIdentifier: "endDay", sender: self)
        }
    }
    
    //Change weather
    @IBAction func weatherChange(_ sender: Any) {
        let button = sender as! UIButton
        if goodWeather {
            button.setBackgroundImage(UIImage(systemName: "cloud.rain.fill"), for: UIControl.State.normal)
            goodWeather = false
            print("Bad")
        } else {
            button.setBackgroundImage(UIImage(systemName: "sun.max.fill"), for: UIControl.State.normal)
            goodWeather = true
            print("Good")
        }
    }
    
    
    @IBAction func generate(_ sender: Any) {
        //Mark sure it is visible
        if genButton.isHidden == false {

            genButton.isHidden = true
            tableContainer.isHidden = false
            
            MissionControl.generateTodayMissions(goodWeather)
            GoalControl.generateTodayGoals(goodWeather)
            
            returnedMissions = MissionControl.getTodayMissions()
            returnedGoals = GoalControl.getTodayGoals()
            returnedRecurs = RecurringControl.getTodayRecurs()
            
            returnedThings = [returnedMissions, returnedGoals]
            todayThingsTable.reloadData()
            
            UserDefaults(suiteName: "group.GetToThings")!.set(true, forKey: "generated")
            UserDefaults(suiteName: "group.GetToThings")!.set(Date(), forKey: "generateDate")
            
            numOfSections = 1
            todayThingsTable.reloadData()
            makeTimer()
        }
    }
    
    //Fade in
    func makeTimer() {
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
    }
    
    @objc func fireTimer(){
        numOfSections += 1
        todayThingsTable.reloadData()
        if numOfSections < 4 {
            makeTimer()
        }
    }
    
    //MARK: - Notification Control
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    func info() {
        let alertController = UIAlertController(title: "Today", message:
            "Get all of your things for the day right here! Click generate and get to work, checking off any you completed. At the end of the day, they will reset.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    
    //MARK: - Reset Control
    @IBAction func resetButton(_ sender: Any) {
        let alertController = UIAlertController(title: "Are you sure you want to reset?", message:
           "All Things will be returned to your lists.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.addAction(UIAlertAction(title: "Reset", style: .destructive, handler: { action in
            //run your function here
            self.reset(sender)
        }))

        self.present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func reset(_ sender: Any) {
        let someDateTime = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date
        
       //Missions
        let allMissions = MissionControl.getMissions()
        let context = AppDelegate.viewContext
        for mission in allMissions {
            
            if let _ = sender as? UIStoryboardSegue, mission.today {
                mission.numGenerated += 1
                if mission.isDone {
                    mission.numCompleted += 1
                }
            }
            
            if let _ = sender as? UIStoryboardSegue, mission.replacement == false && mission.isDone && mission.today {
                context.delete(mission)
            } else {
                mission.today = false
                mission.isDone = false
            }
            
        }
        
        //Goals
        let allGoals = GoalControl.getGoals()
        for goal in allGoals {
            
            if let _ = sender as? UIStoryboardSegue, goal.today {
                goal.numGenerated += 1
                if goal.isDone {
                    goal.numCompleted += 1
                }
            }
                
            if let _ = sender as? UIStoryboardSegue, goal.replacement == false && goal.isDone && goal.today {
                context.delete(goal)
            } else {
                goal.today = false
                goal.isDone = false
            }
                
        }
        
        //Recurs
        let allRecurs = RecurringControl.getThisDayRecurs(passedDate: someDateTime)
        for recur in allRecurs {
            if let _ = sender as? UIStoryboardSegue {
                recur.numGenerated += 1
                if recur.isDone {
                    recur.numCompleted += 1
                }
            }
            recur.isDone = false
        }
        
        //Save
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        
        genButton.isHidden = false
        tableContainer.isHidden = true
        
        UserDefaults(suiteName: "group.GetToThings")!.set(false, forKey: "generated")
    }
    
    
    //MARK: - Saving Day
    func saveDay() {
        let someDateTime = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date
        
        returnedMissions = MissionControl.getTodayMissions()
        returnedGoals = GoalControl.getTodayGoals()
        returnedRecurs = RecurringControl.getThisDayRecurs(passedDate: someDateTime)
        
        let allThings = returnedMissions + returnedGoals
        
        let context = AppDelegate.viewContext
        let day = Day(context: context)
        
        //Test Date setup ------------------
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 7
        dateComponents.day = 6

        // Create date from components
        //let userCalendar = Calendar.current // user calendar
        //let someDateTime = userCalendar.date(from: dateComponents)
        //----------------------------------
        
        
        
        day.date = someDateTime
        day.ratio = getRatio()
        
        for thing in allThings {
            let simpleThing = SimpleThing(context: context)
            simpleThing.desc = thing.desc
            simpleThing.completed = thing.isDone
            day.addToTheThings(simpleThing)
        }
        for recur in returnedRecurs {
            let simpleThing = SimpleThing(context: context)
            simpleThing.desc = recur.desc
            simpleThing.completed = recur.isDone
            day.addToTheThings(simpleThing)
        }
        
        //Save
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        
    }
    
    func getRatio() -> Double{
        let someDateTime = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date
        
        returnedMissions = MissionControl.getTodayMissions()
        returnedGoals = GoalControl.getTodayGoals()
        returnedRecurs = RecurringControl.getThisDayRecurs(passedDate: someDateTime)
        
        let allThings = returnedMissions + returnedGoals
        var complete = 0
        for thing in allThings {
            if thing.isDone {
                complete += 1
            }
        }
        for recur in returnedRecurs {
            if recur.isDone {
                complete += 1
            }
        }
        return Double(complete)/Double(allThings.count + returnedRecurs.count)
    }
    
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return numOfSections
    }
    
    //Number of rows in each section
    func tableView(_ todayThingsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 3{
            return returnedRecurs.count
        } else {
            return returnedThings[section - 1].count
        }
    }
    
    //Section Titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
//            let date = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date
//
//            // initialize the date formatter and set the style
//            let formatter = DateFormatter()
//            formatter.timeStyle = .none
//            formatter.dateStyle = .long

            // get the date time String from the date object
            return "" // October 8, 2016 at 10:48:53 PM
        } else {
            return headerNames[section - 1]
        }
    }
    
    //Setting Row Data
    func tableView(_ todayThingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "dateViewer") as! TodayTableViewCell
            
            let date = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date

            // initialize the date formatter and set the style
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long

            // get the date time String from the date object
            // October 8, 2016 at 10:48:53 PM
            
            cell.label.text = formatter.string(from: date)
            
            let ratio = getRatio()
            cell.label.textColor = colors[Int(ratio*10)]
            
            return cell
        } else {
            let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "thingDisplay") as! TodayTableViewCell
            if indexPath.section != 3 {
                let thing = returnedThings[indexPath.section - 1][indexPath.row]
                if(thing.isDone) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                
                let text = thing.desc
                cell.label.text = text
            } else {
                print(returnedRecurs.count)
                print(indexPath.row)
                let thing = returnedRecurs[indexPath.row]
                if(thing.isDone) {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
                
                let text = thing.desc
                cell.label.text = text
            }
            return cell
        }
        
    }
    
    //Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todayThingsTable.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section != 3 {
            let thing = returnedThings[indexPath.section - 1][indexPath.row]
            
            if let cell = todayThingsTable.cellForRow(at: indexPath) as? TodayTableViewCell {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    thing.isDone = false
                } else {
                    cell.accessoryType = .checkmark
                    thing.isDone = true
                }
            }
        } else {
            let thing = returnedRecurs[indexPath.row]
            
            if let cell = todayThingsTable.cellForRow(at: indexPath) as? TodayTableViewCell {
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    thing.isDone = false
                } else {
                    cell.accessoryType = .checkmark
                    thing.isDone = true
                }
            }
        }
        
        //Save
        let context = AppDelegate.viewContext
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        reloadView()
    }
    
    //MARK: - Segue Functions
    @IBAction func unwindToMain (_ sender:UIStoryboardSegue) {
        print("unwindToMain")
    }
    
    @IBAction func backToToday(_ sender:UIStoryboardSegue){
        print("Back to today")
        saveDay()
        reset(sender)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
    }
    
    func reloadView() {
        print("Today reloaded")
        returnedMissions = MissionControl.getTodayMissions()
        returnedGoals = GoalControl.getTodayGoals()
        returnedThings = [returnedMissions, returnedGoals]
        returnedRecurs = RecurringControl.getThisDayRecurs(passedDate: UD.genDate)
        
        todayThingsTable.reloadData()
    }
    
}

