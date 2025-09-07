import Foundation
import Testing
@testable import PuttingGameCore

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
}
