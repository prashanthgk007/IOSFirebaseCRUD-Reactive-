//
//  IOSProjectTestingApp.swift
//  IOSProjectTesting
//
//  Created by prashanth on 18/08/25.
//

import SwiftUI
import SwiftData
import FirebaseCore

@main
struct IOSProjectTestingApp: App {
    
    init() {
        FirebaseApp.configure();
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            LoginScreen()
        }
        .modelContainer(sharedModelContainer)
    }
}
