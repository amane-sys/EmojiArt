//
//  PaletteChooser.swift
//  EmojiArt
//
//  Created by Adelaide Jia on 2025/05/07.
//

import SwiftUI

struct PaletteChooser: View {
    @EnvironmentObject var store: PaletteStore
    
    var body: some View {
        HStack {
            chooser
            view(for: store.palettes[store.cursorIndex])
        }
        .clipped()
    }
    
    var chooser: some View {
        AnimatedActionButton(systemImage: "paintpalette") {
            store.cursorIndex += 1
        }
        .contextMenu {
            AnimatedActionButton("New", systemImage: "plus") {
                store.insert(name: "Math", emojis: "+−×÷∝∞")
            }
            AnimatedActionButton(
                "Delete",
                systemImage: "minus.circle",
                role: .destructive
            ) {
                store.palettes.remove(at: store.cursorIndex)
            }
        }
    }
    
    func view(for palette: Palette) -> some View {
        HStack {
            Text(palette.name)
            ScrollingEmojis(emojis: palette.emojis)
        }
        .id(palette.id)
        .transition(
            .asymmetric(
                insertion: .move(edge: .bottom),
                removal: .move(edge: .top)
            )
        )
    }
}

#Preview {
    PaletteChooser()
        .environmentObject(PaletteStore(named: "Preview"))
}
