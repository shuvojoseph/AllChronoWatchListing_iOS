import SwiftUI

struct WatchCardView: View {
    let watch: Watch

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            watchImage

            VStack(alignment: .leading, spacing: 4) {
                Text(watch.make)
                    .font(.headline)
                    .lineLimit(2)
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
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay {
            RoundedRectangle(cornerRadius: 8)
                .stroke(.quaternary, lineWidth: 1)
        }
    }

    @ViewBuilder
    private var watchImage: some View {
        AsyncImage(url: URL(string: watch.imageUrl)) { phase in
            switch phase {
            case .empty:
                placeholder(systemImage: "photo")
                    .overlay {
                        ProgressView()
                    }
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
            case .failure:
                placeholder(systemImage: "wifi.exclamationmark")
            @unknown default:
                placeholder(systemImage: "photo")
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .clipped()
        .background(Color(.secondarySystemBackground))
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
