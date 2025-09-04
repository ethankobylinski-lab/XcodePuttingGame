// File: Views/StatCard.swift
import SwiftUI
import Charts
import SwiftUI
import Charts

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    var sparklineData: [Double]? = nil
    var accent: Color = .golfAccent

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(accent)
                .symbolRenderingMode(.multicolor)

            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)

            Text(value)
                .font(.cardValueGolf)
                .foregroundColor(accent)

            if let data = sparklineData, !data.isEmpty {
                Chart {
                    ForEach(Array(data.enumerated()), id: \.offset) { idx, val in
                        LineMark(
                            x: .value("Index", idx),
                            y: .value("Value", val)
                        )
                        .foregroundStyle(accent)
                    }
                }
                .chartXAxis(.hidden)
                .chartYAxis(.hidden)
                .frame(height: 30)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.systemBackground))
        )
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

struct StatCard_Previews: PreviewProvider {
    static var previews: some View {
        StatCard(icon: "flag.checkered", title: "Best Dist", value: "5 ft")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
