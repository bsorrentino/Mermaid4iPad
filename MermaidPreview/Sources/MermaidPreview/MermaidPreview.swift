// The Swift Programming Language
// https://docs.swift.org/swift-book


import SwiftUI


public struct MermaidPreview : UIViewControllerRepresentable {

    public class Options : ObservableObject {
        @Published public var requestImage:( (UIImage) -> Void)?
        
        public init(requestImage: ( (UIImage) -> Void)? = nil) {
            self.requestImage = requestImage
        }
    }

    var text: String?
    @ObservedObject var options: Options
    
//    var options: Options
    public init(text: String? = nil, options: Options) {
        self.text = text
        self.options = options
    }

    public func makeUIViewController(context: Context) -> MermaidPreviewController {
        MermaidPreviewController()
    }
    
    public func updateUIViewController(_ uiViewController: MermaidPreviewController, context: Context) {
        if let text {
            uiViewController.requestUpdate( text: text )
        }
        if let requestImage = options.requestImage {
            uiViewController.requestImage( completionHandler: requestImage )
        }
        
    }
    
    
    
    
    
    
    
}
