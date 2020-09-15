//
//  Conversion.swift
//  GetToThings
//
//  Created by Logan Pfahler on 9/14/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData

class Conversion {
    static func convertAll() {
        let request: NSFetchRequest<Thing> = Thing.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        let context = AppDelegate.viewContext
        let allThings = try? context.fetch(request)
        
        for thing in allThings! {
            if thing.isMission {
                convertToTask(thing)
            } else {
                convertToGoal(thing)
            }
        }
        
        let request2: NSFetchRequest<RecurringThing> = RecurringThing.fetchRequest()
        request2.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        let allRecurs = try? context.fetch(request2)
        
        for recur in allRecurs! {
            convertToRecur(recur)
        }
        
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        print("Saved!")
    }
    
    static func convertToTask(_ thing:Thing) {
        
        let context = AppDelegate.viewContext
        let new = RandomTask(context: context)
        
        new.desc = thing.desc
        new.needsGoodWeather = thing.needsGoodWeather
        new.replacement = thing.replacement
        new.today = thing.today
        new.numCompleted = thing.numCompleted
        new.numGenerated = thing.numGenerated
        new.dateAdded = thing.dateAdded

        context.delete(thing)
    }
    
    static func convertToGoal(_ thing:Thing) {
        
        let context = AppDelegate.viewContext
        let new = RandomGoal(context: context)

        new.desc = thing.desc
        new.needsGoodWeather = thing.needsGoodWeather
        new.replacement = thing.replacement
        new.today = thing.today
        new.numCompleted = thing.numCompleted
        new.numGenerated = thing.numGenerated
        new.dateAdded = thing.dateAdded

       context.delete(thing)
    }
    
    static func convertToRecur(_ thing:RecurringThing) {
        
        let context = AppDelegate.viewContext
        let new = WeekRecur(context: context)
        
        new.desc = thing.desc
        new.daysOfWeek = thing.daysOfWeek
        new.numCompleted = thing.numCompleted
        new.numGenerated = thing.numGenerated
        new.frequency = thing.frequency
        new.dateAdded = thing.dateAdded
        new.isDone = thing.isDone
        
        context.delete(thing)
    }
}
