import Testing
@testable import PuttingGameCore

struct InsightEngineTests {
    @Test func ladderRecommendation() throws {
        var shots: [Shot] = []
        // 5ft distance: 20 attempts, 5 makes (25% accuracy)
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 5, breakType: .straight, greenSpeed: .medium, result: i < 5))
        }
        // 3ft distance: 20 attempts, 15 makes (75% accuracy)
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: i < 15))
        }
        // 7ft distance: 20 attempts, 10 makes (50% accuracy)
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 7, breakType: .straight, greenSpeed: .medium, result: i < 10))
        }
        let session = Session(shots: shots)
        let engine = InsightEngine()
        #expect(engine.insight(for: session) == .ladder(distance: 5))
    }

    @Test func onlyOneTipProduced() throws {
        var shots: [Shot] = []
        // distance 5ft low accuracy
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 5, breakType: .straight, greenSpeed: .medium, result: i < 5))
        }
        // distance 6ft even lower accuracy
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 6, breakType: .straight, greenSpeed: .medium, result: i < 4))
        }
        // distance 3ft high accuracy
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: i < 15))
        }
        let session = Session(shots: shots)
        let engine = InsightEngine()
        let insight = engine.insight(for: session)
        switch insight {
        case .ladder(let d):
            #expect([5,6].contains(d))
        case .none:
            Issue.record("Expected a ladder insight")
        }
    }

    // Ensure that insertion order of shots does not affect the insight recommendation
    @Test func ladderRecommendationOrderIndependence() throws {
        var shots: [Shot] = []
        // append in mixed order to mimic random session logs
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 7, breakType: .straight, greenSpeed: .medium, result: i < 10))
        }
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: i < 15))
        }
        for i in 0..<20 {
            shots.append(Shot(distanceFt: 5, breakType: .straight, greenSpeed: .medium, result: i < 5))
        }
        let session = Session(shots: shots)
        let engine = InsightEngine()
        #expect(engine.insight(for: session) == .ladder(distance: 5))
    }
}
