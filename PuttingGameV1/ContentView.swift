import SwiftUI

struct ContentView: View {
    @EnvironmentObject var vm: PuttTrackerViewModel

    var body: some View {
        ZStack {
            // MARK: - Main Content
            Group {
                switch vm.selectedTab {
                case .practice:
                    LogPuttsView()
                case .stats:
                    StatsView()
                case .game:
                    ChallengeModeView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal:   .move(edge: .leading).combined(with: .opacity)
            ))
            .animation(.spring(response: 0.4, dampingFraction: 0.8),
                       value: vm.selectedTab)

            // MARK: - Custom Tab Bar
            VStack {
                Spacer()
                CustomTabBar(selectedTab: $vm.selectedTab)
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


/// Custom Tab Bar
struct CustomTabBar: View {
    @Binding var selectedTab: PuttTrackerViewModel.Tab
    @Namespace private var anim

    var body: some View {
        HStack(spacing: 0) {
            tabButton(.practice, icon: "circle.grid.3x3.fill", title: "Practice")
            tabButton(.stats,    icon: "chart.bar.fill",      title: "Stats")
            tabButton(.game,     icon: "flag.checkered",      title: "Game")
            tabButton(.settings, icon: "gearshape.fill",      title: "Settings")
        }
        .padding(.vertical, 8)
        .background(BlurView(style: .systemUltraThinMaterial))
        .cornerRadius(16)
        .padding(.horizontal, 16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }

    @ViewBuilder
    private func tabButton(_ tab: PuttTrackerViewModel.Tab,
                           icon: String,
                           title: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? .golfGreen : .secondary)
                Text(title)
                    .font(.caption)
                    .foregroundColor(selectedTab == tab ? .golfGreen : .secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                ZStack {
                    if selectedTab == tab {
                        Capsule()
                            .fill(Color.golfAccent.opacity(0.3))
                            .matchedGeometryEffect(id: "highlight", in: anim)
                    }
                }
            )
        }
        .buttonStyle(.plain)
    }
}


/// A simple UIViewRepresentable for the blur‐behind effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
          .environmentObject(PuttTrackerViewModel())
    }
}
