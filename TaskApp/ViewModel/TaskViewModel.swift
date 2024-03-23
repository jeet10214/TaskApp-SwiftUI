//
//  TaskViewModel.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import Foundation

final class TaskViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    
    func getTasks(isActive: Bool) {
        tasks = Task.createMockTests().filter({$0.isActive == isActive})
    }
}
