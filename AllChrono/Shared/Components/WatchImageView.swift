import SwiftUI

struct WatchImageView: View {
    let url: URL?

    var body: some View {
        GeometryReader { proxy in
            AsyncImage(url: url, transaction: Transaction(animation: .easeInOut)) { phase in
                switch phase {
                case let .success(image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .clipped()
                case .failure:
                    placeholder
                        .frame(width: proxy.size.width, height: proxy.size.height)
                case .empty:
                    ZStack {
                        placeholder
                        ProgressView().tint(.chronoGold)
                    }
                    .frame(width: proxy.size.width, height: proxy.size.height)
                @unknown default:
                    placeholder
                        .frame(width: proxy.size.width, height: proxy.size.height)
                }
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
            .clipped()
        }
        .clipped()
    }

    private var placeholder: some View {
        ZStack {
            LinearGradient(
                colors: [Color.chronoGold.opacity(0.18), Color.cardBackground],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Image(systemName: "watch.analog")
                .font(.system(size: 48, weight: .ultraLight))
                .foregroundStyle(Color.chronoGold)
        }
    }
}
