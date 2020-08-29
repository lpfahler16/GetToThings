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
    
    //Gets all missions
    static func getMissions(_ goodWeather: Bool) -> [Thing] {
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        
        if goodWeather {
            request.predicate = NSPredicate(format: "isMission = %d", true)
        } else {
            let missionPredicate = NSPredicate(format: "isMission = %d", true)
            let weatherPredicate = NSPredicate(format: "needsGoodWeather = %d", false)
            let predicates = [missionPredicate, weatherPredicate]
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let context = AppDelegate.viewContext
        let allMissions = try? context.fetch(request)
        return allMissions!
    }
    
    static func getMissions() -> [Thing] {
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        request.predicate = NSPredicate(format: "isMission = %d", true)
        
        let context = AppDelegate.viewContext
        let allMissions = try? context.fetch(request)
        return allMissions!
    }
    
    //Adds new mission
    static func newMission(_ desc: String, _ needsGoodWeather: Bool, _ replacement: Bool) {
        let context = AppDelegate.viewContext
        let thing = Thing(context: context)
        
        thing.desc = desc
        thing.needsGoodWeather = needsGoodWeather
        thing.replacement = replacement
        thing.isMission = true
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
    
    static func generateTodayMissions(_ goodWeather: Bool) {
        let allMissions = getMissions(goodWeather).shuffled()
        let theseMissions = Array(allMissions.prefix(Int(UD.numTasks)))
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
    
    static func getTodayMissions() -> [Thing]{
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let missionPredicate = NSPredicate(format: "isMission = %d", true)
        let todayPredicate = NSPredicate(format: "today = %d", true)
        let predicates = [missionPredicate, todayPredicate]
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let context = AppDelegate.viewContext
        context.refreshAllObjects()
        let todayMissions = try? context.fetch(request)
        return todayMissions!
    }
    
}
