//
//  TaskModel.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import Foundation

struct Task {
    let id: Int
    var name: String
    var description: String
    var isCompleted: Bool
    var finishDate: Date
    
    static func createMockTests() -> [Task] {
        return [Task(id: 1, name: "Study DP", description: "Dp problem 7 - 12", isCompleted: false, finishDate: Date()),
                Task(id: 2, name: "Study Graph", description: "Dp problem 6 - 12", isCompleted: false, finishDate: Date()),
                Task(id: 3, name: "Study Linked List", description: "Start from scratch", isCompleted: false, finishDate: Date()),
                Task(id: 4, name: "Study iOS", description: "Read documents", isCompleted: false, finishDate: Date()),
                Task(id: 4, name: "Go to BAPS Mandir", description: "Take Mom to BAPS mandir in Abu Dhabi", isCompleted: true, finishDate: Date())]
    }
}
