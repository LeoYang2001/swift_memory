//
//  WelcomeView.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/25/24.
//

import Foundation
import SwiftUI

struct WelcomeView: View{
    
    @ObservedObject var modelView = EmojiMemoryGame()
    
    var body: some View{
        NavigationView{
            VStack{
                Spacer()
                
                NavigationLink(destination: EmojiMemoryGameView(viewModel: modelView))
                {
                    Text("Start New Game")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("Welcome")
        }
    }
}

#Preview {
    WelcomeView()
}

