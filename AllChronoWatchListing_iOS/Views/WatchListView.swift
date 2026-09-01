import SwiftUI

struct WatchListView: View {
    @State private var viewModel: WatchListViewModel

    init(viewModel: WatchListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("AllChrono")
        }
        .task {
            await viewModel.loadWatches()
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            ProgressView()
        case .loaded(let watches):
            List(watches) { watch in
                WatchCardView(watch: watch)
            }
            .listStyle(.plain)
        case .failed(let message):
            ContentUnavailableView(
                "Loading Failed",
                systemImage: "exclamationmark.triangle",
                description: Text(message)
            )
        }
    }
}

#Preview {
    WatchListView(viewModel: WatchListViewModel(watchRepository: LocalWatchRepository()))
}
