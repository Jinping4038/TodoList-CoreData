//
//  ContentView.swift
//  ToDoList
//
//  Created by Jin Zhang on 9/25/25.
//

import SwiftUI
import CoreData
enum Priority: String, Identifiable, CaseIterable {
    var id: UUID {
        return UUID()
    }
    
    case low = "Low"
    case medium = "Medium"
    case high = "High"
}

extension Priority {
    var title: String {
        switch self {
        case .low:
            return "Low"
        case .high:
            return "High"
        case .medium:
            return "Medium"
        }
    }
}
struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: TaskEntity.entity(),
                  sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: false)])
    var allTasks: FetchedResults<TaskEntity>
    
    @State private var showAddTask = false
    
    private func styleForPriority(_ value: String) -> Color {
        let priority = Priority(rawValue: value)
        switch priority {
        case .low:
            return Color.green
        case .medium:
            return Color.orange
        case .high:
            return Color.red
        default:
            return Color.black
        }
    }
    
    private func deleteTask(offsets: IndexSet) {
        withAnimation {
            offsets.map { allTasks[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error deleting task: \(error.localizedDescription)")
            }
        }
    }

    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                if allTasks.isEmpty {
                    VStack {
                        Image(systemName: "list.bullet")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.gray)
                        Text("Empty list!")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Text("Click the button to add something exciting!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                } else {
                    List {
                        ForEach(allTasks) { task in
                            HStack {
                                Circle()
                                    .fill(styleForPriority(task.priority ?? ""))
                                    .frame(width: 15, height: 15)
                                Text(task.title ?? "")
                            }
                        }
                        .onDelete(perform: deleteTask) 
                    }
                }
                
                Button(action: { showAddTask = true }) {
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }
                .padding()
                .sheet(isPresented: $showAddTask) {
                    AddTaskView()
                        .environment(\.managedObjectContext, viewContext)
                }
            }
            .navigationTitle("All Tasks")
        }
    }
}

#Preview {
    ContentView()
        .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
            
}
