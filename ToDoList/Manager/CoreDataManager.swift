//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Jin Zhang on 9/25/25.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    private init() {
        persistentContainer = NSPersistentContainer(name: "TodoModel")
        persistentContainer.loadPersistentStores{desc, error in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
            
        }
    }
    
    
    
    
}
