//
//  Stats.swift
//  GetToThings
//
//  Created by Logan Pfahler on 11/13/20.
//  Copyright © 2020 Logan Pfahler. All rights reserved.
//

import Foundation

struct Stats {
    let allTheDays: [Day]
    
    init(all: [Day]) {
        allTheDays = all
    }
    
    func currGenStreak() -> Int {
        //Reverse array
        var allDays = allTheDays
        allDays.reverse()
        
        //loop to find current gen streak
        var CGnumDays = 0
        var CGpreviousDay:Day? = nil
        print("\nCurrent Generation Streak")
        for day in allDays {
            
            print(day.date!)
            
            if CGpreviousDay == nil {
                
                //First day in the loop
                print("Day 1 check")
                let CGdayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: day.date!)).day
                if CGdayDifference == -1 {
                    CGnumDays += 1
                    CGpreviousDay = day
                    print("Day 1")
                }
                
            } else {
                print("Day after check")
                let CGdayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: CGpreviousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                if CGdayDifference == -1 {
                    CGnumDays += 1
                    CGpreviousDay = day
                    print("Day after")
                }
                
            }
        }
        return CGnumDays
    }
    
    func longGenStreak() -> Int {
        //loop to find current gen streak
        var LGnumDays = 0
        var LGhighestNumDays = 0
        var LGpreviousDay:Day? = nil
        print("\nLongest Generation Streak")
        for day in allTheDays {
            
            print(day.date!)
            
            if LGpreviousDay == nil {
                
                //First day in the loop
                LGnumDays += 1
                LGpreviousDay = day
                print("Day 1")
                
            } else {
                print("Day after check")
                let LGdayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: LGpreviousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                if LGdayDifference == 1 {
                    LGnumDays += 1
                    LGpreviousDay = day
                    print("Day after")
                } else {
                    LGnumDays = 1
                    LGpreviousDay = day
                    print("Failed: reset")
                }
                
            }
            
            if LGnumDays > LGhighestNumDays {
                LGhighestNumDays = LGnumDays
            }
            
        }
        
        return LGhighestNumDays
    }
    
    func curr100Streak() -> Int {
        //Reverse array
        var allDays = allTheDays
        allDays.reverse()
        
        //loop to find current 100 streak
        var C1numDays = 0
        var C1previousDay:Day? = nil
        print("\nCurrent 100% Streak")
        for day in allDays {
            
            print(day.date!)
            
            if C1previousDay == nil {
                
                //First day in the loop
                print("Day 1 check")
                let C1dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: Date()), to: Calendar.current.startOfDay(for: day.date!)).day
                if C1dayDifference == -1 && day.ratio == 1 {
                    C1numDays += 1
                    C1previousDay = day
                    print("Day 1")
                }
                
            } else {
                print("Day after check")
                let C1dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: C1previousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                if C1dayDifference == -1 && day.ratio == 1 {
                    C1numDays += 1
                    C1previousDay = day
                    print("Day after")
                }
                
            }
            
        }
        
        return C1numDays
    }
    
    func long100Streak() -> Int {
        //loop to find current gen streak
        var L1numDays = 0
        var L1highestNumDays = 0
        var L1previousDay:Day? = nil
        print("\nLongest 100% Streak")
        for day in allTheDays {
            
            print(day.date!)
            
            if L1previousDay == nil {
                
                //First day in the loop
                print("Day 1 check")
                if day.ratio == 1 {
                    L1numDays += 1
                    L1previousDay = day
                    print("Day 1")
                }
                
            } else {
                print("Day after check")
                let L1dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: L1previousDay!.date!), to: Calendar.current.startOfDay(for: day.date!)).day
                if day.ratio == 1 {
                    if L1dayDifference == 1 {
                        L1numDays += 1
                        L1previousDay = day
                        print("Day after")
                    } else {
                        L1numDays = 1
                        L1previousDay = day
                        print("Failed: reset")
                    }
                }
                
            }
            
            if L1numDays > L1highestNumDays {
                L1highestNumDays = L1numDays
            }
            
        }
        
        return L1highestNumDays
    }
    
    func totPercentComplete() -> Int {
        var totalRatio:Double = 0.0
        
        for day in allTheDays {
            totalRatio += day.ratio
        }
        
        if allTheDays.count != 0 {
            totalRatio = totalRatio/Double(allTheDays.count)
        }
        
        let percentage = Int(totalRatio*100)
        
        return percentage
    }
    
    func totDays() -> Int {
        let firstDate = UD.firstLaunch
        let dayDifference = Calendar.current.dateComponents([.day], from: Calendar.current.startOfDay(for: firstDate()), to: Calendar.current.startOfDay(for: Date())).day
        return dayDifference!
    }
    
    func totDaysGen() -> Int {
        return allTheDays.count
    }
}
