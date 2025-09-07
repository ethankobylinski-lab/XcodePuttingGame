import Foundation

/// Simple analytics logger used to record lightweight events.
/// In a real application this would send data to an analytics backend.
@MainActor
public final class AnalyticsLogger {
    public static let shared = AnalyticsLogger()
    private init() {}

    /// Logs an analytics event to the console.
    /// - Parameter event: Name of the event to log.
    public func log(event: String) {
        let timestamp = ISO8601DateFormatter().string(from: Date())
        print("[Analytics] \(timestamp): \(event)")
    }
}
