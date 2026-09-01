import Foundation

struct AppContainer {
    private let watchRepository: WatchRepository

    init(watchRepository: WatchRepository = LocalWatchRepository()) {
        self.watchRepository = watchRepository
    }

    func makeWatchListViewModel() -> WatchListViewModel {
        WatchListViewModel(watchRepository: watchRepository)
    }
}
