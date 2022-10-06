//
//  File.swift
//  
//
//  Created by Bartolomeo Sorrentino on 06/10/22.
//

import Foundation

extension Symbol {
    
    @resultBuilder
    struct Builder {
        typealias PART2 = (String, String)
        typealias PART3 = (String, String, [String])
        
        static func buildBlock(_ parts: Any...) -> [Symbol] {
            
            parts.compactMap { elem in
                
                if let sym = elem as? Symbol {
                    return sym
                }
                else if let str = elem as? String {
                    return Symbol(str)
                }
                else if let part2 = elem as? PART2 {
                    return Symbol(part2.0, part2.1)
                }
                else if let part3 = elem as? PART3 {
                    return Symbol(part3.0, part3.1, part3.2)
                }
                
                return nil
            }
        }
    }

    struct Line {

        var content: [Symbol]
        
        init( @Builder content: () -> [Symbol] ) {
            self.content = content()
        }
    }

    @resultBuilder
    struct LineBuilder {
        
        static func buildBlock(_ parts: Line...) -> [[Symbol]] {
            parts.compactMap { $0.content }
        }
    }

}


