//
//  HomeView.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import SwiftUI

struct HomeView: View {
    
    @ObservedObject var taskViewModel: TaskViewModel = TaskViewModel()
    
    @State private var pickerFilters: [String] = ["Active", "Closed"]
    
    @State private var defaultPickerSelectionItem: String = "Active"
    
    var body: some View {
        
        NavigationStack {
            
            Picker("Picker Filter", selection: $defaultPickerSelectionItem) {
                ForEach(pickerFilters, id: \.self) {
                    Text($0)
                }
            }.pickerStyle(.segmented)
                .onChange(of: defaultPickerSelectionItem) { newValue in
                    taskViewModel.getTasks(isActive: defaultPickerSelectionItem == "Active")
                }
            
            List(taskViewModel.tasks, id: \.id) { task in
                VStack(alignment: .leading) {
                    Text(task.name).font(.title)
                    HStack {
                        Text(task.description).font(.subheadline).lineLimit(2)
                        Spacer()
                        Text(task.finishDate.getString()).font(.subheadline)
                    }
                }
            }
            .onAppear {
                taskViewModel.getTasks(isActive: true)
            }.listStyle(.plain).navigationTitle("Home")
        }
        
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
