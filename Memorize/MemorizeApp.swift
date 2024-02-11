//
//  MemorizeApp.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/7/24.
//

import SwiftUI

@main
struct MemorizeApp: App {
    @StateObject var game = EmojiMemoryGame()
    
    var body: some Scene {
        WindowGroup {
//            EmojiMemoryGameView(viewModel: game)
            WelcomeView()
        }
    }
}


