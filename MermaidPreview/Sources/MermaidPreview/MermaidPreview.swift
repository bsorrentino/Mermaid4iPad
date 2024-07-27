// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI


public struct MermaidPreview : UIViewControllerRepresentable {

    
    var text: String?
//    var options: Options
    
    public init(text: String? )
    {
        self.text = text
    }

    public func makeUIViewController(context: Context) -> MermaidPreviewController {
        MermaidPreviewController()
    }
    
    public func updateUIViewController(_ uiViewController: MermaidPreviewController, context: Context) {
        if let text {
            uiViewController.requestUpdate( text: text )
        }
    }
    
    
    
    
    
    
    
}
