//
//  ExtensionController.swift
//  GetToThings
//
//  Created by Logan Pfahler on 7/30/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData
import UIKit

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}

class ExtensionControl {
    //MARK: - Get Things
    
    static func getMissions() -> [Thing] {
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        request.predicate = NSPredicate(format: "isMission = %d", true)
        
        let context = self.persistentContainer.viewContext
        let allMissions = try? context.fetch(request)
        return allMissions!
    }
    
    static func getGoals() -> [Thing] {
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        request.predicate = NSPredicate(format: "isMission = %d", false)
        
        let context = self.persistentContainer.viewContext
        let allGoals = try? context.fetch(request)
        return allGoals!
    }
    
    static func getTodayMissions() -> [Thing]{
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
    
    static func getTodayGoals() -> [Thing]{
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
    
    //MARK: - Get Recurs
    
    //Gets all recurs
    static func getRecurs() -> [RecurringThing] {
        let request: NSFetchRequest<RecurringThing> = RecurringThing.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let context = self.persistentContainer.viewContext
        let allRecurs = try? context.fetch(request)
        return allRecurs!
    }
    
    static func getDayRecurs() -> [[RecurringThing]] {
        let allRecurs = getRecurs()
        return [getSundayRecurs(allRecurs), getMondayRecurs(allRecurs), getTuesdayRecurs(allRecurs), getWednesdayRecurs(allRecurs), getThursdayRecurs(allRecurs), getFridayRecurs(allRecurs), getSaturdayRecurs(allRecurs)]
    }
    
    static func getTodayRecurs() -> [RecurringThing] {
        let date = Date()
        let dayOfWeek = date.dayNumberOfWeek()! - 1
        print(dayOfWeek)
        
        let allFromDay = getDayRecurs()[dayOfWeek]
        var returnRecurs:[RecurringThing] = []
        
        for day in allFromDay {
            if day.dateAdded! <= Date() {
                let initialWeekOfYear = Calendar.current.component(.weekOfYear, from: day.dateAdded!)
                let currentWeekOfYear = Calendar.current.component(.weekOfYear, from: Date())
                let diff = initialWeekOfYear % Int(day.frequency)
                let curMod = currentWeekOfYear % Int(day.frequency)
                
                if diff == curMod {
                    print("Check!")
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
    
    
    static func getSundayRecurs(_ allRecurs: [RecurringThing]) -> [RecurringThing]{
        var recurs:[RecurringThing] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("0")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getMondayRecurs(_ allRecurs: [RecurringThing]) -> [RecurringThing]{
        var recurs:[RecurringThing] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("1")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getTuesdayRecurs(_ allRecurs: [RecurringThing]) -> [RecurringThing]{
        var recurs:[RecurringThing] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("2")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getWednesdayRecurs(_ allRecurs: [RecurringThing]) -> [RecurringThing]{
        var recurs:[RecurringThing] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("3")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getThursdayRecurs(_ allRecurs: [RecurringThing]) -> [RecurringThing]{
        var recurs:[RecurringThing] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("4")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getFridayRecurs(_ allRecurs: [RecurringThing]) -> [RecurringThing]{
        var recurs:[RecurringThing] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("5")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    static func getSaturdayRecurs(_ allRecurs: [RecurringThing]) -> [RecurringThing]{
        var recurs:[RecurringThing] = []
        for recur in allRecurs {
            if recur.daysOfWeek!.contains(Character("6")) {
                recurs.append(recur)
            }
        }
        return recurs
    }
    
    
    //MARK: - Core Data
    static var persistentContainer: NSPersistentContainer = {
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
    
    static func saveContext () {
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
