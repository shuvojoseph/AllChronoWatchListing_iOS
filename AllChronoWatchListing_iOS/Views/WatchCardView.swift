import SwiftUI

struct WatchCardView: View {
    let watch: Watch

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            watchImage

            VStack(alignment: .leading, spacing: 4) {
                Text(watch.make)
                    .font(.headline)
                    .lineLimit(1)
                Text(watch.model)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                Text(formattedPrice)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .padding([.horizontal, .bottom], 10)
        }
        .frame(maxWidth: .infinity)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary, lineWidth: 1)
        }
    }

    // MARK: - Fixed image view

    @ViewBuilder
    private var watchImage: some View {
        
        GeometryReader { geo in
            AsyncImage(url: URL(string: watch.imageUrl)) { phase in
                switch phase {
                case .empty:
                    placeholder(systemImage: "photo")
                        .overlay { ProgressView() }

                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()

                case .failure:
                    placeholder(systemImage: "wifi.exclamationmark")

                @unknown default:
                    placeholder(systemImage: "photo")
                }
            }
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
        .clipped()
    }

    private func placeholder(systemImage: String) -> some View {
        ZStack {
            Color(.secondarySystemBackground)
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(.secondary)
        }
    }

    private var formattedPrice: String {
        watch.price.formatted(
            .currency(code: watch.currency)
                .precision(.fractionLength(0))
                .locale(Locale(identifier: "en_US"))
        )
    }
}
