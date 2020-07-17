//
//  GoalControl.swift
//  GetToThings
//
//  Created by Logan Pfahler on 4/10/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData

class GoalControl {
    
    //Gets all goals
    static func getGoals(_ goodWeather: Bool) -> [Thing] {
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        
        if goodWeather {
            request.predicate = NSPredicate(format: "isMission = %d", false)
        } else {
            let goalPredicate = NSPredicate(format: "isMission = %d", false)
            let weatherPredicate = NSPredicate(format: "needsGoodWeather = %d", false)
            let predicates = [goalPredicate, weatherPredicate]
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let context = AppDelegate.viewContext
        let allGoals = try? context.fetch(request)
        return allGoals!
    }
    
    static func getGoals() -> [Thing] {
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        request.predicate = NSPredicate(format: "isMission = %d", false)
        
        let context = AppDelegate.viewContext
        let allGoals = try? context.fetch(request)
        return allGoals!
    }
    
    //Adds new goal
    static func newGoal(_ desc: String, _ needsGoodWeather: Bool, _ replacement: Bool) {
        let context = AppDelegate.viewContext
        let thing = Thing(context: context)
        
        thing.desc = desc
        thing.needsGoodWeather = needsGoodWeather
        thing.replacement = replacement
        thing.isMission = false
        thing.today = false
        thing.numCompleted = 0
        thing.numGenerated = 0
        thing.dateAdded = Date()
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        
    }
    
    static func generateTodayGoals(_ goodWeather: Bool) {
        let allGoals = getGoals(goodWeather).shuffled()
        let theseGoals = Array(allGoals.prefix(Int(UserDefaults.standard.double(forKey: "numGoals"))))
        for goal in theseGoals {
            goal.today = true
        }
        
        //Save
        let context = AppDelegate.viewContext
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
    }
    
    static func getTodayGoals() -> [Thing]{
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let goalPredicate = NSPredicate(format: "isMission = %d", false)
        let todayPredicate = NSPredicate(format: "today = %d", true)
        let predicates = [goalPredicate, todayPredicate]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let context = AppDelegate.viewContext
        context.refreshAllObjects()
        let todayGoals = try? context.fetch(request)
        return todayGoals!
    }
    
}
