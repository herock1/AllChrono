import SwiftUI

struct BrandFilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(title, action: action)
            .font(.subheadline)
            .foregroundStyle(isSelected ? Color.catalogBackground : Color.primary)
            .padding(.horizontal, 15)
            .frame(height: 38)
            .background(isSelected ? Color.primary : Color.cardBackground, in: Capsule())
            .overlay(Capsule().stroke(isSelected ? .clear : Color.cardBorder, lineWidth: 1))
            .buttonStyle(.plain)
    }
}
