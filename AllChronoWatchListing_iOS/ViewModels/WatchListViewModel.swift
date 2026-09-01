import Foundation

@MainActor
final class WatchListViewModel {
    private let watchRepository: WatchRepository

    init(watchRepository: WatchRepository) {
        self.watchRepository = watchRepository
    }
}
