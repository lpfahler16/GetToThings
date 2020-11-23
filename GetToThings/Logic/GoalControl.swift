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
    static func getGoals(_ goodWeather: Bool) -> [RandomGoal] {
        var allGoals = CoreControl.getThing(type: .randomGoal) as! [RandomGoal]
        if goodWeather {
            allGoals = allGoals.filter { elt in !elt.disabled }
        } else {
            allGoals = allGoals.filter { elt in !elt.disabled && !elt.needsGoodWeather }
        }
        return allGoals
    }
    
    static func getGoals() -> [RandomGoal] {
        return CoreControl.getThing(type: .randomGoal) as! [RandomGoal]
    }
    
    //Adds new goal
    static func newGoal(_ desc: String, _ needsGoodWeather: Bool, _ replacement: Bool) {
        let context = AppDelegate.viewContext
        let thing = RandomGoal(context: context)
        
        thing.desc = desc
        thing.needsGoodWeather = needsGoodWeather
        thing.replacement = replacement
        thing.today = false
        thing.disabled = false
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
        let theseGoals = Array(allGoals.prefix(Int(UD.numGoals())))
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
    
    static func getTodayGoals() -> [RandomGoal]{
        let request: NSFetchRequest<RandomGoal> = RandomGoal.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let todayPredicate = NSPredicate(format: "today = %d", true)
        let predicates = [todayPredicate]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        
        let context = AppDelegate.viewContext
        context.refreshAllObjects()
        let todayGoals = try? context.fetch(request)
        return todayGoals!
    }
    
}
