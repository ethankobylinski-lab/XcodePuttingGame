// File: Views/StatsView.swift

import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var vm: PuttTrackerViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Actionable Insights header + 2 rows of cards
                    actionableInsightsHeader
                    actionableInsightsRow1
                    actionableInsightsRow2

                    // Banner & charts
                    distanceBannerView
                    xpOverTimeChart
                    makeByTagChart
                    winLossChart
                }
                .padding(.bottom)
            }
            .navigationTitle("Statistics")
        }
    }

    // MARK: – Actionable Insights Header
    private var actionableInsightsHeader: some View {
        Text("🔍 Actionable Insights")
            .font(.sectionGolf)
            .foregroundColor(.golfGreen)
            .padding(.horizontal)
    }

    // MARK: – First row of 4 cards
    private var actionableInsightsRow1: some View {
        let puts = vm.putts
        let total = puts.count
        let made = puts.filter { $0.result == .made }.count
        let missed = total - made
        let makePct = total > 0 ? (Double(made) / Double(total)) * 100 : 0

        // best streak
        let streaks = puts.map { $0.result == .made }
            .reduce(into: [Int]()) { acc, flag in
                if flag { acc.append((acc.last ?? 0) + 1) }
                else    { acc.append(0) }
            }
        let bestStreak = streaks.max() ?? 0

        return LazyVGrid(columns: columns, spacing: 12) {
            StatCard(icon: "hand.thumbsup.fill",
                     title: "Made",
                     value: "\(made)",
                     accent: Color.green)
            StatCard(icon: "hand.thumbsdown.fill",
                     title: "Missed",
                     value: "\(missed)",
                     accent: Color.red)
            StatCard(icon: "percent",
                     title: "Make %",
                     value: String(format: "%.0f%%", makePct),
                     accent: Color.teal)
            StatCard(icon: "flame.fill",
                     title: "Best Streak",
                     value: "\(bestStreak)",
                     accent: Color.orange)
        }
        .padding(.horizontal)
    }

    // MARK: – Second row of 4 cards
    private var actionableInsightsRow2: some View {
        let puts = vm.putts
        let distances = puts.filter { $0.result == .made }.map(\.distance)
        let avgDist = distances.isEmpty ? 0 : Double(distances.reduce(0, +)) / Double(distances.count)
        let byDist = vm.puttsGroupedByDistance()
        let bestDist = byDist.max(by: { $0.pct < $1.pct })?.distance ?? 0

        var bestTag = "—"
        var bestTagPct: Double = 0
        for tag in vm.tagOptions {
            let tagged = puts.filter { [$0.putterType, $0.gripStyle].contains(tag) }
            if !tagged.isEmpty {
                let pct = Double(tagged.filter { $0.result == .made }.count) / Double(tagged.count) * 100
                if pct > bestTagPct {
                    bestTagPct = pct
                    bestTag = tag
                }
            }
        }

        let xpTrend = vm.puttsGroupedByDate().map { Double($0.xp) }

        return LazyVGrid(columns: columns, spacing: 12) {
            StatCard(icon: "ruler",
                     title: "Avg Dist",
                     value: String(format: "%.1f ft", avgDist),
                     accent: Color.blue)
            StatCard(icon: "flag.checkered",
                     title: "Best Dist",
                     value: "\(bestDist) ft",
                     accent: Color.purple)
            StatCard(icon: "tag.fill",
                     title: "Best Tag",
                     value: "\(bestTag) (\(Int(bestTagPct))%)",
                     accent: Color.pink)
            StatCard(icon: "sparkles",
                     title: "XP Trend",
                     value: "",
                     sparklineData: xpTrend,
                     accent: Color.green)
        }
        .padding(.horizontal)
    }

    // MARK: – Top Distance Banner
    @ViewBuilder
    private var distanceBannerView: some View {
        if let best = vm.puttsGroupedByDistance().max(by: { $0.pct < $1.pct }) {
            StatBanner(
                title: "Top Distance",
                subtitle: "Best make % at \(best.distance) ft",
                value: String(format: "%.1f%%", best.pct),
                icon: "flag.checkered"
            )
        }
    }

    // MARK: – XP Over Time Chart
    private var xpOverTimeChart: some View {
        ChartSection(title: "XP Gained Over Time") {
            let data = vm.puttsGroupedByDate()
            Chart(data, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("XP",   item.xp)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Color.golfAccent)
            }
            .chartXScale(domain: .automatic)
            .chartYAxis { AxisMarks(position: .leading) }
            .frame(height: 200)
        }
    }

    // MARK: – Make % by Tag Chart
    private var makeByTagChart: some View {
        ChartSection(title: "Make % by Tag") {
            let tagData: [(String, Double)] = vm.selectedTags.map { tag in
                let attempts = vm.putts.filter { $0.gripStyle == tag }.count
                let makes    = vm.putts.filter { $0.gripStyle == tag && $0.result == .made }.count
                return (tag, attempts > 0 ? Double(makes) / Double(attempts) * 100 : 0)
            }
            Chart(tagData, id: \.0) { entry in
                BarMark(
                    x: .value("Tag", entry.0),
                    y: .value("Make %", entry.1)
                )
                .foregroundStyle(by: .value("Tag", entry.0))
            }
            .chartLegend(.visible)
            .frame(height: 180)
        }
    }

    // MARK: – Win / Loss Pie Chart
    private var winLossChart: some View {
        ChartSection(title: "Win / Loss Count") {
            let data = vm.challengeWinLossCounts()
            Chart(data, id: \.result) { entry in
                SectorMark(angle: .value("Count", entry.count))
                    .foregroundStyle(entry.result == "Passed" ? Color.green : Color.red)
            }
            .frame(height: 200)
        }
    }
}

// MARK: – Helpers

struct ChartSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            content
                .padding(.horizontal)
        }
    }
}

struct StatBanner: View {
    let title: String
    let subtitle: String
    let value: String
    let icon: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.largeTitle)
                .foregroundColor(.golfAccent)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.title)
                    .bold()
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(UIColor.systemBackground))
        )
        .shadow(radius: 2)
        .padding(.horizontal)
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
        StatsView()
            .environmentObject(PuttTrackerViewModel())
    }
}
