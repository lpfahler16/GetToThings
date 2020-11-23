//
//  MissionControl.swift
//  GetToThings
//
//  Created by Logan Pfahler on 4/9/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData

class MissionControl {

    //Gets all tasks given weather
    /*static func getMissions(_ goodWeather: Bool) -> [RandomTask] {
        let request: NSFetchRequest<RandomTask> = RandomTask.fetchRequest()
        
        if goodWeather {
        } else {
            let weatherPredicate = NSPredicate(format: "needsGoodWeather = %d", false)
            let predicates = [weatherPredicate]
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let context = AppDelegate.viewContext
        let allMissions = try? context.fetch(request)
        return allMissions!
    }*/
    
    // Gets all tasks given weather
    static func getMissions(_ goodWeather: Bool) -> [RandomTask] {
        var allMissions = CoreControl.getThing(type: .randomTask) as! [RandomTask]
        if goodWeather {
            allMissions = allMissions.filter { elt in !elt.disabled }
        } else {
            allMissions = allMissions.filter { elt in !elt.disabled && !elt.needsGoodWeather }
        }
        return allMissions
    }
    
    // Gets all tasks
    static func getMissions() -> [RandomTask] {
        return CoreControl.getThing(type: .randomTask) as! [RandomTask]
    }
    
    //Adds new mission
    static func newMission(_ desc: String, _ needsGoodWeather: Bool, _ replacement: Bool) {
        let context = AppDelegate.viewContext
        let thing = RandomTask(context: context)
        
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
    
    //Generates today's tasks
    static func generateTodayMissions(_ goodWeather: Bool) {
        let allMissions = getMissions(goodWeather).shuffled()
        let theseMissions = Array(allMissions.prefix(Int(UD.numTasks())))
        for mission in theseMissions {
            mission.today = true
        }
        
        //Save
        let context = AppDelegate.viewContext
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
    }
    
    //Gets today's missions
    static func getTodayMissions() -> [RandomTask]{
        let request: NSFetchRequest<RandomTask> = RandomTask.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let todayPredicate = NSPredicate(format: "today = %d", true)
        let predicates = [todayPredicate]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let context = AppDelegate.viewContext
        context.refreshAllObjects()
        let todayMissions = try? context.fetch(request)
        return todayMissions!
    }
    
}
