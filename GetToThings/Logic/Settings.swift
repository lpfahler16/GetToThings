//
//  Settings.swift
//  GetToThings
//
//  Created by Logan Pfahler on 8/28/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation
import UIKit

class UD {
    static func color() -> UIColor {
        return Settings.colorPattern()[UserDefaults.standard.integer(forKey: "color")]
    }
    static func genDate() -> Date {
        return UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date
    }
    static func firstLaunch() -> Date {
        return UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "firstLaunchDate") as! Date
    }
    static func generated() -> Bool {
        return UserDefaults(suiteName: "group.GetToThings")!.bool(forKey: "generated")
    }
    static func numTasks() -> Double {
        return UserDefaults.standard.double(forKey: "numMissions")
    }
    static func numGoals() -> Double {
        return UserDefaults.standard.double(forKey: "numGoals")
    }
}

struct Settings {
    static func colorPattern() -> [UIColor] {
        return [UIColor(named: "Main Blue")!, UIColor(named: "Main Red")!, UIColor(named: "Main Green")!, UIColor(named: "Main Purple")!]
    }
}
