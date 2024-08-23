import SwiftUI
import Network
 
@Observable
class Network{
    private let network = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false
 
    init() {
        network.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        network.start(queue: workerQueue)
    }
}
