// File: ViewModels/PuttTrackerViewModel.swift

import Combine
import AVFoundation

// a simple Hashable key for distance + breakType
private struct DistBreakKey: Hashable {
    let distance: Int
    let breakType: String
}


/// ViewModel managing putts, stats, challenges, and tagging
class PuttTrackerViewModel: ObservableObject {
    enum Tab { case practice, stats, game, settings }
    @Published var selectedTab: Tab = .practice
    // MARK: - Core Data
    @Published private(set) var putts: [Putt] = []
    @Published private(set) var challengeHistory: [Challenge] = []
    
    // MARK: - User Session
    @Published var user: String = "Ethan K"
    @Published var distance: Int = 1
    @Published var breakType: String = "Straight"
    @Published var putterType: String = "Blade"
    @Published var gripStyle: String = "Standard"
    
    // MARK: - Stats
    @Published private(set) var xp: Int = 0
    @Published private(set) var level: Int = 1
    @Published private(set) var totalPutts: Int = 0
    @Published private(set) var sessionAvg: Double = 0
    @Published private(set) var lastPuttTime: Date? = nil
    @Published private(set) var timeSince: Double = 0
    
    /// All-time make percentage across all logged putts
    var totalAvg: Double {
        guard !putts.isEmpty else { return 0 }
        let madeCount = putts.filter { $0.result == .made }.count
        return Double(madeCount) / Double(putts.count) * 100
    }
    
    // MARK: - Challenge Mode State
    @Published var challengeActive: Bool = false
    @Published private(set) var currentChallengeDistance: Int = 0
    @Published private(set) var challengeMakes: Int = 0
    @Published private(set) var challengeAttempts: Int = 0
    @Published private(set) var challengeRemaining: Int = 0
    @Published private(set) var currentChallengeResults: [PuttResult] = []
    
    // MARK: - Tagging
    @Published var tagOptions: [String] = ["Standard","Claw","Blade","Mallet","Ball A","Ball B"]
    @Published var selectedTags: Set<String> = []
    @Published var putterOptions: [String] = ["Blade","Mallet","Other"]
    @Published var gripOptions: [String]   = ["Standard","Claw","Left-hand-low","Other"]
    @Published var ballOptions: [String]   = ["Ball A","Ball B","Ball C"]
    
    // MARK: - Persistence & Audio
    private let puttFileURL: URL
    private let challengeFileURL: URL
    private var timer: Timer?
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var challengeSequence: [Int] = []
    private var challengeTotal: Int = 0
    
    init() {
        let docs = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first!
        puttFileURL = docs.appendingPathComponent("putt_log.json")
        challengeFileURL = docs.appendingPathComponent("challenge_log.json")
        loadPutts()
        loadChallenges()
        prepareSounds()
        startTimer()
    }
    
    deinit { timer?.invalidate() }
    
    // MARK: - File I/O
    private func loadPutts() {
        guard let data = try? Data(contentsOf: puttFileURL) else { return }
        putts = (try? JSONDecoder().decode([Putt].self, from: data)) ?? []
        recalcStats()
    }
    
    private func savePutts() {
        if let data = try? JSONEncoder().encode(putts) {
            try? data.write(to: puttFileURL)
        }
    }
    
    private func loadChallenges() {
        guard let data = try? Data(contentsOf: challengeFileURL) else { return }
        challengeHistory = (try? JSONDecoder().decode([Challenge].self, from: data)) ?? []
    }
    
    private func saveChallenges() {
        if let data = try? JSONEncoder().encode(challengeHistory) {
            try? data.write(to: challengeFileURL)
        }
    }
    
    // MARK: - Audio & Timer
    private func prepareSounds() {
        ["sfx_putt","sfx_swing","sfx_achievement"].forEach { name in
            guard let url = Bundle.main.url(forResource: name, withExtension: "mp3"),
                  let player = try? AVAudioPlayer(contentsOf: url) else { return }
            player.prepareToPlay()
            audioPlayers[name] = player
        }
    }
    
    private func play(_ name: String) {
        audioPlayers[name]?.play()
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(
            withTimeInterval: 1, repeats: true
        ) { [weak self] _ in
            guard let self = self, let last = self.lastPuttTime else { return }
            self.timeSince = Date().timeIntervalSince(last)
        }
    }
    
    // MARK: - Logging a Putt
    func logPutt(result: PuttResult) {
        let xpGain = (result == .made) ? distance * 2 : 0
        let newPutt = Putt(
            id: UUID(), date: Date(), user: user,
            distance: distance, breakType: breakType,
            putterType: putterType, gripStyle: gripStyle,
            result: result, xp: xpGain
        )
        putts.append(newPutt)
        savePutts()
        recalcStats()
        play(result == .made ? "sfx_putt" : "sfx_swing")
        
        if challengeActive {
            currentChallengeResults.append(result)
            recordChallengeShot(made: result == .made)
        }
    }
    
    private func recalcStats() {
        xp = putts.reduce(0) { $0 + $1.xp }
        level = xp / 100 + 1
        totalPutts = putts.count
        let made = putts.filter { $0.result == .made }.count
        sessionAvg = totalPutts > 0 ? Double(made) / Double(totalPutts) * 100 : 0
        lastPuttTime = putts.last?.date
    }
    
    // MARK: - Challenge Logic
    func startChallenge(type: ChallengeType, total: Int, maxDistance: Int) {
        challengeActive = true
        challengeMakes = 0
        challengeAttempts = 0
        currentChallengeResults = []
        challengeTotal = total
        challengeRemaining = total
        
        switch type {
        case .random:
            challengeSequence = (0..<total).map { _ in Int.random(in: 1...maxDistance) }
        case .streak:
            let d = Int.random(in: 1...maxDistance)
            challengeSequence = Array(repeating: d, count: total)
        case .ladder:
            challengeSequence = Array(1...maxDistance).prefix(total).map { $0 }
        case .fewestAttempts:
            let d = Int.random(in: 1...maxDistance)
            challengeSequence = Array(repeating: d, count: total)
        }
        currentChallengeDistance = challengeSequence.first ?? 0
    }
    
    private func recordChallengeShot(made: Bool) {
        challengeAttempts += 1
        if made { challengeMakes += 1 }
        challengeRemaining = max(0, challengeTotal - challengeAttempts)
        
        if challengeAttempts < challengeSequence.count {
            currentChallengeDistance = challengeSequence[challengeAttempts]
        } else {
            let pct = Double(challengeMakes) / Double(challengeAttempts)
            let xpAward = pct >= 0.7 ? 50 : 0
            let passed = pct >= 0.7
            let entry = Challenge(date: Date(), type: passed ? "Passed" : "Failed",
                                  makes: challengeMakes, attempts: challengeAttempts,
                                  xp: xpAward, makePct: pct * 100,
                                  result: passed ? "Passed" : "Failed")
            challengeHistory.append(entry)
            saveChallenges()
            challengeActive = false
            ///    playSound("sfx_achievement")
        }
    }
    
    // MARK: – History Grouping Helpers
    func challengeSuccessRateByDate() -> [(date: Date, pct: Double)] {
        let grouped = Dictionary(grouping: challengeHistory) {
            Calendar.current.startOfDay(for: $0.date)
        }
        return grouped.map { date, entries in
            let avg = entries.map(\.makePct).reduce(0, +) / Double(entries.count)
            return (date: date, pct: avg)
        }
        .sorted { $0.date < $1.date }
    }

    func challengeWinLossCounts() -> [(result: String, count: Int)] {
        let grouped = Dictionary(grouping: challengeHistory) { $0.result }
        return grouped.map { (result: $0.key, count: $0.value.count) }
    }
    
    func makePctByDistanceAndBreak() -> [(distance: Int, breakType: String, pct: Double)] {
        // group by our Hashable key
        let grouped = Dictionary(grouping: putts) { putt in
            DistBreakKey(distance: putt.distance,
                         breakType: putt.breakType)
        }

        return grouped
            .map { key, items in
                // now $0.result == .made resolves correctly
                let makes = items.filter { $0.result == .made }.count

                // force Double in both branches
                let pct = items.isEmpty
                          ? 0.0
                          : Double(makes) / Double(items.count) * 100.0

                return ( distance: key.distance,
                         breakType: key.breakType,
                         pct: pct )
            }
            .sorted { lhs, rhs in
                if lhs.distance != rhs.distance {
                    return lhs.distance < rhs.distance
                }
                return lhs.breakType < rhs.breakType
            }
    }




    
    /// Remove a tag and deselect it if selected
    func removeTag(_ tag: String) {
        tagOptions.removeAll { $0 == tag }
        selectedTags.remove(tag)
    }

    /// Rename an existing tag (updates selection state too)
    func renameTag(from old: String, to new: String) {
        guard let idx = tagOptions.firstIndex(of: old), !new.isEmpty else { return }
        tagOptions[idx] = new
        if selectedTags.contains(old) {
            selectedTags.remove(old)
            selectedTags.insert(new)
        }
    }
    /// Toggle a tag in/out of the selectedTags set
    func toggleTag(_ tag: String) {
        if selectedTags.contains(tag) {
            selectedTags.remove(tag)
        } else {
            selectedTags.insert(tag)
        }
    }
    
    /// Add a brand‐new tag (and select it if you like)
    func addTag(_ tag: String) {
        guard !tagOptions.contains(tag) else { return }
        tagOptions.append(tag)
        selectedTags.insert(tag)
        savePutts()      // or saveChallenges(), or however you persist your tags
    }


}
