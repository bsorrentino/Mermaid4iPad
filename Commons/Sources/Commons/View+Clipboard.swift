//
//  View+Clipboard.swift
//
//  Created by Bartolomeo Sorrentino on 01/04/23.
//

import SwiftUI
import OSLog


// https://www.simpleswiftguide.com/advanced-swiftui-button-styling-and-animation/
public struct ScaleButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    public func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.3 : 1.0)
            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
    }
}

public struct CopyToClipboardButton : View {
    
    var value:String
    
    public init( value:String ) {
        self.value = value
    }
    
    public var body: some View {
        Button( action: {
            #if os(iOS)
            UIPasteboard.general.string = self.value
            #elseif os(macOS)
            NSPasteboard.general.declareTypes([ NSPasteboard.PasteboardType.string ], owner: nil)
            NSPasteboard.general.setString(self.value, forType: .string)
            #endif
            os_log("copied to clipboard!", type: .debug)
         }) {
            Image( systemName: "doc.on.clipboard")
        }
        .buttonStyle(ScaleButtonStyle())
        
    }
}

#Preview {
    CopyToClipboardButton(value: "")
}
