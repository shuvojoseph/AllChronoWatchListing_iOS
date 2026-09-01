import SwiftUI

struct WatchListView: View {
    @State private var viewModel: WatchListViewModel

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(viewModel: WatchListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isOffline {
                    offlineBanner
                }

                content
            }
            .navigationTitle("AllChrono")
            .searchable(text: $viewModel.searchText, prompt: "Search watches")
        }
        .task {
            await viewModel.loadWatches()
        }
        .task {
            await viewModel.observeConnectivity()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .loaded(let watches):
            ScrollView {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(watches) { watch in
                        WatchCardView(watch: watch)
                    }
                }
                .padding(12)
            }
        case .empty(let query):
            ContentUnavailableView(
                "No Watches Found",
                systemImage: "magnifyingglass",
                description: Text("No results for \"\(query)\".")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        case .failed(let message):
            ContentUnavailableView(
                "Loading Failed",
                systemImage: viewModel.isOffline ? "wifi.slash" : "exclamationmark.triangle",
                description: Text(message)
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private var offlineBanner: some View {
        Label("Offline", systemImage: "wifi.slash")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(Color.red)
            .accessibilityIdentifier("offline-banner")
    }
}

#Preview {
    WatchListView(
        viewModel: WatchListViewModel(
            watchRepository: LocalWatchRepository(),
            networkMonitor: NetworkMonitor()
        )
    )
}
