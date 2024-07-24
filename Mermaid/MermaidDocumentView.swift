//
//  PlantUMLContentView.swift
//  PlantUML
//
//  Created by Bartolomeo Sorrentino on 01/08/22.
//

import SwiftUI
import Combine
import SwiftyMonaco
import AppSecureStorage
import PencilKit

//
// [Managing Focus in SwiftUI List Views](https://peterfriese.dev/posts/swiftui-list-focus/)
//
//  enum Focusable: Hashable {
//      case none
//      case row(id: String)
//  }


struct MermaidDocumentView: View {
    typealias MermaidEditorView = SwiftyMonaco
    
    @Environment(\.scenePhase) var scene
    @Environment(\.interfaceOrientation) var interfaceOrientation: InterfaceOrientationHolder
    @Environment(\.openURL) private var openURL
    
    @AppStorage("lightTheme") var lightTheme:String = "light"
    @AppStorage("darkTheme") var darkTheme:String = "dark"
    @AppStorage("fontSize") var fontSize:Int = 15
    
    @StateObject var document: MermaidObservableDocument
    @StateObject private var openAIService = OpenAIObservableService()
    
    @State var isOpenAIVisible  = false
    
    @State var keyboardTab: String  = "general"
    @State private var showLine:Bool = true
    @State private var saving = false
    
    @State private var editorViewId  = 1
    
    var body: some View {
        
        VStack {
            GeometryReader { geometry in
                
                VStack {
                    MermaidEditorView( text: $document.text
//                                        darkTheme: CodeWebView.Theme(rawValue: darkTheme)!,
//                                        lightTheme: CodeWebView.Theme(rawValue: lightTheme)!,
//                                        isReadOnly: false,
//                                        fontSize: CGFloat(fontSize),
//                                        showGutter: showLine
                    )
                    .language(.mermaid)
                    .theme("mermaid")
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
        .onRotate(perform: { orientation in
            //            if  (orientation.isPortrait && isDiagramVisible) ||
            //                    (orientation.isLandscape && isEditorVisible)
            //            {
            //                isEditorVisible.toggle()
            //            }
        })
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
extension MermaidDocumentView {
    
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
extension MermaidDocumentView {
    
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
                        MermaidDocumentView.SavedStateView( visible: $visible )
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
            Button( action: { fontSize += 1 } ) {
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
                   subject: Text("PlantUML Script"))
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
extension MermaidDocumentView {
    
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
    
    let preview_text = """

    title test

    actor myactor
    participant participant1

    myactor -> participant1


    """

    return NavigationStack {
        MermaidDocumentView( document: MermaidObservableDocument(
            document: .constant(MermaidDocument( text: preview_text)), fileName:"Untitled" ))
        .navigationViewStyle(.stack)
    }
    
    
}

