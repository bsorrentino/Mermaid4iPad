//
//  MermaidDiagramBuilder.swift
//
//  Created by Bartolomeo Sorrentino on 03/08/22.
//


import Foundation
import Combine
import SwiftUI
import PencilKit


let NEW_FILE_TITLE = """
---
title: untitled
---
graph
"""

class MermaidObservableDocument : ObservableObject {
    
    @Binding var object: MermaidDocument
    @Published var text: String
    @Published var drawing: PKDrawing

    var fileName:String
    
    private var textCancellable:AnyCancellable?
    
    init( document: Binding<MermaidDocument>, fileName:String ) {
        self._object = document
        self.text = document.wrappedValue.isNew ? NEW_FILE_TITLE : document.wrappedValue.text
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


    convenience init( config: FileDocumentConfiguration<MermaidDocument> ) {
        self.init( document: config.$document,
                   fileName: config.fileURL?.deletingPathExtension().lastPathComponent ?? "Untitled")
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
    
    var requestToSavePublisher: AnyPublisher<Void, Never> {
        object.saveRequest.publisher
    }
    
    func requestToSave() {
        print( "request to save document")
        self.object.text = self.text
        self.object.drawing = self.drawing.dataRepresentation()
    }

    
}

// MARK: DEMO
extension MermaidObservableDocument {
    
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
