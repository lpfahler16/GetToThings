//
//  ReccuringControl.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/10/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData

class RecurringControl {
    
    //Gets all missions
    static func getRecurs() -> [RecurringThing] {
        let request: NSFetchRequest<RecurringThing> = RecurringThing.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "desc", ascending: true)]
        
        let context = AppDelegate.viewContext
        let allRecurs = try? context.fetch(request)
        print("Got!")
        return allRecurs!
    }
    
    //Adds new Recur
    static func newRecur(_ desc: String, _ daysOfWeek: String, _ frequency: Int16) {
        let context = AppDelegate.viewContext
        let thing = RecurringThing(context: context)
        
        thing.desc = desc
        thing.daysOfWeek = daysOfWeek
        thing.numCompleted = 0
        thing.numGenerated = 0
        thing.frequency = frequency
        thing.dateAdded = Date()
        thing.isDone = false
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        print("Added!")
    }
    
    static func getDayRecurs() -> [[RecurringThing]] {
        let allRecurs = getRecurs()
        return [getSundayRecurs(allRecurs), getMondayRecurs(allRecurs), getTuesdayRecurs(allRecurs), getWednesdayRecurs(allRecurs), getThursdayRecurs(allRecurs), getFridayRecurs(allRecurs), getSaturdayRecurs(allRecurs)]
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
    
}
