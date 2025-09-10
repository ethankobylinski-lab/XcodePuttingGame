import Foundation

public enum Insight: Equatable {
    case none
    case ladder(distance: Int)
}

public struct InsightEngine {
    public init() {}

    public func insight(for session: Session) -> Insight {
        // group shots by distance
        let grouped = Dictionary(grouping: session.shots, by: { $0.distanceFt })
        // compute attempts and accuracy for each distance
        var stats: [(distance: Int, attempts: Int, accuracy: Double)] = []
        for (distance, shots) in grouped {
            let attempts = shots.count
            guard attempts >= 20 else { continue }
            let makes = shots.filter { $0.result }.count
            let accuracy = attempts > 0 ? Double(makes) / Double(attempts) : 0
            stats.append((distance, attempts, accuracy))
        }
        guard !stats.isEmpty else { return .none }
        // sort stats by accuracy (lowest first) with distance as tiebreaker
        let sortedStats = stats.sorted { lhs, rhs in
            if lhs.accuracy == rhs.accuracy {
                return lhs.distance < rhs.distance
            }
            return lhs.accuracy < rhs.accuracy
        }
        // determine 25th percentile accuracy
        let accuracies = sortedStats.map { $0.accuracy }
        let idx = Int(Double(accuracies.count - 1) * 0.25)
        let threshold = accuracies[idx]
        // pick the first distance within the bottom quartile
        if let target = sortedStats.first(where: { $0.accuracy <= threshold }) {
            return .ladder(distance: target.distance)
        }
        return .none
    }
}

