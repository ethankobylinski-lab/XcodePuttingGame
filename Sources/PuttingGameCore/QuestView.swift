#if canImport(SwiftUI)
import SwiftUI

public struct QuestView: View {
    @ObservedObject var manager: QuestManager
    @State private var now: Date = .now
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let onReward: (Int) -> Void

    public init(manager: QuestManager, onReward: @escaping (Int) -> Void = { _ in }) {
        self.manager = manager
        self.onReward = onReward
    }

    public var body: some View {
        List {
            ForEach(manager.quests) { quest in
                VStack(alignment: .leading, spacing: 4) {
                    Text(quest.title)
                    Text("Progress: \(quest.progress)/\(quest.goal)")
                        .font(.subheadline)
                    Text(timeRemaining(for: quest))
                        .font(.caption)
                    if quest.isComplete {
                        if quest.claimed {
                            Text("Reward claimed")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        } else {
                            Button("Claim \(quest.reward) XP") {
                                if let reward = manager.claimReward(for: quest.id) {
                                    onReward(reward)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .padding(.top, 4)
                        }
                    }
                }
            }
        }
        .onReceive(timer) { now = $0 }
    }

    private func timeRemaining(for quest: Quest) -> String {
        let remaining = quest.end.timeIntervalSince(now)
        if remaining <= 0 { return "Expired" }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .short
        return formatter.string(from: remaining) ?? ""
    }
}
#endif
