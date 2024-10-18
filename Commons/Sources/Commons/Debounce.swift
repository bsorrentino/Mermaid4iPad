//
//  Debounce.swift
//  
//
//  Created by Bartolomeo Sorrentino on 06/01/23.
//

import Foundation
import Combine

class DebounceUpdate<T> where T : Equatable {

    private var updateSubject = PassthroughSubject<T, Never>()
    
    private var cancellabe:Cancellable?
    
    func subscribe( debounceInSeconds seconds: Double,  onUpdate update: @escaping ( T ) -> Void ) {
        
        if self.cancellabe == nil  {
            
            self.cancellabe = updateSubject
                .removeDuplicates()
                .debounce(for: .seconds(seconds), scheduler: RunLoop.main)
                .print()
                .sink( receiveValue: update )

        }

    }
    
    func request( for element:T ) {
        updateSubject.send( element )
    }
}

class DebounceUpdateObject<T> : ObservableObject where T : Equatable {

    let update = DebounceUpdate<T>()
    
}


public class DebounceRequest {

    private var requestSubject = PassthroughSubject<Void, Never>()
    
    public let publisher:AnyPublisher<Void,Never>

    public init( debounceInSeconds seconds: Double ) {
        
        publisher = requestSubject
            .debounce(for: .seconds(seconds), scheduler: RunLoop.main)
            .eraseToAnyPublisher()

    }
    
    public func send() {
        requestSubject.send(())
    }
}



