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

    @Test func xpForShotScalingAndMisses() throws {
        let manager = XPManager()

        // misses always grant zero XP
        let miss = Shot(distanceFt: 15, breakType: .straight, greenSpeed: .medium, result: false)
        #expect(manager.xpForShot(miss) == 0)

        // linear scaling with distance for made putts
        let ten = Shot(distanceFt: 10, breakType: .straight, greenSpeed: .medium, result: true)
        let twenty = Shot(distanceFt: 20, breakType: .straight, greenSpeed: .medium, result: true)
        #expect(manager.xpForShot(ten) == 100)
        #expect(manager.xpForShot(twenty) == 200)
        #expect(manager.xpForShot(twenty) == 2 * manager.xpForShot(ten))

        // boundary: zero distance
        let zero = Shot(distanceFt: 0, breakType: .straight, greenSpeed: .medium, result: true)
        #expect(manager.xpForShot(zero) == 0)

        // boundary: unusually large distance
        let huge = Shot(distanceFt: 1000, breakType: .straight, greenSpeed: .medium, result: true)
        #expect(manager.xpForShot(huge) == 10000)
    }

    @Test func totalXPBoundaryCases() throws {
        let shots = [
            Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true),   // 30
            Shot(distanceFt: 0, breakType: .left, greenSpeed: .slow, result: true),         // 0
            Shot(distanceFt: 20, breakType: .right, greenSpeed: .fast, result: false),      // 0
            Shot(distanceFt: 1000, breakType: .straight, greenSpeed: .medium, result: true) // 10000
        ]
        let session = Session(shots: shots)
        #expect(XPManager().totalXP(forSession: session) == 10030)
    }

    @Test func badgesEarned() throws {
        var shots: [Shot] = []
        for _ in 0..<10 { shots.append(Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true)) }
        let session = Session(shots: shots)
        let badges = BadgeManager().earnedBadges(forSession: session)
        #expect(badges.contains(.iceCold))
    }
}
