//
//  ContentView.swift
//  PlantUML
//
//  Created by Bartolomeo Sorrentino on 01/08/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: PlantUMLDocument

    var body: some View {
        TextEditor(text: $document.text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(PlantUMLDocument()))
    }
}
