// File: ViewModels/Extensions.swift
import Foundation

/// Defines date ranges for filtering history data
enum HistoryFilterRange {
    case last7Days, last30Days, all
}

extension PuttTrackerViewModel {
    /// Group putts by date and sum XP
    func puttsGroupedByDate() -> [(date: Date, xp: Int)] {
        let grouped = Dictionary(grouping: putts) { Calendar.current.startOfDay(for: $0.date) }
        return grouped.map { date, items in
            (date: date, xp: items.reduce(0) { $0 + $1.xp })
        }
        .sorted { $0.date < $1.date }
    }
    
    /// Group putts by distance and compute make percentage
    func puttsGroupedByDistance() -> [(distance: Int, pct: Double)] {
        let grouped = Dictionary(grouping: putts) { $0.distance }
        return grouped.map { distance, items in
            let makes = items.filter { $0.result == .made }.count
            return (distance: distance, pct: Double(makes) / Double(items.count) * 100)
        }
        .sorted { $0.distance < $1.distance }
    }
    
    /// Group missed putts by type
    func puttsMissedByType() -> [(result: String, count: Int)] {
        let missed = putts.filter { $0.result != .made }
        let grouped = Dictionary(grouping: missed) { $0.result.rawValue }
        return grouped.map { result, items in
            (result: result, count: items.count)
        }
    }
    
    // MARK: - Challenge History Helpers

    /// Returns challenge entries filtered by the specified date range
    func filteredChallengeHistory(range: HistoryFilterRange) -> [Challenge] {
        switch range {
        case .all:
            return challengeHistory
        case .last7Days:
            let cutoff = Calendar.current.date(byAdding: .day, value: -6, to: Date())!
            return challengeHistory.filter { $0.date >= cutoff }
        case .last30Days:
            let cutoff = Calendar.current.date(byAdding: .day, value: -29, to: Date())!
            return challengeHistory.filter { $0.date >= cutoff }
        }
    }

    /// Computes average success rate per day for the given date range
    func challengeSuccessRateByDate(range: HistoryFilterRange) -> [(date: Date, pct: Double)] {
        let filtered = filteredChallengeHistory(range: range)
        let grouped = Dictionary(grouping: filtered) { Calendar.current.startOfDay(for: $0.date) }
        return grouped.map { date, entries in
            let avg = entries.map { $0.makePct }.reduce(0, +) / Double(entries.count)
            return (date: date, pct: avg)
        }
        .sorted { $0.date < $1.date }
    }

    /// Counts wins vs losses in the given date range
    func challengeWinLossCounts(range: HistoryFilterRange) -> [(result: String, count: Int)] {
        let filtered = filteredChallengeHistory(range: range)
        let grouped = Dictionary(grouping: filtered) { $0.result }
        return grouped.map { result, entries in
            (result: result, count: entries.count)
        }
    }
}
