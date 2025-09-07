import Foundation
import Observation

/// Represents a putting practice session, tracking consecutive misses
/// for each distance and triggering tip overlays after repeated misses.
@MainActor
@Observable
public final class PracticeSession {
    /// Tip to display. When `nil` no tip is showing.
    public private(set) var activeTip: String? = nil

    /// Tracks consecutive misses keyed by distance.
    private var consecutiveMisses: [Double: Int] = [:]

    /// Tips to randomly display when the player struggles.
    private let tips = [
        "Focus on grip pressure",
        "Check your aim line",
        "Maintain a smooth tempo"
    ]

    public init() {}

    /// Records the result of a putt.
    /// - Parameters:
    ///   - distance: Distance of the putt in feet.
    ///   - made: Whether the putt was made.
    public func recordPutt(distance: Double, made: Bool) {
        if made {
            // Reset miss streak for this distance.
            consecutiveMisses[distance] = 0
        } else {
            let current = (consecutiveMisses[distance] ?? 0) + 1
            consecutiveMisses[distance] = current
            if current >= 3 {
                triggerTip()
                consecutiveMisses[distance] = 0
            }
        }
    }

    /// Dismisses the current tip overlay.
    public func dismissTip() {
        activeTip = nil
    }

    /// Triggers the tip overlay and logs analytics.
    private func triggerTip() {
        // Show a tip immediately to ensure <1s delay.
        activeTip = tips.randomElement()
        AnalyticsLogger.shared.log(event: "tip_shown")
    }
}
