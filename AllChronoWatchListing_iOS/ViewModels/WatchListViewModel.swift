import Foundation
import Observation

@MainActor
@Observable
final class WatchListViewModel {
    enum State: Equatable {
        case idle
        case loading
        case loaded([Watch])
        case failed(String)
    }

    private let watchRepository: WatchRepository
    private(set) var state: State = .idle

    init(watchRepository: WatchRepository) {
        self.watchRepository = watchRepository
    }

    func loadWatches() async {
        state = .loading

        do {
            let watches = try await watchRepository.fetchWatches()
            state = .loaded(watches)
        } catch {
            state = .failed("Unable to load watches.")
        }
    }
}
