import Foundation

protocol WatchRepository {
    func fetchWatches() async throws -> [Watch]
}
