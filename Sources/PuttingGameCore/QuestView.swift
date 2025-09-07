#if canImport(SwiftUI)
import SwiftUI

public struct QuestView: View {
    @ObservedObject var manager: QuestManager
    @State private var now: Date = .now
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    public init(manager: QuestManager) {
        self.manager = manager
    }

    public var body: some View {
        List {
            ForEach(manager.quests) { quest in
                VStack(alignment: .leading) {
                    Text(quest.title)
                    Text("Progress: \(quest.progress)/\(quest.goal)")
                        .font(.subheadline)
                    Text(timeRemaining(for: quest))
                        .font(.caption)
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
