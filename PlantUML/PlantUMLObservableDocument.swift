//
//  PlantUMLDiagramBuilder.swift
//  PlantUML
//
//  Created by Bartolomeo Sorrentino on 03/08/22.
//

import Foundation
import PlantUMLFramework
import Combine
import SwiftUI

class DebounceRequest {

    private var requestSubject = PassthroughSubject<Void, Never>()
    
    public let publisher:AnyPublisher<Void,Never>

    init( debounceInSeconds seconds: Double ) {
        
        publisher = requestSubject
            .debounce(for: .seconds(seconds), scheduler: RunLoop.main)
            .eraseToAnyPublisher()

    }
    
    func send() {
        requestSubject.send(())
    }
}

class PlantUMLObservableDocument : ObservableObject {
    
    @Binding var object: PlantUMLDocument
    @Published var text: String
    var drawing: Data?
    var fileName:String

    let updateRequest = DebounceRequest( debounceInSeconds: 0.5)
    
    let presenter = PlantUMLBrowserPresenter( format: .imagePng )

    private var textCancellable:AnyCancellable?
    
    init( document: Binding<PlantUMLDocument>, fileName:String ) {
        self._object = document
        self.text = document.wrappedValue.isNew ? "title Untitled" : document.wrappedValue.text
        self.drawing = document.wrappedValue.drawing
        self.fileName = fileName
    }
    
    func buildURL() -> URL {
        
        let items = text
                        .split(whereSeparator: \.isNewline)
                        .map { line in
                            SyntaxStructure( rawValue: String(line) )
                        }
        let script = PlantUMLScript( items: items )
               
        return presenter.url( of: script )
    }
    
    func reset() {
        self.text = self.object.text
        self.drawing = self.object.drawing
    }
    
    func save() {
        print( "save document")
        self.object.text = self.text
        self.object.drawing = self.drawing
    }

    
}


extension PlantUMLObservableDocument {
    
    private static func buildSyntaxStructureItems( from text: String ) -> Array<SyntaxStructure> {
        return text
            .split(whereSeparator: \.isNewline)
            .filter { line in
                line != "@startuml" && line != "@enduml"
            }
            .map { line in
                SyntaxStructure( rawValue: String(line) )
            }
    }

}
