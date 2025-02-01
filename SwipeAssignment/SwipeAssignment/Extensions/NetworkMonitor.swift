//
//  NetworkMonitor.swift
//  SwipeAssignment
//
//  Created by Ashwin Kumar on 30/01/25.
//

import Observation
import Network
import SwiftUI

@Observable
class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var pathStatus: NWPath.Status = .unsatisfied
    
    var isReachable: Bool {
        pathStatus == .satisfied
    }
    
    var statusText: String {
        switch pathStatus {
            case .satisfied:
                return "Connected to Internet!"
            default :
                return "No Internet Connection"
        }
    }
    
    init() {
        startMonitoring()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.pathStatus = path.status
            }
        }
        monitor.start(queue: queue)
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
    
    deinit {
        stopMonitoring()
    }
}

