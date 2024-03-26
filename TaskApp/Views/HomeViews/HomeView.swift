//
//  HomeView.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var taskViewModel: TaskViewModel = TaskViewModelFactory.createTaskViewModel()
    @State private var pickerFilters: [String] = ["Active", "Completed"]
    @State private var defaultPickerSelectionItem: String = "Active"
    @State private var shouldOpenAddTaskView: Bool = false
    @State private var shouldOpenTaskDetailView: Bool = false
    @State private var selectedTask: Task = Task.createEmptyTask()
    @State private var refreshTaskList: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            Picker("Picker Filter", selection: $defaultPickerSelectionItem) {
                ForEach(pickerFilters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
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
            }.onChange(of: refreshTaskList, perform: { _ in
                taskViewModel.getTasks(isCompleted: defaultPickerSelectionItem == "Active")
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
                    AddTaskView(taskViewModel: taskViewModel, shouldOpenAddTaskView: $shouldOpenAddTaskView, refreshTaskList: $refreshTaskList)
                }
                .sheet(isPresented: $shouldOpenTaskDetailView) {
                    DetailTaskView(taskViewModel: taskViewModel, shouldOpenDetailTaskView: $shouldOpenTaskDetailView, selectedTask: $selectedTask, refreshTaskList: $refreshTaskList)
                }
        }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
