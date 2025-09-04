import Foundation

public struct XPManager {
    public func xpForShot(_ shot: Shot) -> Int {
        // simple distance scaled: distance * 10 for make, 0 otherwise
        guard shot.result else { return 0 }
        return shot.distanceFt * 10
    }

    public func totalXP(forSession session: Session) -> Int {
        session.shots.reduce(0) { $0 + xpForShot($1) }
    }
}
