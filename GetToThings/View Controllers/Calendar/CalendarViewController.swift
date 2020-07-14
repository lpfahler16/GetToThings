//
//  CalendarViewController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 7/13/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    //MARK: - Instance Variables and Outlets
    @IBOutlet weak var calendar: FSCalendar!
    
    var passDate = Date()
    
    let colors = [UIColor(red: 1.00, green: 0.00, blue: 0.00, alpha: 1.00),
                  //UIColor(red: 1.00, green: 0.20, blue: 0.00, alpha: 1.00),
                  //UIColor(red: 1.00, green: 0.40, blue: 0.00, alpha: 1.00),
                  //UIColor(red: 1.00, green: 0.60, blue: 0.00, alpha: 1.00),
                  nil,
                  //UIColor(red: 1.00, green: 0.80, blue: 0.00, alpha: 1.00),
                  UIColor(red: 1.00, green: 1.00, blue: 0.00, alpha: 1.00),
                  //UIColor(red: 0.60, green: 1.00, blue: 0.00, alpha: 1.00),
                  //UIColor(red: 0.40, green: 1.00, blue: 0.00, alpha: 1.00),
                  //UIColor(red: 0.20, green: 1.00, blue: 0.00, alpha: 1.00),
                  UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 1.00)]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.placeholderType = .none
        calendar.scrollDirection = .vertical
        calendar.pagingEnabled = false
    }
    
    //Setting max and min date
    func minimumDate(for calendar: FSCalendar) -> Date {
        // Specify date components
        var dateComponents = DateComponents()
        dateComponents.year = 2020
        dateComponents.month = 7
        dateComponents.day = 1

        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents)
        return someDateTime!
    }
        
    func maximumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    //Setting colors
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        print("-")
        
        if date > Date() {
            return nil
        }
        
        if Calendar.current.isDate(Date(), inSameDayAs: date) {
            return nil
        }
        return colors.shuffled()[0]
    }
    
    
    //Selection
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        calendar.deselect(date)
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
            let formatter = DateFormatter()
            formatter.timeStyle = .none
            formatter.dateStyle = .long
            
            secondViewController.pageTitle.title = formatter.string(from: passDate)
        }
    }
    

}
