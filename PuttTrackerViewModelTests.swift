// File: PuttingGameV1Tests/PuttTrackerViewModelTests.swift
import XCTest
@testable import PuttingGameV1

class PuttTrackerViewModelTests: XCTestCase {
    var vm: PuttTrackerViewModel!
    var now: Date!

    override func setUp() {
        super.setUp()
        vm = PuttTrackerViewModel()
        now = Date()
        vm.challengeHistory = []
    }

    func testFilteredChallengeHistory_All() {
        let entries = makeChallenges(daysAgo: [0, 5, 10, 31])
        vm.challengeHistory = entries
        let result = vm.filteredChallengeHistory(range: .all)
        XCTAssertEqual(result.count, entries.count)
    }

    func testFilteredChallengeHistory_Last7Days() {
        let entries = makeChallenges(daysAgo: [0, 3, 6, 7, 8])
        vm.challengeHistory = entries
        let result = vm.filteredChallengeHistory(range: .last7Days)
        XCTAssertTrue(result.allSatisfy {
            Calendar.current.dateComponents([.day], from: $0.date, to: now).day! <= 6
        })
        XCTAssertFalse(result.contains {
            Calendar.current.dateComponents([.day], from: $0.date, to: now).day! == 7
        })
    }

    func testChallengeSuccessRateByDate() {
        let date1 = now
        let c1 = Challenge(date: date1, type: "Passed", makes: 1, attempts: 2, xp: 50, makePct: 50, result: "Passed")
        let c2 = Challenge(date: date1, type: "Passed", makes: 2, attempts: 2, xp: 50, makePct: 100, result: "Passed")
        vm.challengeHistory = [c1, c2]
        let data = vm.challengeSuccessRateByDate(range: .all)
        XCTAssertEqual(data.count, 1)
        XCTAssertEqual(data.first?.pct, 75)
    }

    func testChallengeWinLossCounts() {
        let c1 = Challenge(date: now, type: "Passed", makes: 3, attempts: 4, xp: 50, makePct: 75, result: "Passed")
        let c2 = Challenge(date: now, type: "Failed", makes: 1, attempts: 3, xp: 0, makePct: 33.3, result: "Failed")
        vm.challengeHistory = [c1, c2, c1]
        let counts = vm.challengeWinLossCounts(range: .all)
        let dict = Dictionary(uniqueKeysWithValues: counts.map { ($0.result, $0.count) })
        XCTAssertEqual(dict["Passed"], 2)
        XCTAssertEqual(dict["Failed"], 1)
    }

    // Helper
    private func makeChallenges(daysAgo: [Int]) -> [Challenge] {
        daysAgo.map { offset in
            let date = Calendar.current.date(byAdding: .day, value: -offset, to: now)!
            return Challenge(date: date,
                             type: offset % 2 == 0 ? "Passed" : "Failed",
                             makes: 1, attempts: 2,
                             xp: offset % 2 == 0 ? 50 : 0,
                             makePct: 50,
                             result: offset % 2 == 0 ? "Passed" : "Failed")
        }
    }
}
