//
//  ReccuringControl.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/10/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

class RecurringControl {
    
    //Gets all missions
    static func getRecurs() -> [WeekRecur] {
        let request: NSFetchRequest<WeekRecur> = WeekRecur.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let context = AppDelegate.viewContext
        let allRecurs = try? context.fetch(request)
        return allRecurs!
    }
    
    //Adds new Recur
    static func newRecur(_ desc: String, _ daysOfWeek: String, _ frequency: Int16, _ date: Date) {
        let context = AppDelegate.viewContext
        let thing = WeekRecur(context: context)
        
        thing.desc = desc
        thing.daysOfWeek = daysOfWeek
        thing.numCompleted = 0
        thing.numGenerated = 0
        thing.frequency = frequency
        thing.dateAdded = date
        thing.isDone = false
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        print("Added!")
    }
    
    static func getDayRecurs() -> [[WeekRecur]] {
        let allRecurs = getRecurs()
        return [getSundayRecurs(allRecurs), getMondayRecurs(allRecurs), getTuesdayRecurs(allRecurs), getWednesdayRecurs(allRecurs), getThursdayRecurs(allRecurs), getFridayRecurs(allRecurs), getSaturdayRecurs(allRecurs)]
    }
    
    static func getTodayRecurs() -> [WeekRecur] {
        let date = Date()
        let dayOfWeek = date.dayNumberOfWeek()! - 1
        
        let allFromDay = getDayRecurs()[dayOfWeek]
        var returnRecurs:[WeekRecur] = []
        
        for day in allFromDay {
            if day.dateAdded! <= Date() {
                let initialWeekOfYear = Calendar.current.component(.weekOfYear, from: day.dateAdded!)
                let currentWeekOfYear = Calendar.current.component(.weekOfYear, from: Date())
                let diff = initialWeekOfYear % Int(day.frequency)
                let curMod = currentWeekOfYear % Int(day.frequency)
                
                if diff == curMod {
                    returnRecurs.append(day)
                } else {
                    print("NO")
                }
            } else {
                print("Too early!")
            }
        }
        
        return returnRecurs
    }
    
    static func getThisDayRecurs(passedDate: Date) -> [WeekRecur] {
        let date = passedDate
        let dayOfWeek = date.dayNumberOfWeek()! - 1
        
        let allFromDay = getDayRecurs()[dayOfWeek]
        var returnRecurs:[WeekRecur] = []
        
        for day in allFromDay {
            if day.dateAdded! <= Date() {
                let initialWeekOfYear = Calendar.current.component(.weekOfYear, from: day.dateAdded!)
                let currentWeekOfYear = Calendar.current.component(.weekOfYear, from: passedDate)
                let diff = initialWeekOfYear % Int(day.frequency)
                let curMod = currentWeekOfYear % Int(day.frequency)
                
                if diff == curMod {
                    returnRecurs.append(day)
                } else {
                    print("NO")
                }
            } else {
                print("Too early!")
            }
        }
        
        return returnRecurs
    }
    
    
    static func getSundayRecurs(_ allRecurs: [WeekRecur]) -> [WeekRecur]{
        var recurs:[WeekRecur] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("0")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getMondayRecurs(_ allRecurs: [WeekRecur]) -> [WeekRecur]{
        var recurs:[WeekRecur] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("1")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getTuesdayRecurs(_ allRecurs: [WeekRecur]) -> [WeekRecur]{
        var recurs:[WeekRecur] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("2")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getWednesdayRecurs(_ allRecurs: [WeekRecur]) -> [WeekRecur]{
        var recurs:[WeekRecur] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("3")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getThursdayRecurs(_ allRecurs: [WeekRecur]) -> [WeekRecur]{
        var recurs:[WeekRecur] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("4")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getFridayRecurs(_ allRecurs: [WeekRecur]) -> [WeekRecur]{
        var recurs:[WeekRecur] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("5")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getSaturdayRecurs(_ allRecurs: [WeekRecur]) -> [WeekRecur]{
        var recurs:[WeekRecur] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("6")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func removeDayOfRecur(recur: WeekRecur, day: Int) {
        let allDays = ["0", "1", "2", "3", "4", "5", "6"]
        let newDays = recur.daysOfWeek!.replacingOccurrences(of: allDays[day], with: "")
        
        let context = AppDelegate.viewContext
        
        if (newDays == "") {
            context.delete(recur)
        } else {
            recur.daysOfWeek = newDays
        }
        
        // Save
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
    }
    
}
