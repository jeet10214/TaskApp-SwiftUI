//
//  AddTaskView.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 24/03/24.
//

import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task(id: 0, name: "", description: "", isCompleted: false, finishDate: Date())
    @Binding var shouldOpenAddTaskView: Bool
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Detail")) {
                    TextField("Task name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                
                Section("Task date/time") {
                    DatePicker("Task Date", selection: $taskToAdd.finishDate)
                }
            }.navigationTitle("Add task")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            shouldOpenAddTaskView = false
                        } label: {
                            Text("Cancel")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Text("Add")
                        }
                        
                    }
                }
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskViewModel: TaskViewModel(), shouldOpenAddTaskView: .constant(false))
    }
}
