import Foundation

public struct LevelManager {
    public let xpTable: [Int]
    public init(xpTable: [Int] = [0, 100, 250, 450, 700, 1000]) {
        self.xpTable = xpTable
    }

    public func level(forXP xp: Int) -> Int {
        var level = 1
        for (idx, threshold) in xpTable.enumerated() where xp >= threshold {
            level = idx + 1
        }
        return level
    }

    public func xpNeeded(forLevel level: Int) -> Int {
        guard level - 1 < xpTable.count else { return xpTable.last ?? 0 }
        return xpTable[level - 1]
    }
}
