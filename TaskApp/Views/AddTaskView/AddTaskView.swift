//
//  AddTaskView.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 24/03/24.
//

import SwiftUI

struct AddTaskView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel
    @State private var taskToAdd: Task = Task.createEmptyTask()
    @Binding var shouldOpenAddTaskView: Bool
    @Binding var refreshTaskList: Bool
    @State private var showDirtyCheckAlert: Bool = false
    
    var pickerDateRange: ClosedRange<Date> {
        let calendar = Calendar.current
        let currentDateComponent = calendar.dateComponents([.day, .month, .year, .hour, .minute], from: Date())
        
        let startingDateComponent = DateComponents(year: currentDateComponent.year, month: currentDateComponent.month, day: currentDateComponent.day, hour: currentDateComponent.hour, minute: currentDateComponent.minute)
        
        let endingDateComponent = DateComponents(year: 2024, month: 12, day: 31)
        
        return calendar.date(from: startingDateComponent)! ... calendar.date(from: endingDateComponent)!
        
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Task Detail")) {
                    TextField("Task name", text: $taskToAdd.name)
                    TextEditor(text: $taskToAdd.description)
                }
                
                Section("Task date/time") {
                    DatePicker("Task Date", selection: $taskToAdd.finishDate, in: pickerDateRange)
                }
            }.navigationTitle("Add task")
                .alert("Task Error", isPresented: $taskViewModel.showError, actions: {
                    Button(action: {}) {
                        Text("Okay")
                    }

                }, message: {
                    Text(taskViewModel.errorMessage)
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            if !taskToAdd.name.isEmpty {
                                showDirtyCheckAlert.toggle()
                            } else {
                                shouldOpenAddTaskView.toggle()
                            }
                            
                        } label: {
                            Text("Cancel")
                        }.alert("Save Task", isPresented: $showDirtyCheckAlert) {
                            Button {
                                shouldOpenAddTaskView.toggle()
                            } label: {
                                Text("Cancel")
                            }
                            
                            Button {
                                addTask()
                            } label: {
                                Text("Save")
                            }
                        } message: {
                            Text("Would you like to save the task?")
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            addTask()
                        } label: {
                            Text("Add")
                        }.disabled(taskToAdd.name.isEmpty)
                        
                    }
                }
        }
    }
    
    private func addTask() {
        if taskViewModel.addTask(task: taskToAdd) {
            shouldOpenAddTaskView.toggle()
            refreshTaskList.toggle()
        }
    }
}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView(taskViewModel: TaskViewModelFactory.createTaskViewModel(), shouldOpenAddTaskView: .constant(false), refreshTaskList: .constant(false))
    }
}
