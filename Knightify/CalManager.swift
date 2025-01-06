//
//  CalManager.swift
//  SMR App
//
//  Created by Tanner George on 6/7/23.
//

import Foundation
import EventKit
import EventKitUI

func getAccess() async {
    await withCheckedContinuation { continuation in
        eventStore.requestAccess(to: .event) { granted, error in
            continuation.resume()
        }
    }
}

func getEvents(name : String) -> [EKEvent] {
    let startDate = Date().start
    let endDate = Date().end
    
    let predicate = eventStore.predicateForEvents(withStart: startDate,
                                                  end: endDate,
                                                  calendars: [getCalendar(name: name)])
    
    return eventStore.events(matching: predicate)
}

func getCalendar(name : String) -> EKCalendar {
    var calUID: String = "?"
    
    for cal in eventStore.calendars(for: .event) {
        if cal.title == name {
            calUID = cal.calendarIdentifier
        }
    }
    
    return eventStore.calendar(withIdentifier: calUID)!
}

func checkCalendars() -> Bool {
    var numCals = 0

    for cal in eventStore.calendars(for: .event) {
        if cal.title == "All Classes" || cal.title == "ALL ASSIGNMENTS" || cal.title == "My Calendar" {
            numCals += 1
        }
    }

    return numCals == 3
}

func checkCalsTest() async -> Bool {
    var numCals = 0
    
    return await withCheckedContinuation { continuation in
        for cal in eventStore.calendars(for: .event) {
            if cal.title == "All Classes" || cal.title == "ALL ASSIGNMENTS" || cal.title == "My Calendar" {
                numCals += 1
            }
            continuation.resume(returning: numCals == 3)
        }
    }
}

func checkCalFor(name: String) -> Bool {
    var hasCal = false
    for cal in eventStore.calendars(for: .event) {
        if cal.title == name {
            hasCal = true
        }
    }
    
    return hasCal
}

extension Date {
    var start: Date {
        return Calendar.current.startOfDay(for: Date())
    }
    
    var end : Date {
        let temp = Calendar.current.date(byAdding: .day, value: 1, to: self)!
        return Calendar.current.startOfDay(for: temp)
    }
}
