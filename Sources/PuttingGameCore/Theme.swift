#if canImport(SwiftUI)
import SwiftUI

public struct Theme: Equatable {
    public struct Colors {
        public let background: Color
        public let foreground: Color
        public let accent: Color
        public let text: Color
    }
    public struct Radii {
        public let small: CGFloat
        public let medium: CGFloat
        public let large: CGFloat
    }
    public struct Shadow {
        public let color: Color
        public let radius: CGFloat
        public let x: CGFloat
        public let y: CGFloat
    }
    public struct Shadows {
        public let standard: Shadow
    }
    public struct Gradients {
        public let background: LinearGradient
    }

    public let colors: Colors
    public let radii: Radii
    public let shadows: Shadows
    public let gradients: Gradients
}

public enum ThemeKind: String, CaseIterable, Identifiable {
    case classic = "Classic"
    case midnight = "Midnight"

    public var id: String { rawValue }
}

public extension Theme {
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
