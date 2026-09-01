import SwiftUI

struct WatchCardView: View {
    let watch: Watch

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(watch.make)
                .font(.headline)
            Text(watch.model)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(formattedPrice)
                .font(.subheadline.weight(.semibold))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 10)
    }

    private var formattedPrice: String {
        "\(watch.currency) \(watch.price)"
    }
}
