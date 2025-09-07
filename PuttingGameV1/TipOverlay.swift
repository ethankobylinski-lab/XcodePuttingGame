import SwiftUI

/// A dismissible overlay displaying a practice tip for 5 seconds.
struct TipOverlay: View {
    let tip: String
    let dismiss: () -> Void

    @State private var isVisible = true

    var body: some View {
        if isVisible {
            VStack {
                Text(tip)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black.opacity(0.8))
                    .cornerRadius(8)
                Button("Dismiss") {
                    dismissOverlay()
                }
                .padding(.top, 8)
            }
            .padding()
            .onAppear {
                // Automatically dismiss after 5 seconds.
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    dismissOverlay()
                }
            }
        }
    }

    private func dismissOverlay() {
        guard isVisible else { return }
        isVisible = false
        dismiss()
    }
}

#Preview {
    TipOverlay(tip: "Focus on grip pressure", dismiss: {})
        .background(Color.gray)
}
