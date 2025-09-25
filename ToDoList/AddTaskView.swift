//
//  AddTaskView.swift
//  ToDoList
//
//  Created by Jin Zhang on 9/25/25.
//

import SwiftUI
struct AddTaskView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var selectedPriority: Priority = .medium
    
    private func saveTask() {
        do {
            let task = TaskEntity(context: viewContext)
            task.title = title
            task.priority = selectedPriority.rawValue
            task.dateCreated = Date()
            
            try viewContext.save()
            dismiss() // close sheet after saving
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                TextField("Enter title", text: $title)
                    .textFieldStyle(.roundedBorder)
                
                Picker("Priority", selection: $selectedPriority){
                    ForEach(Priority.allCases){ priority in
                        Text(priority.title).tag(priority)
                    }
                }
                .pickerStyle(.segmented)
                
                Button("Save") {
                    saveTask()
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .padding()
            .navigationTitle("New Task")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
