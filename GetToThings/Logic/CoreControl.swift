//
//  coreControl.swift
//  GetToThings
//
//  Created by Logan Pfahler on 10/23/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData

enum ThingType {
    case randomTask
    case randomGoal
    case weekRecur
    case all
}

class CoreControl {
    
    static func getThing(type: ThingType) -> [AllThing] {
        
        //Setup for fetch
        let context = AppDelegate.viewContext
        var allThings: [AllThing] = []
        
        //Fetch by type
        switch type {
        case .randomTask: do {
            let request: NSFetchRequest<RandomTask> = RandomTask.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
            allThings = try! context.fetch(request) as [AllThing]
            
        } case .randomGoal: do {
            let request: NSFetchRequest<RandomGoal> = RandomGoal.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
            allThings = try! context.fetch(request) as [AllThing]
            
        } case .weekRecur: do {
            let request: NSFetchRequest<WeekRecur> = WeekRecur.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
            allThings = try! context.fetch(request) as [AllThing]
            
        } case .all:
            let request: NSFetchRequest<AllThing> = AllThing.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
            allThings = try! context.fetch(request) as [AllThing]
        }
        
        //Return Array
        return allThings
    }
    
    // returns all randoms of given other type
    // TODO: Finish
    static func getRandomOther(type: String) {
        
        //Setup for fetch
        let context = AppDelegate.viewContext
        var allThings: [AllThing] = []
    }
    
    static func convertRandomType(theThing: RandomThing) {
        let context = AppDelegate.viewContext
        
        if let _ = theThing as? RandomTask {
            let thing = RandomGoal(context: context)
            
            thing.desc = theThing.desc
            thing.needsGoodWeather = theThing.needsGoodWeather
            thing.replacement = theThing.replacement
            thing.today = theThing.today
            thing.numCompleted = theThing.numCompleted
            thing.numGenerated = theThing.numGenerated
            thing.dateAdded = theThing.dateAdded
        } else {
            let thing = RandomTask(context: context)
            
            thing.desc = theThing.desc
            thing.needsGoodWeather = theThing.needsGoodWeather
            thing.replacement = theThing.replacement
            thing.today = theThing.today
            thing.numCompleted = theThing.numCompleted
            thing.numGenerated = theThing.numGenerated
            thing.dateAdded = theThing.dateAdded
        }
        
        context.delete(theThing)
        
        // Save
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
    }
    
    
    static func getTodayThing(type: ThingType) -> [RandomThing]{
        if let allThing:[RandomThing] = getThing(type: type) as? [RandomThing] {
            var allThings:[RandomThing] = []
            for elt in allThing {
                if elt.today {
                    allThings.append(elt)
                }
            }
            return allThings
            
        } else {
            return []
        }
    }
    
    static func generateTodayThings(_ weather: Bool) {
        MissionControl.generateTodayMissions(weather)
        GoalControl.generateTodayGoals(weather)
    }
}
