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
    static var color = Settings.colorPattern[UserDefaults.standard.integer(forKey: "color")]!
    static var genDate = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "generateDate") as! Date
    static var firstLaunch = UserDefaults(suiteName: "group.GetToThings")!.object(forKey: "firstLaunchDate") as! Date
    static var generated = UserDefaults(suiteName: "group.GetToThings")!.bool(forKey: "generated")
    static var numTasks = UserDefaults.standard.double(forKey: "numMissions")
    static var numGoals = UserDefaults.standard.double(forKey: "numGoals")
}

class Settings {
    static var colorPattern = [UIColor(named: "Main Blue"), UIColor(named: "Main Red"), UIColor(named: "Main Green"), UIColor(named: "Main Purple")]
}
