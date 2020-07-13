//
//  NSCustomPersistentContainer.swift
//  GetToThings
//
//  Created by Logan Pfahler on 6/28/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import UIKit
import CoreData

class NSCustomPersistentContainer: NSPersistentContainer {
    
    override open class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.GetToThings")
        storeURL = storeURL?.appendingPathComponent("GetToThings.sqlite")
        return storeURL!
    }
    
}
