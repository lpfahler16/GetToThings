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
        return allRecurs!
    }
    
    //Adds new mission
    static func newRecur(_ desc: String, _ daysOfWeek: String, _ replacement: Bool) {
        let context = AppDelegate.viewContext
        let thing = RecurringThing(context: context)
        
        thing.desc = desc
        thing.daysOfWeek = daysOfWeek
        thing.numCompleted = 0
        thing.numGenerated = 0
        thing.dateAdded = Date()
        do {
            try context.save()
        } catch {
            print("**** Save failed ****")
        }
        
    }
    
    static func getTodayRecurs() -> [RecurringThing]{
        
    }
    
}
