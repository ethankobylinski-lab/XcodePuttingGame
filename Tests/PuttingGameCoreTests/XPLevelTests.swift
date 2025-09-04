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

    @Test func badgesEarned() throws {
        var shots: [Shot] = []
        for _ in 0..<10 { shots.append(Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true)) }
        let session = Session(shots: shots)
        let badges = BadgeManager().earnedBadges(forSession: session)
        #expect(badges.contains(.iceCold))
    }
}
