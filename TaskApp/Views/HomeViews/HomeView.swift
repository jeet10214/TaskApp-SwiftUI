//
//  HomeView.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
    @State private var shouldOpenAddTaskView: Bool = false
    @State private var shouldOpenTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task.createEmptyTask()
    @State private var defaultPickerSelectionItem: String = "Active"
    
    var body: some View {
        
        NavigationStack {
            
            PickerComponent(defaultPickerSelectionItem: $defaultPickerSelectionItem)
                .onChange(of: defaultPickerSelectionItem) { newValue in
                    taskViewModel.getTasks(isCompleted: defaultPickerSelectionItem == "Active")
                }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(.title)
                    HStack {
                        Text(task.description).font(.subheadline).lineLimit(2)
                        Spacer()
                        Text(task.finishDate.getString()).font(.subheadline)
                    }
                }.onTapGesture {
                    selectedTask = task
                    shouldOpenTaskDetailView = true
                }
            }
            .onAppear {
                taskViewModel.getTasks(isCompleted: true)
            }
            .onDisappear(perform: {
                taskViewModel.cancelSubscribtion()
            })
            .alert("Task Error", isPresented: $taskViewModel.showError, actions: {
                Button(action: {}) {
                    Text("Okay")
                }

            }, message: {
                Text(taskViewModel.errorMessage)
            })
            .listStyle(.plain).navigationTitle("Home")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            shouldOpenAddTaskView = true
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }
                .sheet(isPresented: $shouldOpenAddTaskView) {
                    AddTaskView(taskViewModel: taskViewModel, shouldOpenAddTaskView: $shouldOpenAddTaskView)
                }
                .sheet(isPresented: $shouldOpenTaskDetailView) {
                    DetailTaskView(taskViewModel: taskViewModel, shouldOpenDetailTaskView: $shouldOpenTaskDetailView, selectedTask: $selectedTask)
                }
        }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
