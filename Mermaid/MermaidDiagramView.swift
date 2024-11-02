//
//  MermaidDiagramView.swift
//
//  Created by Bartolomeo Sorrentino on 03/08/22.
//
// inspired by: [How to Display Web Page Using WKWebView](https://www.appcoda.com/swiftui-wkwebview/)

import SwiftUI

import SwiftUI
import WebKit
import Combine
import Commons
import MermaidPreview

struct MermaidDiagramView : View {
    @State private var diagramImage:UIImage?
    
    var text: String?
    @StateObject var mermaidOptions = MermaidPreview.Options()
    
    
    var body: some View {
        
        VStack {
            MermaidPreview( text: text, options: mermaidOptions  )
                
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                ScaleToFitButton()
                ShareDiagramButton()
            }
        }
        .navigationBarTitle(Text( "📈 Diagram Preview" ), displayMode: .inline)

    }
    
}

extension MermaidDiagramView {
    
        
    func ShareDiagramButton() -> some View {
        Button(action: {
            
            mermaidOptions.requestImage = { image in
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
        MermaidDiagramView( text: 
"""
---
title: MERMAID PREVIEW
---
flowchart TD
""" )
    }
}


