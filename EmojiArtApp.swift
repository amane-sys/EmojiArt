//
//  EmojiArtApp.swift
//  EmojiArt
//
//  Created by Adelaide Jia on 2025/03/18.
//

import SwiftUI

@main
struct EmojiArtApp: App {
    @StateObject var defaultDocument = EmojiArtDocument()
    var body: some Scene {
        WindowGroup {
            EmojiArtDocumentView(document: defaultDocument)
        }
    }
}
