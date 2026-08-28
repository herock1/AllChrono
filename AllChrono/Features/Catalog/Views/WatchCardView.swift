import SwiftUI

struct WatchCardView: View {
    let watch: Watch
    let isSaved: Bool
    let onSave: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topTrailing) {
                WatchImageView(url: watch.imageURL)
                    .frame(maxWidth: .infinity)
                    .frame(height: 170)
                    .clipped()

                Button(action: onSave) {
                    Image(systemName: isSaved ? "heart.fill" : "heart")
                        .foregroundStyle(isSaved ? .red : .primary)
                        .frame(width: 34, height: 34)
                        .background(.ultraThinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .padding(10)
                .accessibilityLabel(isSaved ? "Remove from saved" : "Save watch")
            }
            .frame(height: 170)
            .clipped()

            VStack(alignment: .leading, spacing: 5) {
                Text(watch.make.uppercased())
                    .font(.system(size: 10, weight: .bold))
                    .tracking(0.7)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(watch.model)
                    .font(.system(size: 17, design: .serif))
                    .lineLimit(1)
                Text(watch.displayPrice)
                    .font(.subheadline.weight(.semibold))
                    .padding(.top, 2)
            }
            .padding(12)
        }
        .frame(maxWidth: .infinity)
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .clipped()
        .overlay(RoundedRectangle(cornerRadius: 22).stroke(Color.cardBorder, lineWidth: 1))
    }
}
