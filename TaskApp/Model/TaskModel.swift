//
//  TaskModel.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import Foundation

struct Task {
    let id: UUID
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createEmptyTask() -> Task {
        return Task(id: UUID(), name: "", description: "", isCompleted: false, finishDate: Date())
    }
}
