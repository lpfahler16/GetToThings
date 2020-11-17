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
    
    //Data setup
    var returnedMissions:[RandomTask] = []
    var returnedGoals:[RandomGoal] = []
    var returnedRecurs:[WeekRecur] = []
    var returnedThings:[[AllThing]] = []
    var goodWeather = true
    
    // Table View Information
    let headerNames = ["", "Tasks", "Goals", "Recurring"]
    var numOfSections:Int = 4
    var rowsForSection:[Int] = []
    
    //MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLaunch() // Checks if launched before and sets up user defaults
        Conversion.convertAll() // Converts any old objects to new
        checkDate() // Segues to new day screen if necessary
        setupView() // Sets up what to show and what colors
        reloadView() // Fetches proper elements to populate table
        
        // Delegates and data sources
        todayThingsTable.dataSource = self
        todayThingsTable.delegate = self
        
        //Foreground stuff
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    //MARK: - Initial Setup Helpers
    
    // Checks if launched before and sets up user defaults
    private func initialLaunch() {
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
    }
    
    // Sets up what to show and what colors
    private func setupView() {
        // What shows
        if UD.generated() {
            tableContainer.isHidden = false
            genButton.isHidden = true
        } else {
            tableContainer.isHidden = true
            genButton.isHidden = false
        }
        
        //Colors
        mainView.backgroundColor = UD.color()
        realGenButton.backgroundColor = UD.color()
        weatherButton.tintColor = UD.color()
    }
    
    // Segues to new day screen if necessary
    private func checkDate() {
        let sameDay = Calendar.current.isDate(UD.genDate(), inSameDayAs: Date(/*For testing:timeIntervalSince1970: 0*/))
        
        if UD.generated() && !sameDay {
            self.performSegue(withIdentifier: "endDay", sender: self)
        }
    }
    
    //MARK: - Generation
    
    @IBAction func generate(_ sender: Any) {
        //Mark sure it is visible
        if genButton.isHidden == false {
            
            genButton.isHidden = true
            tableContainer.isHidden = false
            
            CoreControl.generateTodayThings(goodWeather)
            
            UserDefaults(suiteName: "group.GetToThings")!.set(true, forKey: "generated")
            UserDefaults(suiteName: "group.GetToThings")!.set(Date(), forKey: "generateDate")
            
            numOfSections = 1
            reloadView() //
            animateShow() // Starts animation of sections
        }
    }
    
    // Button press for change in weather
    @IBAction func weatherChange(_ sender: Any) {
        let button = sender as! UIButton
        if goodWeather {
            button.setBackgroundImage(UIImage(systemName: "cloud.rain.fill"), for: UIControl.State.normal)
            goodWeather = false
        } else {
            button.setBackgroundImage(UIImage(systemName: "sun.max.fill"), for: UIControl.State.normal)
            goodWeather = true
        }
    }
    
    //MARK: - Generation Helpers
    
    //Fade in
    private func animateShow() {
        _ = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
    }
    
    @objc func fireTimer(){
        numOfSections += 1
        todayThingsTable.reloadData()
        if numOfSections < 4 {
            animateShow()
        }
    }
    
    //MARK: - Notification Control
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    private func info() {
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
            
            self.reset(sender)
        }))

        self.present(alertController, animated: true, completion: nil)

    }
    
    @IBAction func reset(_ sender: Any) {
        
        let context = AppDelegate.viewContext
        
        for list in returnedThings {
            if let theList = list as? [RandomThing] { // Task or Goal
                for thing in theList {
                    if let _ = sender as? UIStoryboardSegue, thing.today {
                        thing.numGenerated += 1
                        if thing.isDone {
                            thing.numCompleted += 1
                        }
                    }
                    
                    if let _ = sender as? UIStoryboardSegue, thing.replacement == false && thing.isDone && thing.today {
                        context.delete(thing)
                    } else {
                        thing.today = false
                        thing.isDone = false
                    }
                }
            } else { // Recur
                for thing in list {
                    if let _ = sender as? UIStoryboardSegue {
                        thing.numGenerated += 1
                        if thing.isDone {
                            thing.numCompleted += 1
                        }
                    }
                    thing.isDone = false
                }
            }
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
        
        //Test Date setup ------------------
        // Specify date components
        //var dateComponents = DateComponents()
        //dateComponents.year = 2020
        //dateComponents.month = 7
        //dateComponents.day = 6
        // Create date from components
        //let userCalendar = Calendar.current // user calendar
        //let someDateTime = userCalendar.date(from: dateComponents)
        //----------------------------------
        
        let context = AppDelegate.viewContext
        
        reloadView()
        let allThings = returnedMissions + returnedGoals + returnedRecurs
        
        let day = Day(context: context)
        day.date = UD.genDate()
        day.ratio = getRatio()
        
        for thing in allThings {
            let simpleThing = SimpleThing(context: context)
            simpleThing.desc = thing.desc
            simpleThing.completed = thing.isDone
            day.addToTheThings(simpleThing)
        }
        
        //Save
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
    }
    
    // MARK: - Saving Day Helpers
    func getRatio() -> Double {
        
        let allThings = returnedMissions + returnedGoals + returnedRecurs
        var complete = 0
        
        for thing in allThings {
            if thing.isDone {
                complete += 1
            }
        }
        if allThings.count == 0 {
            return 0
        } else {
            return Double(complete)/Double(allThings.count)
        }
    }
    
    
    //MARK: - Table View Setup
    
    //Number of sections
    func numberOfSections(in todayThingsTable: UITableView) -> Int {
        return numOfSections
    }
    
    //Number of rows in each section
    func tableView(_ todayThingsTable: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowsForSection[section]
    }
    
    //Section Titles
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerNames[section]
    }
    
    //Setting Row Data
    func tableView(_ todayThingsTable: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return makeHeader()
        } else {
            let thing = returnedThings[indexPath.section - 1][indexPath.row]
            return buildCell(thing)
        }
        
    }
    
    //Selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todayThingsTable.deselectRow(at: indexPath, animated: true)
    
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
        
        //Save
        let context = AppDelegate.viewContext
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        reloadView()
    }
    
    // MARK: Table View Helpers
    
    //Build Cell
    private func buildCell(_ thing: AllThing) -> TodayTableViewCell {
        let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "thingDisplay") as! TodayTableViewCell
        if(thing.isDone) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        let text = thing.desc
        cell.label.text = text
        
        return cell
    }
    
    //Make header cell
    private func makeHeader() -> TodayTableViewCell{
        let cell = todayThingsTable.dequeueReusableCell(withIdentifier: "dateViewer") as! TodayTableViewCell

        // Formatting Date --- TODO: Move
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .long
        cell.label.text = formatter.string(from: UD.genDate())
        
        let ratio = CGFloat(getRatio())
        
        cell.label.textColor = UIColor(hue: 0.325, saturation: ratio, brightness: 0.7, alpha: 1)
        
        return cell
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
    @objc func appMovedToForeground() {
        checkDate()
        reloadView()
    }
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        setupView()
    }
    
    // Fetches proper elements to populate table
    private func reloadView() {
        print("Today reloaded")
        returnedMissions = MissionControl.getTodayMissions()
        returnedGoals = GoalControl.getTodayGoals()
        returnedRecurs = RecurringControl.getThisDayRecurs(passedDate: UD.genDate())
        returnedThings = [returnedMissions, returnedGoals, returnedRecurs]
        rowsForSection = [1, returnedMissions.count, returnedGoals.count, returnedRecurs.count]
        
        todayThingsTable.reloadData()
    }
    
}

