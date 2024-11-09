//
//  NetworkStatus.swift
//  Cerc@t
//
//  Created by Luis Lasierra on 9/11/24.
//

import SwiftUI
import Network

final class NetworkStatus:ObservableObject {
    enum Status {
        case offline, online, unknown
    }
    
    @Published var status:Status = .unknown
    
    var monitor:NWPathMonitor
    var queue = DispatchQueue(label: "MonitorNetwork")
    
    init() {
        monitor = NWPathMonitor()
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.status = path.status == .satisfied ? .online : .offline
            }
        }
        self.status = monitor.currentPath.status == .satisfied ? .online : .offline
    }
}
