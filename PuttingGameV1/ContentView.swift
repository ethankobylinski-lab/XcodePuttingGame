import SwiftUI
import PuttingGameCore

/// Simple interface to simulate practice putts and demonstrate tip overlays.
struct ContentView: View {
    @State private var session = PracticeSession()
    @State private var distance: Double = 5

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Stepper("Distance: \(Int(distance)) ft", value: $distance, in: 1...60)
                HStack {
                    Button("Make") {
                        session.recordPutt(distance: distance, made: true)
                    }
                    .buttonStyle(.borderedProminent)

                    Button("Miss") {
                        session.recordPutt(distance: distance, made: false)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding()

            if let tip = session.activeTip {
                TipOverlay(tip: tip) {
                    session.dismissTip()
                }
                .transition(.opacity)
            }
        }
        .animation(.default, value: session.activeTip)
    }
}

#Preview {
    ContentView()
}
