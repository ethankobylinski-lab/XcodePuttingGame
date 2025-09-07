import Foundation
import Testing
@testable import PuttingGameCore

struct XPLevelTests {
    @Test func levelProgression() throws {
        let levelManager = LevelManager(xpTable: [0,100,300])
        #expect(levelManager.level(forXP: 0) == 1)
        #expect(levelManager.level(forXP: 100) == 2)
        #expect(levelManager.level(forXP: 250) == 2)
        #expect(levelManager.level(forXP: 400) == 3)
    }

    @Test func sessionXP() throws {
        let shots = [Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true),
                     Shot(distanceFt: 5, breakType: .left, greenSpeed: .medium, result: false),
                     Shot(distanceFt: 8, breakType: .right, greenSpeed: .fast, result: true)]
        let session = Session(shots: shots)
        let xp = XPManager().totalXP(forSession: session)
        #expect(xp == 110)
    }

    @Test func basicBadges() throws {
        var shots: [Shot] = []
        for _ in 0..<10 {
            shots.append(Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true))
        }
        let start = Calendar.current.date(from: DateComponents(year: 2023, month: 1, day: 1, hour: 12))!
        let end = start.addingTimeInterval(60)
        let session = Session(start: start, end: end, shots: shots)
        let profile = Profile()
        let badges = BadgeManager().earnedBadges(forSession: session, profile: profile)
        #expect(badges.contains(.firstMake))
        #expect(badges.contains(.tenMakes))
        #expect(badges.contains(.iceCold))
        #expect(badges.contains(.straightShooter))
        #expect(badges.contains(.speedDemon))
        #expect(!badges.contains(.nightOwl))
    }

    @Test func breakBadge() throws {
        var shots: [Shot] = []
        for _ in 0..<10 {
            shots.append(Shot(distanceFt: 5, breakType: .left, greenSpeed: .medium, result: true))
        }
        let session = Session(shots: shots)
        let profile = Profile()
        let badges = BadgeManager().earnedBadges(forSession: session, profile: profile)
        #expect(badges.contains(.leftBreakTamer))
    }

    @Test func streakBadges() throws {
        let shots = [Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true)]
        let session = Session(shots: shots)
        let profile = Profile(streakDays: 3)
        let badges = BadgeManager().earnedBadges(forSession: session, profile: profile)
        #expect(badges.contains(.streakStarter))
        #expect(badges.contains(.threeDayStreak))
        #expect(!badges.contains(.weekWarrior))
    }
}
