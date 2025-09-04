// File: PuttingXPTrackerApp.swift
import SwiftUI

@main
struct PuttingGameV1App: App {
    @StateObject private var vm = PuttTrackerViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(vm)  // <<< ensure this is present
        }
    }
}
