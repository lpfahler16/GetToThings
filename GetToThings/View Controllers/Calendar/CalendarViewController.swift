//
//  CalendarViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 7/13/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import FSCalendar
import CoreData

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    //MARK: - Instance Variables and Outlets
    @IBOutlet weak var calendar: FSCalendar!
    
    var passDay:Day? = nil
    var passDate:Date? = nil
    var allDays:[Day] = []
    
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
    
    
    // MARK: - Initial Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialLaunch() // Checks if launched before and sets up info
        setupView() // Sets up what to show and what colors
        reloadView() // Fetches proper elements to populate table
        
        //Calendar setup
        calendar.dataSource = self
        calendar.delegate = self
    }
    
    // MARK: - Initial Setup Helpers
    
    @IBAction func infoClicked(_ sender: Any) {
        info()
    }
    
    func info() {
        let alertController = UIAlertController(title: "Calendar", message:
           "See information on how often you have been completing your things. Green days means you completed them all!", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Thanks!", style: .default))

        self.present(alertController, animated: true, completion: nil)
    }
    
    private func initialLaunch() {
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBeforeCalendar")
        if !launchedBefore {
            UserDefaults.standard.set(true, forKey: "launchedBeforeCalendar")
            info()
        }
    }
    
    private func setupView() {
        calendar.placeholderType = .none
        calendar.scrollDirection = .vertical
        calendar.pagingEnabled = false
    }
    
    // MARK: - Calendar Setup
    
    //Setting max and min date
    func minimumDate(for calendar: FSCalendar) -> Date {
        return UD.firstLaunch()
    }
        
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    //Setting colors
    /// Fill colors
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        if date > Date() {
            return nil
        }
        for days in allDays {
            if Calendar.current.isDate(days.date!, inSameDayAs: date) {
                return colors[Int(days.ratio*10)]
            }
        }
        return nil
    }
    
    /// Number colors
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        if date > Date() {
            return nil
        }
        for days in allDays {
            if Calendar.current.isDate(days.date!, inSameDayAs: date) {
                return UIColor(named: "WhiteBlack")
            }
        }
        return nil
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        calendar.reloadData()
    }
    
    
    //Selection
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.deselect(date)
        
        //Find corresponding day
        var datePresent = false
        for days in allDays {
            if Calendar.current.isDate(days.date!, inSameDayAs: date) {
                passDay = days
                datePresent = true
            }
        }
        if !datePresent {
            passDay = nil
        }
        passDate = date
        
        self.performSegue(withIdentifier: "showDay", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showDay") {
            // get a reference to the second view controller
            let secondViewController = segue.destination as! DayViewController

            // get the date time String from the date object
            
            
            secondViewController.day = passDay
            secondViewController.date = passDate
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        print("Calendar reloaded")
    }
    
    func reloadView(){
        let request: NSFetchRequest<Day> = Day.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        let context = AppDelegate.viewContext
        context.refreshAllObjects()
        allDays = (try? context.fetch(request))!
        calendar.reloadData()
    }
    
    @IBAction func unwindToMain (_ sender:UIStoryboardSegue) {
        print("unwindToMain")
    }
    

}
