import Foundation
#if canImport(Combine)
import Combine
#endif

public struct Quest: Codable, Identifiable, Equatable {
    public enum Frequency: String, Codable { case daily, weekly }
    public var id: String
    public var frequency: Frequency
    public var title: String
    public var start: Date
    public var end: Date
    public var progress: Int
    public var goal: Int
    public var reward: Int
    public var claimed: Bool
    public var requiredDistance: Int?
    public var requiredBreak: BreakType?

    public init(id: String = UUID().uuidString,
                frequency: Frequency,
                title: String,
                start: Date,
                end: Date,
                progress: Int = 0,
                goal: Int,
                reward: Int,
                claimed: Bool = false,
                requiredDistance: Int? = nil,
                requiredBreak: BreakType? = nil) {
        self.id = id
        self.frequency = frequency
        self.title = title
        self.start = start
        self.end = end
        self.progress = progress
        self.goal = goal
        self.reward = reward
        self.claimed = claimed
        self.requiredDistance = requiredDistance
        self.requiredBreak = requiredBreak
    }

    public var isComplete: Bool { progress >= goal }
    public var timeRemaining: TimeInterval { end.timeIntervalSinceNow }

    public func matches(_ shot: Shot) -> Bool {
        if let dist = requiredDistance, shot.distanceFt != dist { return false }
        if let brk = requiredBreak, shot.breakType != brk { return false }
        return true
    }
}

// Protocol to allow conditional ObservableObject conformance
#if canImport(Combine)
public protocol QuestManagerBase: ObservableObject {}
#else
public protocol QuestManagerBase: AnyObject {}
#endif

@MainActor
public final class QuestManager: QuestManagerBase {
    private let storageKey = "QuestManager.quests"
    private let userDefaults: UserDefaults

#if canImport(Combine)
    @Published public private(set) var quests: [Quest] = []
#else
    public private(set) var quests: [Quest] = []
#endif

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        load()
        refreshQuests()
    }

    public func refreshQuests(now: Date = .now) {
        quests.removeAll { $0.end <= now }
        let dailyCount = quests.filter { $0.frequency == .daily }.count
        if dailyCount < 3 {
            for _ in dailyCount..<3 { quests.append(makeQuest(frequency: .daily, start: now)) }
        }
        if !quests.contains(where: { $0.frequency == .weekly }) {
            quests.append(makeQuest(frequency: .weekly, start: now))
        }
        save()
    }

    public func record(shot: Shot) {
        guard shot.result else { return }
        for idx in quests.indices {
            if quests[idx].matches(shot) {
                quests[idx].progress = min(quests[idx].progress + 1, quests[idx].goal)
            }
        }
        save()
    }

    public func replaceQuests(_ newQuests: [Quest]) {
        quests = newQuests
        save()
    }

    public func claimReward(for questID: String) -> Int? {
        guard let idx = quests.firstIndex(where: { $0.id == questID }) else { return nil }
        var quest = quests[idx]
        guard quest.isComplete && !quest.claimed else { return nil }
        quest.claimed = true
        quests[idx] = quest
        save()
        return quest.reward
    }

    private func makeQuest(frequency: Quest.Frequency, start: Date) -> Quest {
        let duration: TimeInterval = frequency == .daily ? 60*60*24 : 60*60*24*7
        let end = start.addingTimeInterval(duration)
        let goal = frequency == .daily ? 10 : 50
        let reward = frequency == .daily ? 100 : 1000
        let title = frequency == .daily ? "Sink \(goal) putts" : "Sink \(goal) putts this week"
        return Quest(frequency: frequency, title: title, start: start, end: end, goal: goal, reward: reward)
    }

    private func load() {
        guard let data = userDefaults.data(forKey: storageKey) else { return }
        if let saved = try? JSONDecoder().decode([Quest].self, from: data) {
            quests = saved
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(quests) {
            userDefaults.set(data, forKey: storageKey)
        }
    }
}

