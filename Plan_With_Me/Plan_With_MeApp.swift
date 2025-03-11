//
//  Plan_With_MeApp.swift
//  Plan_With_Me
//
//  Created by Tech on 2025-02-25.
//

import SwiftUI

@main
struct Plan_With_MeApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,
                              dataController.container.viewContext)
        }
    }
}
