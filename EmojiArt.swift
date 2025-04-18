//
//  EmojiArt.swift
//  EmojiArt
//
//  Created by Adelaide Jia on 2025/03/18.
//

import Foundation

struct EmojiArt {
    var background: URL?
    private(set) var emojis = [Emoji]()
    
    init(
        background: URL? = nil,
        emojis: [EmojiArt.Emoji] = [Emoji]()
    ) {
        self.background = background
        self.emojis = emojis
    }
    
    private var uniqueEmojiId = 0
    
    mutating func addEmoji(_ emoji: String, at position: Emoji.Position, size: Int) {
        uniqueEmojiId += 1
        emojis.append(Emoji(string: emoji, position: position, size: size, id: uniqueEmojiId))
    }
    
    struct Emoji: Identifiable {
        var string: String
        var position: Position
        var size: Int
        var id: Int
        
        struct Position {
            var x: Int
            var y: Int
            
            static let zero = Self(x: 0, y: 0)
        }
        
        
    }
}
