//
//  PuttingGameV1App.swift
//  PuttingGameV1
//
//  Created by Ethan Kobylinski on 7/6/25.
//

import SwiftUI
import PuttingGameCore

@main
struct PuttingGameV1App: App {
    @StateObject private var themeManager = ThemeManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(themeManager)
        }
    }
}
