//
//  Queues.swift
//
//
//  Created by bsorrentino on 24/07/24.
//

import Foundation

public class LILOQueue<T> {
    
    var _elements:Array<T> = []
    
    public var elements:Array<T> {
        get {
            return _elements
        }
    }
    
    public var isEmpty:Bool {
        _elements.isEmpty
    }
    
    public func push( _ item: T ) {
        _elements.append( item )
    }
    
    public func pop() -> T? {
        guard  !_elements.isEmpty else {
            return nil
        }
        
        return _elements.removeLast()
    }
    
    public func clear() {
        _elements.removeAll()
    }
    
}

public class LILOFixedSizeQueue<T> : LILOQueue<T> {
    
    private let size:Int
    
    public init( maxSize size: Int ) {
        self.size = size
    }
    
    public override func push( _ item: T ) {
        if _elements.count == size {
            _elements.removeFirst()
        }
        _elements.append( item )
    }
    
}
