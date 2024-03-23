//
//  TaskAppApp.swift
//  TaskApp
//
//  Created by Jeet Kapadia on 23/03/24.
//

import SwiftUI

@main
struct TaskAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
