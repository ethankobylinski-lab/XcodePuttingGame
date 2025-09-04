// File: Models/Models.swift
import Foundation

enum PuttResult: String, CaseIterable, Codable {
    case made = "Made"
    case missedLong = "Missed Long"
    case missedLeft = "Missed Left"
    case missedRight = "Missed Right"
    case missedShort = "Missed Short"

    // CaseIterable provides default allCases; no need to implement manually
}

extension PuttResult {
    var emoji: String {
        switch self {
        case .made:        return "✅"
        case .missedLong:  return "⬆️"
        case .missedLeft:  return "⬅️"
        case .missedRight: return "➡️"
        case .missedShort: return "⏹"
        }
    }
}

struct Putt: Identifiable, Codable {
    let id: UUID
    let date: Date
    let user: String
    let distance: Int
    let breakType: String
    let putterType: String
    let gripStyle: String
    let result: PuttResult
    let xp: Int
}

struct Challenge: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let type: String
    let makes: Int
    let attempts: Int
    let xp: Int
    let makePct: Double
    let result: String
}

enum ChallengeType: String, CaseIterable, Codable {
    case random, streak, ladder, fewestAttempts
    var description: String {
        switch self {
        case .random:           return "Random Distances"
        case .streak:           return "Streak Challenge"
        case .ladder:           return "Ladder Challenge"
        case .fewestAttempts:   return "Fewest Attempts"
        }
    }
}
