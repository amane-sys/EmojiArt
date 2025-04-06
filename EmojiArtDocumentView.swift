//
//  EmojiArtDocumentView.swift
//  EmojiArt
//
//  Created by Adelaide Jia on 2025/03/18.
//

import SwiftUI

struct EmojiArtDocumentView: View {
    typealias Emoji = EmojiArt.Emoji
    
    @ObservedObject var document: EmojiArtDocument

    private let emojis = "🐻💥🛌⛹🔊🚢🚢🎱🚢📈🚢🚋😀😂🤣😍🥰😎🤩😜🤔😱🙌🔥🚀🌈⭐️💡🎉🎶💖"
    private let paletteEmojiSize: CGFloat = 40
    
    var body: some View {
        VStack(spacing: 0) {
            documentBody
            ScrollingEmojis(emojis: emojis)
                .font(.system(size: paletteEmojiSize))
                .padding(.horizontal)
                .scrollIndicators(.hidden)
        }
    }
    
    private var documentBody: some View {
        GeometryReader { geometry in
            ZStack {
                Color.white
                AsyncImage(url: document.background)
                    .position(Emoji.Position.zero.in(geometry))
                ForEach(document.emojis) { emoji in
                    Text(emoji.string)
                        .font(emoji.font)
                        .position(emoji.position.in(geometry))
                }
            }
            .dropDestination(for: Sturldata.self) { sturldatas, location in
                for sturldata in sturldatas {
                    if case .url(let url) = sturldata, !url.pathExtension.lowercased().contains("jpg") {
                        print("⚠️ 可能是网页缩略图链接：\(url.absoluteString)")
                    }
                }
                return drop(sturldatas, at: location, in: geometry)
            }
        }
    }
    
    private func drop(_ sturldatas: [Sturldata], at location: CGPoint, in geometry: GeometryProxy) -> Bool {
        print("Dropped items: \(sturldatas)")
        for sturldate in sturldatas {
            switch sturldate {
            case .url(let url):
                document.setBackground(url)
                return true
            case .string(let emoji):
                document
                    .addEmoji(
                        emoji,
                        at: emojiPosition(
                            at: location,
                            in: geometry
                        ),
                        size: paletteEmojiSize
                    )
                return true
            default:
                break
            }
        }
        return false
    }
    
    private func emojiPosition(at location: CGPoint, in geometry: GeometryProxy) -> Emoji.Position {
        let center = geometry.frame(in: .local).center
        return Emoji.Position(
            x: Int(location.x - center.x),
            y: Int(-(location.y - center.y))
        )
    }
}

struct ScrollingEmojis: View {
    let emojis: [String]
    
    init(emojis: String) {
        self.emojis = emojis.uniqued.map(String.init)
    }
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(emojis, id: \.self) { emoji in
                    Text(emoji)
                        .draggable(emoji)
                }
            }
        }
    }
}

#Preview {
    EmojiArtDocumentView(document: EmojiArtDocument())
}
