//
//  TaskModel.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import Foundation

struct Task {
    let id: Int
    let name: String
    let description: String
    let isActive: Bool
    let finishDate: Date
    
    static func createMockTests() -> [Task] {
        return [Task(id: 1, name: "Study DP", description: "Dp problem 7 - 12", isActive: true, finishDate: Date()),
                Task(id: 2, name: "Study Graph", description: "Dp problem 6 - 12", isActive: true, finishDate: Date()),
                Task(id: 3, name: "Study Linked List", description: "Start from scratch", isActive: true, finishDate: Date()),
                Task(id: 4, name: "Study iOS", description: "Read documents", isActive: true, finishDate: Date())]
    }
}
