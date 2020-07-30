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
