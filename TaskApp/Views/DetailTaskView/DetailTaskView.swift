//
//  DetailTaskView.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 24/03/24.
//

import SwiftUI

struct DetailTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @Binding var shouldOpenDetailTaskView: Bool
    @Binding var selectedTask: Task
    @State private var showDeleteAlert: Bool = false
    
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Detail")) {
                    TextField("Task name", text: $selectedTask.name)
                    TextEditor(text: $selectedTask.description)
                    Toggle("Mark Complete", isOn: $selectedTask.isCompleted)
                }
                
                Section("Task date/time") {
                    DatePicker("Task Date", selection: $selectedTask.finishDate)
                }
                
                Section {
                    Button {
                        showDeleteAlert.toggle()
                        
                    } label: {
                        Text("Delete task")
                            .fontWeight(.bold)
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }.alert("Delete Task", isPresented: $showDeleteAlert) {
                        Button {
                            shouldOpenDetailTaskView = false
                        } label: {
                            Text("No")
                        }
                        
                        Button(role: .destructive) {
                            taskViewModel.deleteTask(task: selectedTask)
                        } label: {
                            Text("Yes")
                        }
                    } message: {
                        Text("Are you sure you want to delete the \(selectedTask.name) task?")
                    }
                }
            }
            .onReceive(taskViewModel.shouldDismiss, perform: { shouldDismiss in
                if shouldDismiss {
                    shouldOpenDetailTaskView.toggle()
                }
            })
            .navigationTitle("Task Detail")
                .alert("Task Error", isPresented: $taskViewModel.showError, actions: {
                    Button(action: {}) {
                        Text("Okay")
                    }

                }, message: {
                    Text(taskViewModel.errorMessage)
                })
                .onDisappear(perform: {
                    taskViewModel.cancelSubscribtion()
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            shouldOpenDetailTaskView = false
                        } label: {
                            Text("Cancel")
                        }
                        
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            taskViewModel.updateTask(task: selectedTask)
                        } label: {
                            Text("Update")
                        }.disabled(selectedTask.name.isEmpty)
                        
                    }
                }
        }
    }
}

struct DetailTaskView_Previews: PreviewProvider {
    static var previews: some View {
        DetailTaskView(taskViewModel: TaskViewModelFactory.createTaskViewModel(), shouldOpenDetailTaskView: .constant(false), selectedTask: .constant(Task.createEmptyTask()))
    }
}
