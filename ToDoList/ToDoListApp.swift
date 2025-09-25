//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Jin Zhang on 9/25/25.
//

import SwiftUI

@main
struct ToDoListApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
