//
//  PlantUMLPreviw.swift
//  PlantUML
//
//  Created by Bartolomeo Sorrentino on 03/08/22.
//
// inspired by: [How to Display Web Page Using WKWebView](https://www.appcoda.com/swiftui-wkwebview/)

import SwiftUI

import SwiftUI
import WebKit
import Combine
import Commons

struct MermaidDiagramView : View {
    @State private var isScaleToFit = true
    @State private var diagramImage:UIImage?
    
    var text: String?
    var contentMode:ContentMode {
        if isScaleToFit { .fit } else { .fill }
    }
    
    var diagramView:some View {
        EmptyView()
    }

    var body: some View {
        
        VStack {
            if isScaleToFit {
                diagramView
            }
            else {
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    diagramView
                }
            }
        }
//        .border(Color.red)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                ScaleToFitButton()
                ShareDiagramButton()
            }
        }
        .navigationBarTitle(Text( "📈 Diagram Preview" ), displayMode: .inline)

    }
    
}

extension MermaidDiagramView {
    
    
    func ScaleToFitButton() -> some View {
        
        Toggle("fit image", isOn: $isScaleToFit)
            .toggleStyle(ScaleToFitToggleStyle())
        
    }
    
    func ShareDiagramButton() -> some View {
        Button(action: {
            if let image = self.asUIImage() {
                diagramImage = image
            }
        }) {
            ZStack {
                Image(systemName:"square.and.arrow.up")
                SwiftUIActivityViewController( uiImage: $diagramImage )
            }
            
        }
        
    }
    
}
#Preview {
    NavigationStack {
        MermaidDiagramView( text: "" )
    }
}


