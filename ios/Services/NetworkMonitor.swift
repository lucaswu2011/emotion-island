import Foundation
import Network

/// 监听设备联网状态 — DeepSeek 仅在在线时可用
@MainActor
@Observable
final class NetworkMonitor {
    static let shared = NetworkMonitor()

    private(set) var isOnline = true

    private let pathMonitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "emotion-island.network-monitor")

    private init() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            let online = path.status == .satisfied
            Task { @MainActor in
                self?.isOnline = online
            }
        }
        pathMonitor.start(queue: queue)
        isOnline = pathMonitor.currentPath.status == .satisfied
    }
}

enum NetworkConnectivity {
    @MainActor
    static var isOnline: Bool { NetworkMonitor.shared.isOnline }
}
