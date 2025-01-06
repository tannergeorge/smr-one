//
//  KnightifyApp.swift
//  Knightify
//
//  Created by Tanner George on 5/13/23.
//

import EventKit
import EventKitUI
import SwiftUI

var eventStore = EKEventStore()

@main
struct KnightifyApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}

