import SwiftUI
import PuttingGameCore

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager

    var body: some View {
        Form {
            Picker("Theme", selection: $themeManager.selectedTheme) {
                ForEach(ThemeKind.allCases) { kind in
                    Text(kind.rawValue).tag(kind)
                }
            }
            Toggle("Low Effects Mode", isOn: $themeManager.lowEffectsEnabled)
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView().environmentObject(ThemeManager())
}
