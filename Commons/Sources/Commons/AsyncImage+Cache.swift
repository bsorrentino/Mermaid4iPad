//
//  AsyncImage+Cache.swift
//
//  Created by Bartolomeo Sorrentino on 04/12/22.
//
// Inspired by : [How can I add caching to AsyncImage](https://stackoverflow.com/a/70916651/521197)
//

import SwiftUI

public struct CachedAsyncImage<Content>: View where Content: View {
    
    private let url: URL
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
    
    public init(
        url: URL?,
        scale: CGFloat = 1.0,
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ){
        self.url = url!
        self.scale = scale
        self.transaction = Transaction()
        self.content = content
    }
    
    public var body: some View {
        
        if let cached = ImageCache[url] {
            content(.success(cached))
        } else {
            AsyncImage(
                url: url,
                scale: scale,
                transaction: transaction,
                content: cacheAndRender
            ) 
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View{
            if case .success (let image) = phase {
                ImageCache[url] = image
            }
            return content(phase)
        }
    
}

fileprivate class ImageCache{
    
    static private var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image?{
        get{
            ImageCache.cache[url]
        }
        set{
            ImageCache.cache[url] = newValue
        }
    }
}

