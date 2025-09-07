#if canImport(SwiftUI)
import SwiftUI

public final class ThemeManager: ObservableObject {
    @Published public var selectedTheme: ThemeKind
    @Published public var lowEffectsEnabled: Bool

    public init(selectedTheme: ThemeKind = .classic, lowEffectsEnabled: Bool = false) {
        self.selectedTheme = selectedTheme
        self.lowEffectsEnabled = lowEffectsEnabled
    }

    public var theme: Theme {
        selectedTheme.theme
    }

    public func adjustedBirthRate(_ base: CGFloat) -> CGFloat {
        lowEffectsEnabled ? base * 0.5 : base
    }
}
#endif
