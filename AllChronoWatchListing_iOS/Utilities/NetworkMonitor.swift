import Foundation
import Network

protocol NetworkMonitoring: AnyObject {
    var isConnected: Bool { get }

    func connectivityUpdates() -> AsyncStream<Bool>
}

final class NetworkMonitor: NetworkMonitoring {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "com.allchrono.network-monitor")
    private var continuation: AsyncStream<Bool>.Continuation?

    private(set) var isConnected = true

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.isConnected = isConnected
            self?.continuation?.yield(isConnected)
        }

        monitor.start(queue: queue)
    }

    func connectivityUpdates() -> AsyncStream<Bool> {
        AsyncStream { continuation in
            continuation.yield(isConnected)
            self.continuation = continuation
            continuation.onTermination = { [weak self] _ in
                self?.continuation = nil
            }
        }
    }

    deinit {
        monitor.cancel()
    }
}
