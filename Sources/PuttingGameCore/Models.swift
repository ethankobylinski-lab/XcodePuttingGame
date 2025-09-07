import Foundation

public struct Shot: Codable, Sendable, Equatable {
    public var date: Date
    public var distanceFt: Int
    public var breakType: BreakType
    public var greenSpeed: GreenSpeed
    public var result: Bool

    public init(date: Date = .now, distanceFt: Int, breakType: BreakType, greenSpeed: GreenSpeed, result: Bool) {
        self.date = date
        self.distanceFt = distanceFt
        self.breakType = breakType
        self.greenSpeed = greenSpeed
        self.result = result
    }
}

public enum BreakType: String, Codable, Sendable, CaseIterable { case straight, left, right }
public enum GreenSpeed: String, Codable, Sendable, CaseIterable { case slow, medium, fast }

public struct Session: Codable, Sendable, Identifiable {
    public var id: UUID
    public var start: Date
    public var end: Date
    public var shots: [Shot]
    public var notes: String?

    public init(id: UUID = UUID(), start: Date = .now, end: Date = .now, shots: [Shot] = [], notes: String? = nil) {
        self.id = id
        self.start = start
        self.end = end
        self.shots = shots
        self.notes = notes
    }
}

public struct ChallengeRun: Codable, Sendable, Identifiable {
    public var id: UUID
    public var type: String
    public var params: [String: Int]
    public var resultSummary: String

    public init(id: UUID = UUID(), type: String, params: [String: Int] = [:], resultSummary: String = "") {
        self.id = id
        self.type = type
        self.params = params
        self.resultSummary = resultSummary
    }
}

public struct Profile: Codable, Sendable {
    public var level: Int
    public var xp: Int
    public var badges: Set<BadgeID>
    public var streakDays: Int
    public var bests: [Int: Int]

    public init(level: Int = 1, xp: Int = 0, badges: Set<BadgeID> = [], streakDays: Int = 0, bests: [Int: Int] = [:]) {
        self.level = level
        self.xp = xp
        self.badges = badges
        self.streakDays = streakDays
        self.bests = bests
    }
}

public enum BadgeID: String, Codable, Sendable, CaseIterable {
    // Consistency
    case firstMake, tenMakes, noMiss, sessionMaster
    // Distance Mastery
    case iceCold, smoothOperator, clutch, ladderMaster, longBomb
    // Break Mastery
    case straightShooter, leftBreakTamer, rightBreakRuler, slopeConqueror, breakArtist
    // Streaks
    case streakStarter, threeDayStreak, weekWarrior
    // Quests
    case speedDemon, nightOwl, marathon
}
