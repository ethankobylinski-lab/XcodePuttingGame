// File: Views/ChallengeDetailView.swift

import SwiftUI

struct ChallengeDetailView: View {
    @EnvironmentObject var vm: PuttTrackerViewModel
    @State private var showResultAlert = false

    var body: some View {
        VStack(spacing: 24) {
            targetView
            buttonRow
            historyScroll
            statsView
            Spacer()
        }
        .padding()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Challenge In-Progress")
                    .font(.sectionGolf)
                    .foregroundColor(.golfGreen)
            }
        }
        .onChange(of: vm.challengeActive) { active in
            if !active { showResultAlert = true }
        }
        .alert(isPresented: $showResultAlert) {
            let last = vm.challengeHistory.last!
            return Alert(
                title: Text("Challenge Completed"),
                message: Text("\(last.result): \(last.makes)/\(last.attempts)"),
                dismissButton: .default(Text("OK"))
            )
        }
    }

    private var targetView: some View {
        Text("Target: \(vm.currentChallengeDistance) ft")
            .font(.largeTitle)
    }

    private var buttonRow: some View {
        HStack(spacing: 20) {
            ForEach(PuttResult.allCases, id: \.self) { res in
                Button {
                    vm.logPutt(result: res)
                } label: {
                    Text(res.emoji)
                        .font(.system(size: 32))
                        .frame(width: 60, height: 60)
                        .background(Color.golfAccent.opacity(0.2))
                        .clipShape(Circle())
                }
                .buttonStyle(.bordered)
                .tint(Color.golfAccent)
            }
        }
    }

    private var historyScroll: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.currentChallengeResults, id: \.self) { res in
                    Text(res.emoji).font(.title)
                }
            }
        }
        .frame(height: 50)
    }

    private var statsView: some View {
        VStack(spacing: 8) {
            Text("Makes: \(vm.challengeMakes)")
            Text("Attempts: \(vm.challengeAttempts)")
            Text("Remaining: \(vm.challengeRemaining)")
        }
        .font(.headline)
    }
}

struct ChallengeDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ChallengeDetailView()
            .environmentObject(PuttTrackerViewModel())
    }
}
