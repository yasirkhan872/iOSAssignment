//
//  Reachability.swift
//  iOS_assignment
//
//  Created by Yasir Khan on 02/02/2025.
//

import Foundation
import SystemConfiguration
import UIKit
import Network

public class InternetConnectionManager {
    static let shared = InternetConnectionManager()
    private let monitor = NWPathMonitor()
    private var isMonitoring = false
    
    private init() {}
    
    /// Start monitoring internet connection
    func startMonitoring() {
        guard !isMonitoring else { return }
        
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                // Internet connection is available, trigger API call
                NotificationCenter.default.post(name: .internetConnectionRestored, object: nil)
            }
        }
        
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor.start(queue: queue)
        isMonitoring = true
    }
    
    /// Stop monitoring internet connection
    func stopMonitoring() {
        guard isMonitoring else { return }
        
        monitor.cancel()
        isMonitoring = false
    }
    
    /// Check whether internet connection is available or not
    public static func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                
                SCNetworkReachabilityCreateWithAddress(nil, $0)
                
            }
            
        }) else {
            
            return false
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
    
}
