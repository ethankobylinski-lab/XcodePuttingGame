// File: Views/ChallengeModeView.swift

import SwiftUI
import Charts

struct ChallengeModeView: View {
    @EnvironmentObject var vm: PuttTrackerViewModel
    @State private var selectedChallenge: ChallengeType = .random
    @State private var totalShots: Int = 10
    @State private var maxDistance: Int = 8

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Continue or Select
                    if vm.challengeActive {
                        NavigationLink("Continue Challenge", destination: ChallengeDetailView())
                            .font(.sectionGolf)
                            .foregroundColor(.golfGreen)
                    } else {
                        challengeSelector
                    }

                    // History Charts
                    if !vm.challengeHistory.isEmpty {
                        historyCharts
                    }
                }
                .padding()
            }
            .navigationTitle("Challenge Mode")
        }
    }

    private var challengeSelector: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Challenge")
                .font(.sectionGolf)
                .foregroundColor(.golfGreen)

            Picker("Type", selection: $selectedChallenge) {
                ForEach(ChallengeType.allCases, id: \.self) { type in
                    Text(type.description).tag(type)
                }
            }
            .pickerStyle(MenuPickerStyle())

            Stepper("Max Distance: \(maxDistance) ft", value: $maxDistance, in: 1...20)
            Stepper("Total Shots: \(totalShots)",      value: $totalShots,   in: 1...50)

            Button {
                vm.startChallenge(type: selectedChallenge,
                                  total: totalShots,
                                  maxDistance: maxDistance)
            } label: {
                Label("Start Challenge", systemImage: "play.fill")
            }
            .buttonStyle(.borderedProminent)
            .tint(Color.golfAccent)
        }
    }

    private var historyCharts: some View {
        VStack(alignment: .leading, spacing: 16) {
            Divider()

            Text("History Overview")
                .font(.sectionGolf)
                .foregroundColor(.golfGreen)
                .padding(.horizontal)

            let successData = vm.challengeSuccessRateByDate()
            Chart(successData, id: \.date) { item in
                LineMark(
                    x: .value("Date", item.date),
                    y: .value("Success %", item.pct)
                )
                .foregroundStyle(Color.golfAccent)
            }
            .frame(height: 150)
            .chartXAxis { AxisMarks(values: .stride(by: .day)) }

            let winLossData = vm.challengeWinLossCounts()
            Chart(winLossData, id: \.result) { item in
                SectorMark(angle: .value("Count", item.count))
                    .foregroundStyle(Color.golfAccent)
                    .annotation(position: .overlay) {
                        Text(item.result)
                            .font(.caption)
                            .foregroundColor(.primary)
                    }
            }
            .frame(height: 150)
        }
    }
}

struct ChallengeModeView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeModeView()
            .environmentObject(PuttTrackerViewModel())
    }
}
