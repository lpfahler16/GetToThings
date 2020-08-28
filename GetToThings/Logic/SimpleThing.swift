//
//  SimpleThing.swift
//  GetToThings
//
//  Created by Logan Pfahler on 7/14/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import CoreData

class SimpleThing:NSManagedObject {
    
    override public var description: String { return "\(String(describing: self.desc)) is \(self.completed)" }
}
