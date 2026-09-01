import Foundation

struct LocalWatchRepository: WatchRepository {
    enum RepositoryError: Error {
        case missingResource
    }

    private let bundle: Bundle
    private let decoder: JSONDecoder

    init(bundle: Bundle = .main, decoder: JSONDecoder = JSONDecoder()) {
        self.bundle = bundle
        self.decoder = decoder
    }

    func fetchWatches() async throws -> [Watch] {
        guard let url = bundle.url(forResource: "watches", withExtension: "json") else {
            throw RepositoryError.missingResource
        }

        let data = try Data(contentsOf: url)
        return try decoder.decode([Watch].self, from: data)
    }
}
