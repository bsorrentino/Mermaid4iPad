//
//  MermaidDocumentView.swift
//  MermaidApp
//
//  Created by bsorrentino on 13/10/24.
//
import SwiftUI

protocol MermaidDocumentView: View {
    
    var isOpenAIVisible: Bool { get }
    
    func toggleOpenAI()
}
