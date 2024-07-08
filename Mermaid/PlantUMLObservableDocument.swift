//
//  PlantUMLDiagramBuilder.swift
//  PlantUML
//
//  Created by Bartolomeo Sorrentino on 03/08/22.
//


import Foundation
import Combine
import SwiftUI
import PencilKit


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
    
    @Binding var object: MermaidDocument
    @Published var text: String
    @Published var drawing: PKDrawing

    var fileName:String

    let updateRequest = DebounceRequest( debounceInSeconds: 0.5)
    
    private var textCancellable:AnyCancellable?
    
    init( document: Binding<MermaidDocument>, fileName:String ) {
        self._object = document
        self.text = document.wrappedValue.isNew ? "title Untitled" : document.wrappedValue.text
        self.fileName = fileName
        
        do {
            if let drawingData = document.wrappedValue.drawing  {
                self.drawing = try PKDrawing( data: drawingData )
            }
            else {
                self.drawing = PKDrawing()
            }
        }
        catch {
            fatalError( "failed to load drawing")
        }
        
    }
    
    func buildURL() -> URL {
        
        let items = text
                        .split(whereSeparator: \.isNewline)
                        .map { line in
                            SyntaxStructure( rawValue: String(line) )
                        }
        let script = PlantUMLScript( items: items )
               
        return plantUMLUrl( of: script, format: .imagePng )
    }
    
    func reset() {
        self.text = self.object.text
        
        do {
            if let drawingData = self.object.drawing {
                self.drawing = try PKDrawing( data: drawingData )
            }
            else {
                self.drawing = PKDrawing()
            }
        }
        catch {
            fatalError( "failed to load drawing")
        }
    }
    
    func save() {
        print( "save document")
        self.object.text = self.text
        self.object.drawing = self.drawing.dataRepresentation()
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

// MARK: DEMO
extension PlantUMLObservableDocument {
    
    fileprivate func saveDrawingForDemo() {
        
        do {
            let dir = try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
            let fileURL = dir.appendingPathComponent("drawing.bin")
            let data = self.drawing.dataRepresentation()
            try data.write(to: fileURL)
            print( "saved drawing file\n\(fileURL)")
        }
        catch {
            print( "error saving file \(error.localizedDescription)" )
        }
        
    }
    
    fileprivate func loadDrawingForDemo( fromDocument doc: MermaidDocument) -> Data? {
        
        guard doc.drawing == nil else {
            return doc.drawing
        }

        do {
            let dir = try FileManager.default.url(for: .documentDirectory,
                                                  in: .userDomainMask,
                                                  appropriateFor: nil,
                                                  create: true)
            let fileURL = dir.appendingPathComponent("drawing.bin")
            
            return try Data(contentsOf: fileURL)
        }
        catch {
            print( "error loading drawing file \(error.localizedDescription)" )
        }

        return nil
    }

}
