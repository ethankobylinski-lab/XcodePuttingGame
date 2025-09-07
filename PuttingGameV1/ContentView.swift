//
//  ContentView.swift
//  PuttingGameV1
//
//  Created by Ethan Kobylinski on 7/6/25.
//

import SwiftUI
import PuttingGameCore

struct ContentView: View {
    @ObservedObject var sessionStore: SessionStore
    @State private var remaining: Int = 0
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if sessionStore.activeSession != nil {
                Text("Time remaining: \(remaining)")
                    .accessibilityIdentifier("countdownLabel")
            } else {
                Button("Start Challenge") {
                    startChallenge()
                }
                .accessibilityIdentifier("startButton")
            }
        }
        .padding()
        .onAppear {
            updateRemaining()
        }
        .onReceive(timer) { _ in
            updateRemaining()
        }
    }

    private func startChallenge() {
        sessionStore.activeSession = Session(start: .now, end: Date().addingTimeInterval(10))
        updateRemaining()
    }

    private func updateRemaining() {
        guard let session = sessionStore.activeSession else {
            remaining = 0
            return
        }
        remaining = max(0, Int(session.end.timeIntervalSinceNow.rounded()))
        if remaining <= 0 {
            sessionStore.activeSession = nil
        } else {
            sessionStore.save()
        }
    }
}

#Preview {
    ContentView(sessionStore: SessionStore())
}
