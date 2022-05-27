//
//  NetworkMonitor.swift
//  Runner
//
//  Created by ThanhBT on 5/27/22.
//

import Foundation
import Network

class NetworkMonitor {
    static let instants = NetworkMonitor()
    private let queue = DispatchQueue.global()
    private let monitor : NWPathMonitor
    public private(set) var isConnected : Bool = false
    private init(){
        monitor = NWPathMonitor()

    }
    
    public func startMonitoring(){
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = {[weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionTyoe(path)
            
        }
    }
    public func stopMonitorin(){
        monitor.cancel()
    }
    private func getConnectionTyoe(_ path : NWPath){
        var type : String = "Disconnect"
        if (path.usesInterfaceType(.wifi)){
            type = "wifi"
        }else if (path.usesInterfaceType(.cellular)){
            type = "Mobile"
        }else {
            type = "Unknown"
        }
        print(type)
    }
    
}
