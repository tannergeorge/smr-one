//
//  DataController.swift
//  SMR One
//
//  Created by Tanner George on 8/6/23.
//

import CoreData
import Foundation

class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "Knightify")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load")
            }
        }
    }
}
