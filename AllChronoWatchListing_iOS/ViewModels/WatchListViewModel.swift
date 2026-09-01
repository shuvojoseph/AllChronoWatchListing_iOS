import Foundation
import Observation

@MainActor
@Observable
final class WatchListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded([Watch])
        case empty(String)
        case failed(String)
    }

    private let watchRepository: WatchRepository
    private let networkMonitor: any NetworkMonitoring
    private var allWatches: [Watch] = []

    private(set) var state: State = .idle
    private(set) var isOffline: Bool
    var searchText = "" {
        didSet {
            applySearch()
        }
    }

    init(watchRepository: WatchRepository, networkMonitor: any NetworkMonitoring) {
        self.watchRepository = watchRepository
        self.networkMonitor = networkMonitor
        self.isOffline = !networkMonitor.isConnected
    }

    func loadWatches() async {
        guard state != .loading else { return }

        state = .loading

        do {
            allWatches = try await watchRepository.fetchWatches()
            applySearch()
        } catch {
            state = .failed(loadFailureMessage)
        }
    }

    func observeConnectivity() async {
        for await isConnected in networkMonitor.connectivityUpdates() {
            isOffline = !isConnected
        }
    }

    private func applySearch() {
        guard !allWatches.isEmpty else { return }

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let watches: [Watch]

        if query.isEmpty {
            watches = allWatches
        } else {
            watches = allWatches.filter { watch in
                watch.make.localizedCaseInsensitiveContains(query) ||
                watch.model.localizedCaseInsensitiveContains(query)
            }
        }

        if watches.isEmpty {
            state = .empty(query)
        } else {
            state = .loaded(watches)
        }
    }

    private var loadFailureMessage: String {
        if isOffline {
            return "You're offline. Connect to the internet and try again."
        }

        return "Unable to load watches. Please try again."
    }
}
