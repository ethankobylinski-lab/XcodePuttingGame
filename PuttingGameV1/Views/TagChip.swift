// File: Views/TagChip.swift
import SwiftUI

struct TagChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Text(title)
            .font(.chipGolf)  // uses your new Theme.swift font
            .padding(.vertical, 6)
            .padding(.horizontal, 12)
            .background(
                Capsule()
                    .fill(isSelected ? Color.golfAccent : Color.secondary.opacity(0.1))
            )
            .foregroundColor(isSelected ? .white : .primary)
            .overlay(
                Capsule()
                  .stroke(isSelected ? Color.golfAccent : Color.secondary.opacity(0.3), lineWidth: 1)
            )
            .onTapGesture { action() }
    }
}

struct TagChip_Previews: PreviewProvider {
    static var previews: some View {
        TagChip(title: "Blade", isSelected: true) {}
    }
}
