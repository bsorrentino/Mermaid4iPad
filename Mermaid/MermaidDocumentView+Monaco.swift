//
//  MermaidDocumentView.swift
//
//  Created by Bartolomeo Sorrentino on 01/08/22.
//

import SwiftUI
import Combine
import SwiftyMonaco

import AppSecureStorage
import PencilKit
import Commons
//
// [Managing Focus in SwiftUI List Views](https://peterfriese.dev/posts/swiftui-list-focus/)
//
//  enum Focusable: Hashable {
//      case none
//      case row(id: String)
//  }


struct MermaidDocumentViewMonaco: MermaidDocumentView {
    
    @Environment(\.scenePhase) var scene
    @Environment(\.interfaceOrientation) var interfaceOrientation: InterfaceOrientationHolder
    @Environment(\.openURL) private var openURL
    
//    @AppStorage("lightTheme") var lightTheme:String = "light"
//    @AppStorage("darkTheme") var darkTheme:String = "dark"
    @AppStorage("fontSize") var fontSize:Int = 15
    
    @StateObject var document: MermaidObservableDocument
    @StateObject private var openAIService = OpenAIObservableService()
    
    @State var isOpenAIVisible  = false
    
//    @State var keyboardTab: String  = "general"
    @State private var showLine:Bool = true
    @State private var saving = false
    
    @State private var editorViewId  = 1
    
    func toggleOpenAI() {
        isOpenAIVisible.toggle()
    }
    var options:SwiftyMonaco.Options {
        SwiftyMonaco.Options(
            syntax: .mermaid,
            minimap: false,
            fontSize: fontSize,
            theme: "mermaid",
            lineNumbers: showLine)
    }
    var body: some View {
        
        VStack {
            GeometryReader { geometry in
                
                VStack {
                    SwiftyMonaco( text: $document.text, options: options )
                    .id( editorViewId )
                    .if( isRunningTests ) { /// this need for catching current editor data from UI test
                        $0.overlay(alignment: .bottom) {
                            Text( document.text )
                                .frame( width: 0, height: 0)
                                .opacity(0)
                                .accessibilityIdentifier("editor-text")
                        }
                    }
                }
                
                
            }
            if isOpenAIVisible /* && interfaceOrientation.value.isPortrait */ {
                OpenAIView( service: openAIService,
                            document: document,
                            drawingView:  { DiagramDrawingView } )
                .frame( height: 200 )
                .onChange(of: openAIService.status ) { newStatus in
                    if( .Ready == newStatus ) {
                        // Force rendering editor view
                        //                            print( "FORCE RENDERING OF EDITOR VIEW")
                        editorViewId += 1
                    }
                }
                
            }
        }
        .onChange(of: document.text ) { _ in
            saving = true
            document.updateRequest.send()
        }
        .onReceive(document.updateRequest.publisher) { _ in
            withAnimation(.easeInOut(duration: 1.0)) {
                document.save()
                saving = false
            }
        }
//        .onRotate(perform: { orientation in })
//        .navigationBarTitle(Text( "📝 Diagram Editor" ), displayMode: .inline)
        
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) { }
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                HStack( spacing: 0 ) {
                    SavingStateView( saving: saving )
                    
                    HStack(alignment: .center, spacing: 5) {
                        ToggleOpenAIButton
                        Divider().background(Color.blue)
                    }
                    .frame(height:20)

                    HStack {
                        updateEditorFontSizeView()
                        toggleEditorLineNumberView()
                        shareDiagramTextView()
                    }
                    
                    ToggleDiagramButton()
                }
            }
        }
    }
}

//
// MARK: - Drawing extension -
//
extension MermaidDocumentViewMonaco {
    
    var DiagramDrawingView: some View {
        
        NavigationStack {
            MermaidDrawingView( service: openAIService,
                                 document: document )
            
        }
        
    }
}

//
// MARK: - Editor extension -
//
extension MermaidDocumentViewMonaco {
    
    // [SwiftUI Let View disappear automatically](https://stackoverflow.com/a/60820491/521197)
    struct SavedStateView: View {
        @Binding var visible: Bool
        let timer = Timer.publish(every: 5.0, on: .main, in: .common).autoconnect()
        
        var body: some View {
            
            Text("_saved_" )
                .onReceive(timer) { _ in
                    withAnimation {
                        self.visible.toggle()
                    }
                }
                .transition( AnyTransition.asymmetric(insertion: .scale, removal: .opacity))
        }
    }
    
    struct SavingStateView: View {
        var saving:Bool
        @State private var visible = false
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 5) {
                if( saving ) {
                    ProgressView()
                    Text( "_saving..._")
                        .onAppear {
                            visible = true
                        }
                }
                else {
                    if visible {
                        MermaidDocumentViewMonaco.SavedStateView( visible: $visible )
                    }
                }
            }
            .foregroundColor(Color.secondary)
            .frame( maxWidth: 100 )
        }
        
    }
    
    func toggleEditorLineNumberView() -> some View {
        Button( action: { showLine.toggle() } ) {
            Image( systemName: "list.number")
        }
        
    }
    
    func updateEditorFontSizeView() -> some View {
        HStack( spacing: 0 ) {
            Button( action: { fontSize += 1 }) {
                Image( systemName: "textformat.size.larger")
            }
            .accessibilityIdentifier("font+")
            Divider()
                .background(Color.blue)
                .frame(height:20)
                .padding( .leading, 5)
            Button( action: { fontSize -= 1} ) {
                Image( systemName: "textformat.size.smaller")
            }
            .accessibilityIdentifier("font-")
        }
    }
    
    func shareDiagramTextView() -> some View {
        ShareLink( item: document.text, 
                   subject: Text("Mermaid Script"))
    }
    
    @available(swift, obsoleted: 1.1,message: "from 1.1 auto save has been introduced")
    func SaveButton() -> some View {
        
        Button( action: {
            document.save()
        },
                label:  {
            Label( "Save", systemImage: "arrow.down.doc.fill" )
                .labelStyle(.titleOnly)
        })
    }
    
}

//
// MARK: - Diagram extension -
//
extension MermaidDocumentViewMonaco {
    
    func ToggleDiagramButton() -> some View {
        
        NavigationLink(  destination: {
            MermaidDiagramView( text: document.text )
                .toolbarRole(.navigationStack)
        }) {
            Label( "Preview >", systemImage: "photo.fill" )
                .labelStyle(.titleOnly)
                .foregroundColor( .blue )
        }
        .accessibilityIdentifier("diagram_preview")
        .padding(.leading, 15)
        
    }
    
}



// MARK: - Preview -
#Preview {
    
    let preview_text = 
"""
---
title: ADAPTIVE RAG EXECUTOR
---
flowchart TD
    start((start))
    stop((stop))
    web_search("web_search")
    retrieve("retrieve")
    grade_documents("grade_documents")
    generate("generate")
    transform_query("transform_query")
    %%      condition1{"check state"}
    %%      condition2{"check state"}
    %%      startcondition{"check state"}
    %%      start:::start --> startcondition:::startcondition
    %%      startcondition:::startcondition -->|web_search| web_search:::web_search
    start:::start -->|web_search| web_search:::web_search
    %%      startcondition:::startcondition -->|vectorstore| retrieve:::retrieve
    start:::start -->|vectorstore| retrieve:::retrieve
    web_search:::web_search --> generate:::generate
    retrieve:::retrieve --> grade_documents:::grade_documents
    %%      grade_documents:::grade_documents --> condition1:::condition1
    %%      condition1:::condition1 -->|transform_query| transform_query:::transform_query
    grade_documents:::grade_documents -->|transform_query| transform_query:::transform_query
    %%      condition1:::condition1 -->|generate| generate:::generate
    grade_documents:::grade_documents -->|generate| generate:::generate
    transform_query:::transform_query --> retrieve:::retrieve
    %%      generate:::generate --> condition2:::condition2
    %%      condition2:::condition2 -->|not supported| generate:::generate
    generate:::generate -->|not supported| generate:::generate
    %%      condition2:::condition2 -->|not useful| transform_query:::transform_query
    generate:::generate -->|not useful| transform_query:::transform_query
    %%      condition2:::condition2 -->|useful| stop:::stop
    generate:::generate -->|useful| stop:::stop
"""

    return NavigationStack {
        MermaidDocumentViewMonaco( document: MermaidObservableDocument(
            document: .constant(MermaidDocument( text: preview_text)), fileName:"Untitled" ))
        .navigationViewStyle(.stack)
    }
    
    
}

