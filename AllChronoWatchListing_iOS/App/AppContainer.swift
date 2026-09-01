import Foundation

struct AppContainer {
    private let watchRepository: WatchRepository
    private let networkMonitor: NetworkMonitor

    init(
        watchRepository: WatchRepository = LocalWatchRepository(),
        networkMonitor: NetworkMonitor = NetworkMonitor()
    ) {
        self.watchRepository = watchRepository
        self.networkMonitor = networkMonitor
    }

    @MainActor
    func makeWatchListViewModel() -> WatchListViewModel {
        WatchListViewModel(
            watchRepository: watchRepository,
            networkMonitor: networkMonitor
        )
    }
}
