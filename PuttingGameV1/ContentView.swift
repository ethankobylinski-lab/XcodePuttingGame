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

    var body: some View {
        NavigationStack {
            VStack {
                Text("Hello, world!")
                    .foregroundColor(themeManager.theme.colors.text)
                    .padding(themeManager.theme.radii.medium)
                    .background(themeManager.theme.colors.foreground)
                    .cornerRadius(themeManager.theme.radii.small)
                    .shadow(color: themeManager.theme.shadows.standard.color,
                            radius: themeManager.theme.shadows.standard.radius,
                            x: themeManager.theme.shadows.standard.x,
                            y: themeManager.theme.shadows.standard.y)

                NavigationLink("Settings") {
                    SettingsView()
                }
                .padding(.top)
            }
            .padding()
            .background(themeManager.theme.gradients.background)
        }
    }
}

#Preview {
    ContentView().environmentObject(ThemeManager())
}
