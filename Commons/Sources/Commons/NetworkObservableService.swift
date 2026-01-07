//
//  NetworkObservableService.swift
//  Commons
//
//  Created by bsorrentino on 28/11/24.
//

import Network
import SwiftUI

public class NetworkObservableService: ObservableObject {
    let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    @Published public var isConnected: Bool = true
    
    
    public init() {
        monitor.pathUpdateHandler = { path in
            print( "network path update: \(path)")
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        monitor.start(queue: queue)
    }
}


public struct NetworkEnabledModifier: ViewModifier {
    
    @ObservedObject var networkService: NetworkObservableService
    
    public init( networkService: NetworkObservableService ) {
        self.networkService = networkService
    }
    
    public func body(content: Content) -> some View {
        content
            .disabled(!networkService.isConnected)
    }
}

public struct NetworkEnabledStyleModifier: ViewModifier {
    
    @ObservedObject var networkService: NetworkObservableService
    
    public init( networkService: NetworkObservableService ) {
        self.networkService = networkService
    }
    
    public func body(content: Content) -> some View {
        content
            // Change color when disabled
            // .foregroundColor(networkService.isConnected ? .blue : .gray)
            // Reduce opacity when disabled
            .opacity(networkService.isConnected ? 1 : 0.5)
    }
}

//
// MARK: - Metwork extension
//

extension View {
    
    public func networkEnabled( _ networkService: NetworkObservableService ) -> some View {
        modifier(NetworkEnabledModifier(networkService: networkService))
    }

    public func networkEnabledStyle( _ networkService: NetworkObservableService ) -> some View {
        modifier(NetworkEnabledStyleModifier(networkService: networkService))
    }


}
