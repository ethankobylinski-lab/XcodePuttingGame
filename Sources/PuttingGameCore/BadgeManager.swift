import Foundation

public struct BadgeManager {
    public init() {}

    public func earnedBadges(forSession session: Session) -> [BadgeID] {
        var earned: [BadgeID] = []
        let makesByDistance = Dictionary(grouping: session.shots.filter { $0.result }, by: { $0.distanceFt })
        if let shortMakes = makesByDistance[3], shortMakes.count >= 10 {
            earned.append(.iceCold)
        }
        if let longMakes = makesByDistance[8], longMakes.count >= 5 {
            earned.append(.clutch)
        }
        let ladderCounts = session.shots.filter { $0.result }.count
        if ladderCounts >= 6 {
            earned.append(.ladderMaster)
        }
        return earned
    }
}
