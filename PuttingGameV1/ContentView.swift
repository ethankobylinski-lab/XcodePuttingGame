//
//  ContentView.swift
//  PuttingGameV1
//
//  Created by Ethan Kobylinski on 7/6/25.
//

import SwiftUI
import PuttingGameCore

struct ContentView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @StateObject private var questManager = QuestManager()
    @State private var session = Session()
    @State private var profile = Profile()
    private let xpManager = XPManager()
    private let levelManager = LevelManager()

    @State private var distance: Int = 3
    @State private var breakType: BreakType = .straight
    @State private var speed: GreenSpeed = .medium
    @State private var made: Bool = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Profile") {
                    Text("Level: \(profile.level)")
                    Text("XP: \(profile.xp)")
                }

                Section("Record Shot") {
                    Stepper("Distance: \(distance) ft", value: $distance, in: 1...20)
                    Picker("Break", selection: $breakType) {
                        ForEach(BreakType.allCases, id: \.self) { kind in
                            Text(kind.rawValue.capitalized).tag(kind)
                        }
                    }
                    Picker("Green Speed", selection: $speed) {
                        ForEach(GreenSpeed.allCases, id: \.self) { kind in
                            Text(kind.rawValue.capitalized).tag(kind)
                        }
                    }
                    Toggle("Made it", isOn: $made)
                    Button("Add Shot", action: addShot)
                }

                if !session.shots.isEmpty {
                    Section("Shots") {
                        ForEach(Array(session.shots.enumerated()), id: \.offset) { _, shot in
                            HStack {
                                Text("\(shot.distanceFt)ft")
                                Spacer()
                                Text(shot.result ? "✔︎" : "✘")
                            }
                        }
                    }
                }

                Section {
                    NavigationLink("Quests") {
                        QuestView(manager: questManager) { reward in
                            profile.xp += reward
                            profile.level = levelManager.level(forXP: profile.xp)
                        }
                    }
                    NavigationLink("Settings") {
                        SettingsView()
                    }
                }
            }
            .navigationTitle("Putting Game")
            .background(themeManager.theme.gradients.background)
        }
    }

    private func addShot() {
        let shot = Shot(distanceFt: distance, breakType: breakType, greenSpeed: speed, result: made)
        session.shots.append(shot)
        let gain = xpManager.xpForShot(shot)
        profile.xp += gain
        profile.level = levelManager.level(forXP: profile.xp)
        if made {
            questManager.record(shot: shot)
        }
        made = false
    }
}

#Preview {
    ContentView().environmentObject(ThemeManager())
}
