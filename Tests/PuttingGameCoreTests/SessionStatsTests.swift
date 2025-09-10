import Testing
@testable import PuttingGameCore

struct SessionStatsTests {
    @Test func computesBasicStats() throws {
        let shots = [
            Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true),
            Shot(distanceFt: 5, breakType: .left, greenSpeed: .medium, result: false),
            Shot(distanceFt: 8, breakType: .right, greenSpeed: .fast, result: true)
        ]
        let session = Session(shots: shots)
        let stats = session.stats
        #expect(stats.totalShots == 3)
        #expect(stats.makes == 2)
        #expect(abs(stats.makePercentage - 2.0/3.0) < 0.0001)
        #expect(abs(stats.averageMakeDistance - 5.5) < 0.0001)
    }

    @Test func emptySessionStats() throws {
        let session = Session()
        let stats = session.stats
        #expect(stats.totalShots == 0)
        #expect(stats.makes == 0)
        #expect(stats.makePercentage == 0)
        #expect(stats.averageMakeDistance == 0)
    }
}

