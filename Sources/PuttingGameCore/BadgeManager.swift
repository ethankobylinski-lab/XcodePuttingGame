import Foundation

public struct BadgeManager {
    public init() {}

    public func earnedBadges(forSession session: Session, profile: Profile) -> [BadgeID] {
        var earned: [BadgeID] = []
        let makes = session.shots.filter { $0.result }

        // Consistency
        if !makes.isEmpty { earned.append(.firstMake) }
        if makes.count >= 10 { earned.append(.tenMakes) }
        if session.shots.count >= 10 && makes.count == session.shots.count { earned.append(.noMiss) }
        if makes.count >= 25 { earned.append(.sessionMaster) }

        // Distance Mastery
        let makesByDistance = Dictionary(grouping: makes, by: { $0.distanceFt })
        if let shortMakes = makesByDistance[3], shortMakes.count >= 10 { earned.append(.iceCold) }
        if let midMakes = makesByDistance[5], midMakes.count >= 10 { earned.append(.smoothOperator) }
        let longMakes = makes.filter { $0.distanceFt >= 8 && $0.distanceFt < 10 }
        if longMakes.count >= 5 { earned.append(.clutch) }
        let bombMakes = makes.filter { $0.distanceFt >= 10 }
        if bombMakes.count >= 3 { earned.append(.longBomb) }
        if [3,5,8].allSatisfy({ makesByDistance[$0]?.isEmpty == false }) && makes.count >= 6 { earned.append(.ladderMaster) }

        // Break Mastery
        let makesByBreak = Dictionary(grouping: makes, by: { $0.breakType })
        if let straight = makesByBreak[.straight], straight.count >= 10 { earned.append(.straightShooter) }
        if let left = makesByBreak[.left], left.count >= 10 { earned.append(.leftBreakTamer) }
        if let right = makesByBreak[.right], right.count >= 10 { earned.append(.rightBreakRuler) }
        if let left = makesByBreak[.left], let right = makesByBreak[.right], left.count >= 5 && right.count >= 5 {
            earned.append(.slopeConqueror)
        }
        if BreakType.allCases.allSatisfy({ makesByBreak[$0]?.isEmpty == false }) && makes.count >= 9 {
            earned.append(.breakArtist)
        }

        // Streaks
        if profile.streakDays >= 2 { earned.append(.streakStarter) }
        if profile.streakDays >= 3 { earned.append(.threeDayStreak) }
        if profile.streakDays >= 7 { earned.append(.weekWarrior) }

        // Quests
        let duration = session.end.timeIntervalSince(session.start)
        if session.shots.count >= 10 && duration <= 5 * 60 { earned.append(.speedDemon) }
        let hour = Calendar.current.component(.hour, from: session.start)
        if hour >= 21 { earned.append(.nightOwl) }
        if session.shots.count >= 50 { earned.append(.marathon) }

        return earned
    }
}
