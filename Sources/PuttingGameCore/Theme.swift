#if canImport(SwiftUI)
import SwiftUI

/// A collection of styling information used throughout the application.
///
/// The type previously attempted to conform to `Equatable`, but `LinearGradient`
/// from SwiftUI does not offer `Equatable` conformance. Since equality checks
/// for complete themes are not required anywhere in the package, the explicit
/// conformance has been removed.
public struct Theme {
    /// Colors used by the theme.
    public struct Colors {
        public let background: Color
        public let foreground: Color
        public let accent: Color
        public let text: Color
    }

    /// Standard corner radii used throughout the UI.
    public struct Radii {
        public let small: CGFloat
        public let medium: CGFloat
        public let large: CGFloat
    }

    /// Information for a single shadow instance.
    public struct Shadow {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
    }

    /// Collection of shadows used by the theme.
    public struct Shadows {
        public let standard: Shadow
    }

    /// Linear gradients used by the theme. `LinearGradient` does not conform to
    /// `Sendable`, so we adopt unchecked sendable conformance below.
    public struct Gradients {
        public let background: LinearGradient
    }

    public let colors: Colors
    public let radii: Radii
    public let shadows: Shadows
    public let gradients: Gradients
}

// MARK: - Concurrency

// SwiftUI types such as `Color` and `LinearGradient` do not currently conform to
// `Sendable`. The theme model is immutable and only contains value types, so we
// can safely mark it and its nested types as unchecked `Sendable` to satisfy
// Swift 6's stricter concurrency checking.
extension Theme: @unchecked Sendable {}
extension Theme.Colors: @unchecked Sendable {}
extension Theme.Radii: Sendable {}
extension Theme.Shadow: @unchecked Sendable {}
extension Theme.Shadows: @unchecked Sendable {}
extension Theme.Gradients: @unchecked Sendable {}

public enum ThemeKind: String, CaseIterable, Identifiable {
    case classic = "Classic"
    case midnight = "Midnight"

    public var id: String { rawValue }
}

@MainActor public extension Theme {
    static let classic = Theme(
        colors: .init(
            background: Color(red: 0xFA/255, green: 0xF9/255, blue: 0xF6/255),
            foreground: Color(red: 0x0C/255, green: 0x3B/255, blue: 0x2E/255),
            accent: Color(red: 0xB8/255, green: 0xFF/255, blue: 0x5E/255),
            text: Color(red: 0x1F/255, green: 0x1F/255, blue: 0x1F/255)
        ),
        radii: .init(small: 4, medium: 8, large: 16),
        shadows: .init(standard: .init(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)),
        gradients: .init(background: LinearGradient(
            colors: [
                Color(red: 0x0C/255, green: 0x3B/255, blue: 0x2E/255),
                Color(red: 0xB8/255, green: 0xFF/255, blue: 0x5E/255)
            ],
            startPoint: .top,
            endPoint: .bottom
        ))
    )

    static let midnight = Theme(
        colors: .init(
            background: Color(red: 0x1F/255, green: 0x1F/255, blue: 0x1F/255),
            foreground: Color(red: 0xFA/255, green: 0xF9/255, blue: 0xF6/255),
            accent: Color(red: 0xE6/255, green: 0xC1/255, blue: 0x4E/255),
            text: Color(red: 0xFA/255, green: 0xF9/255, blue: 0xF6/255)
        ),
        radii: .init(small: 4, medium: 8, large: 16),
        shadows: .init(standard: .init(color: Color.black.opacity(0.8), radius: 4, x: 0, y: 2)),
        gradients: .init(background: LinearGradient(
            colors: [
                Color.black,
                Color(red: 0x0C/255, green: 0x3B/255, blue: 0x2E/255)
            ],
            startPoint: .top,
            endPoint: .bottom
        ))
    )
}

public extension ThemeKind {
    var theme: Theme {
        switch self {
        case .classic:
            return .classic
        case .midnight:
            return .midnight
        }
    }
}
#endif
