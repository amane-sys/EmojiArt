//
//  EmojiArtDocument.swift
//  EmojiArt
//
//  Created by Adelaide Jia on 2025/03/18.
//

import SwiftUI

class EmojiArtDocument: ObservableObject {
    typealias Emoji = EmojiArt.Emoji
    @Published private var emojiArt = EmojiArt()
    
    init(initialEmoji: [Emoji] = [], background: URL? = nil) {
        self.emojiArt = EmojiArt(background: background, emojis: initialEmoji)
    }
    
    var emojis: [Emoji] {
        emojiArt.emojis
    }
    
    var background: URL? {
        emojiArt.background
    }
    
    // MARK: - Intent(s)
    
    func setBackground(_ url: URL?) {
        emojiArt.background = url
    }
    
    func addEmoji(_ emoji: String, at position: Emoji.Position, size: CGFloat) {
        emojiArt.addEmoji(emoji, at: position, size: Int(size))
    }
}

extension EmojiArt.Emoji {
    var font: Font {
        Font.system(size: CGFloat(size))
    }
}

func convertToCanvasPoint(position: EmojiArt.Emoji.Position, inCavasSize size: CGSize) -> CGPoint {
    let center = CGPoint(x: size.width / 2, y: size.height / 2)
    return CGPoint(
        x: center.x + CGFloat(position.x),
        y: center.y - CGFloat(position.y)
    )
}

extension EmojiArt.Emoji.Position {
    func `in`(_ geometry: GeometryProxy) -> CGPoint {
        convertToCanvasPoint(position: self, inCavasSize: geometry.size)
    }
}
