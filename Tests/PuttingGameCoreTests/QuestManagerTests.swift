import Foundation
import Testing
@testable import PuttingGameCore

@MainActor
struct QuestManagerTests {
    @Test func generatesQuests() throws {
        let defaults = UserDefaults(suiteName: "QuestManagerTests")!
        defaults.removePersistentDomain(forName: "QuestManagerTests")
        let manager = QuestManager(userDefaults: defaults)
        let daily = manager.quests.filter { $0.frequency == .daily }
        let weekly = manager.quests.filter { $0.frequency == .weekly }
        #expect(daily.count == 3)
        #expect(weekly.count == 1)
    }

    @Test func refreshReplacesExpired() throws {
        let defaults = UserDefaults(suiteName: "QuestManagerTests2")!
        defaults.removePersistentDomain(forName: "QuestManagerTests2")
        let manager = QuestManager(userDefaults: defaults)
        let previousDailyIDs = Set(manager.quests.filter { $0.frequency == .daily }.map { $0.id })
        let weeklyID = manager.quests.first { $0.frequency == .weekly }!.id
        let future = manager.quests.filter { $0.frequency == .daily }.first!.end.addingTimeInterval(1)
        manager.refreshQuests(now: future)
        let newDailyIDs = Set(manager.quests.filter { $0.frequency == .daily }.map { $0.id })
        #expect(newDailyIDs.count == 3)
        #expect(newDailyIDs.intersection(previousDailyIDs).isEmpty)
        #expect(manager.quests.first { $0.frequency == .weekly }!.id == weeklyID)
    }

    @Test func progressOnlyMatchingQuest() throws {
        let defaults = UserDefaults(suiteName: "QuestManagerTests3")!
        defaults.removePersistentDomain(forName: "QuestManagerTests3")
        let manager = QuestManager(userDefaults: defaults)
        let now = Date()
        let end = now.addingTimeInterval(60)
        let q1 = Quest(frequency: .daily, title: "3ft", start: now, end: end, goal: 1, reward: 10, requiredDistance: 3)
        let q2 = Quest(frequency: .daily, title: "5ft", start: now, end: end, goal: 1, reward: 10, requiredDistance: 5)
        manager.replaceQuests([q1, q2])
        let shot = Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true)
        manager.record(shot: shot)
        #expect(manager.quests.first { $0.id == q1.id }!.progress == 1)
        #expect(manager.quests.first { $0.id == q2.id }!.progress == 0)
    }

    @Test func concurrentRecordsAreSerialized() async throws {
        let defaults = UserDefaults(suiteName: "QuestManagerTests4")!
        defaults.removePersistentDomain(forName: "QuestManagerTests4")
        let manager = QuestManager(userDefaults: defaults)
        let now = Date()
        let end = now.addingTimeInterval(60)
        let quest = Quest(frequency: .daily, title: "3ft", start: now, end: end, goal: 100, reward: 10, requiredDistance: 3)
        manager.replaceQuests([quest])
        let shot = Shot(distanceFt: 3, breakType: .straight, greenSpeed: .medium, result: true)
        let task = Task.detached {
            await withTaskGroup(of: Void.self) { group in
                for _ in 0..<100 {
                    group.addTask { await manager.record(shot: shot) }
                }
            }
        }
        await task.value
        #expect(manager.quests.first?.progress == 100)
    }
}
