import Foundation

public struct SessionStats: Equatable {
    public let totalShots: Int
    public let makes: Int
    public let makePercentage: Double
    public let averageMakeDistance: Double

    public init(totalShots: Int, makes: Int, makePercentage: Double, averageMakeDistance: Double) {
        self.totalShots = totalShots
        self.makes = makes
        self.makePercentage = makePercentage
        self.averageMakeDistance = averageMakeDistance
    }
}

public extension Session {
    var stats: SessionStats {
        let total = shots.count
        let madeShots = shots.filter { $0.result }
        let makes = madeShots.count
        let makePercentage = total > 0 ? Double(makes) / Double(total) : 0
        let averageMakeDistance = makes > 0 ? Double(madeShots.reduce(0) { $0 + $1.distanceFt }) / Double(makes) : 0
        return SessionStats(totalShots: total, makes: makes, makePercentage: makePercentage, averageMakeDistance: averageMakeDistance)
    }
}

