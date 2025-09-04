// File: Views/LogPuttsView.swift

import SwiftUI

struct LogPuttsView: View {
    @EnvironmentObject var vm: PuttTrackerViewModel
    @State private var showingAddTag = false
    @State private var newTagText = ""
    @GestureState private var pressingMake = false
    @GestureState private var pressingMiss = false
    @Namespace private var animation

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.golfGreen.opacity(0.2), Color.white]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 32) {
                    header
                    summaryCard
                    circularLogControl
                    pickerCard
                    statsCards
                    recentLogs
                }
                .padding(.vertical)
            }
        }
    }

    // MARK: Header
    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Putting Practice")
                .font(.title1Golf)
                .foregroundColor(.golfGreen)
            Text("Track your strokes and improve your game")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.horizontal)
    }

    // MARK: Session Summary Card
    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 24) {
                statBlock(title: "Session XP", value: "\(vm.xp)")
                statBlock(title: "Make %",     value: String(format: "%.1f%%", vm.sessionAvg))
                statBlock(title: "Total Putts", value: "\(vm.putts.count)")
            }
            ProgressView(value: min(Double(vm.xp) / 100, 1.0))
                .progressViewStyle(LinearProgressViewStyle(tint: .golfAccent))
        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    // MARK: Circular Log Control
    private var circularLogControl: some View {
        ZStack {
            Circle()
                .fill(.ultraThinMaterial)
                .frame(width: 200, height: 200)
                .overlay(
                    Circle()
                        .stroke(Color.golfAccent, lineWidth: 6)
                        .blur(radius: 4)
                )

            missButton(for: .missedLong).offset(y: -100)
            missButton(for: .missedLeft).offset(x: -100)
            missButton(for: .missedRight).offset(x: 100)
            missButton(for: .missedShort).offset(y: 100)

            Button(action: { vm.logPutt(result: .made) }) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.golfGreen)
                    .scaleEffect(pressingMake ? 0.8 : 1)
            }
            .buttonStyle(.plain)
            .gesture(
                LongPressGesture(minimumDuration: 0.1)
                    .updating($pressingMake) { v, s, _ in s = v }
            )
        }
        .frame(height: 260)
    }

    // MARK: Distance & Tag Picker Card
    private var pickerCard: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Distance Selector
            VStack(alignment: .leading, spacing: 12) {
                Text("Distance").font(.sectionGolf)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(1...8, id: \.self) { d in
                            Button {
                                vm.distance = d
                            } label: {
                                Text("\(d)ft")
                                    .font(.chipGolf)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(
                                        ZStack {
                                            if vm.distance == d {
                                                Capsule()
                                                    .fill(Color.golfAccent)
                                                    .matchedGeometryEffect(id: "distance", in: animation)
                                            } else {
                                                Capsule().fill(Color.secondary.opacity(0.2))
                                            }
                                        }
                                    )
                                    .foregroundColor(vm.distance == d ? .white : .primary)
                            }
                            .buttonStyle(.plain)
                        }
                        HStack(spacing: 4) {
                            Text("Custom:").font(.chipGolf)
                            Stepper(value: $vm.distance, in: 9...100) {
                                Text("\(vm.distance)ft").font(.chipGolf)
                            }
                            .labelsHidden()
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(Capsule().fill(Color.secondary.opacity(0.2)))
                    }
                    .padding(.horizontal)
                }
            }
            // Tag Sections
            TagSection(
              title: "Putters",
              options: vm.putterOptions,
              selected: $vm.selectedTags,     // pass the value, not $
              action: vm.toggleTag
            )

            TagSection(
              title: "Grips",
              options: vm.gripOptions,
              selected: $vm.selectedTags,
              action: vm.toggleTag
            )
            TagSection(
              title: "Balls",
              options: vm.ballOptions,
              selected: $vm.selectedTags,
              action: vm.toggleTag
            )

            // Add Tag Button
            Button(action: { showingAddTag = true }) {
                HStack {
                    Image(systemName: "plus.circle")
                    Text("Add Tag")
                }
                .font(.chipGolf)
                .padding(.vertical, 8)
                .padding(.horizontal)
                .background(Capsule().fill(Color.secondary.opacity(0.2)))
            }
            .sheet(isPresented: $showingAddTag) {
              VStack(spacing: 16) {
                Text("Add New Tag")
                  .font(.headline)

                TextField("Tag name", text: $newTagText)
                  .textFieldStyle(RoundedBorderTextFieldStyle())
                  .padding(.horizontal)

                // ← Here’s the change
                Button(action: {
                  guard !newTagText.isEmpty else { return }
                  vm.addTag(newTagText)
                  newTagText = ""
                  showingAddTag = false
                }) {
                  Text("Add Tag")
                }
                .buttonStyle(.borderedProminent)

                Spacer()
              }
              .padding()
            }

            // Start Game Button
            // New trailing‐label form:
            Button {
                vm.selectedTab = .game
            } label: {
                Text("Start Game")
                  .font(.sectionGolf)
                  .frame(maxWidth: .infinity)
                  .padding()
                  .background(RoundedRectangle(cornerRadius: 12).fill(Color.golfAccent))
                  .foregroundColor(.white)
            }

        }
        .padding(24)
        .background(.ultraThinMaterial)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }

    // MARK: Stats Cards
    private var statsCards: some View {
        HStack(spacing: 16) {
            StatCard(icon: "sparkles", title: "Session XP", value: "\(vm.xp)")
            StatCard(icon: "percent", title: "Session %", value: String(format: "%.1f%%", vm.sessionAvg))
            StatCard(icon: "chart.bar.fill", title: "All-Time %", value: String(format: "%.1f%%", vm.totalAvg))
        }
        .padding(.horizontal)
    }

    // MARK: Recent Logs
    private var recentLogs: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Putts").font(.sectionGolf).padding(.horizontal)
            ForEach(vm.putts.suffix(8).reversed(), id: \.id) { putt in
                HStack {
                    Text(putt.date, style: .time)
                        .frame(width: 60, alignment: .leading)
                    Text("\(putt.distance)ft")
                        .frame(width: 50, alignment: .center)
                    Text(putt.result.emoji)
                        .frame(width: 30)
                    Spacer()
                    Text(putt.gripStyle)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
            }
        }
    }

    // MARK: Helpers
    private func statBlock(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.chipGolf)
                .foregroundColor(.secondary)
            Text(value)
                .font(.cardValueGolf)
                .foregroundColor(.primary)
        }
    }

    private func missButton(for result: PuttResult) -> some View {
        let symbol: String
        switch result {
        case .missedLong:  symbol = "chevron.up.circle.fill"
        case .missedShort: symbol = "chevron.down.circle.fill"
        case .missedLeft:  symbol = "chevron.left.circle.fill"
        case .missedRight: symbol = "chevron.right.circle.fill"
        default:           symbol = "xmark.circle.fill"
        }
        return Button(action: { vm.logPutt(result: result) }) {
            Image(systemName: symbol)
                .font(.system(size: 40))
                .foregroundColor(.red)
                .scaleEffect(pressingMiss ? 0.8 : 1)
        }
        .buttonStyle(.plain)
        .gesture(
            LongPressGesture(minimumDuration: 0.1)
                .updating($pressingMiss) { current, state, _ in state = current }
        )
    }
}

// MARK: TagSection Component
struct TagSection: View {
    let title: String
    let options: [String]
    @Binding var selected: Set<String>    // ← make this a binding
    let action: (String) -> Void

    init(
      title: String,
      options: [String],
      selected: Binding<Set<String>>,    // ← and accept a Binding
      action: @escaping (String) -> Void
    ) {
      self.title = title
      self.options = options
      self._selected = selected          // ← note the underscore
      self.action = action
    }

    var body: some View {
      VStack(alignment: .leading, spacing: 8) {
        Text(title)
          .font(.sectionGolf)
          .padding(.horizontal)
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 12) {
            ForEach(options, id: \.self) { opt in
              TagChip(
                title: opt,
                isSelected: selected.contains(opt)) {
                  action(opt)
              }
            }
          }
          .padding(.horizontal)
        }
      }
    }
}


// MARK: Preview
struct LogPuttsView_Previews: PreviewProvider {
    static var previews: some View {
        LogPuttsView()
            .environmentObject(PuttTrackerViewModel())
    }
}
