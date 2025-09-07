//
//  PuttingGameV1App.swift
//  PuttingGameV1
//
//  Created by Ethan Kobylinski on 7/6/25.
//

import SwiftUI

@main
struct PuttingGameV1App: App {
    @StateObject private var sessionStore = SessionStore()

    var body: some Scene {
        WindowGroup {
            ContentView(sessionStore: sessionStore)
        }
    }
}
