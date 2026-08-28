import SwiftUI

struct WatchDetailView: View {
    let watch: Watch

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                WatchImageView(url: watch.imageURL)
                    .frame(height: 390)
                    .clipShape(RoundedRectangle(cornerRadius: 28))

                VStack(alignment: .leading, spacing: 8) {
                    Text(watch.make.uppercased())
                        .font(.caption.weight(.bold))
                        .tracking(1.4)
                        .foregroundStyle(Color.chronoGold)
                    Text(watch.model)
                        .font(.system(size: 34, design: .serif))
                    Text(watch.displayPrice)
                        .font(.title3.weight(.semibold))
                }
            }
            .padding(20)
        }
        .background(Color.catalogBackground)
        .navigationTitle("Watch details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
