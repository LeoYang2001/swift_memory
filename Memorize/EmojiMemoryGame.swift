//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/17/24.
//

import SwiftUI


//ObservedObject make the class as a ModelView
class EmojiMemoryGame: ObservableObject {
    
    static let pairNumber: Int = 8
    //static makes the variable global, by making the val global we can assure this initializer is utilized first
    private static let themes: [MemoryGame<String>.Theme] = [
           MemoryGame<String>.Theme(name: "Default", emojis: ["😎","👀","🥸","😄","😚","🙂","😒","🥳","🤩","🥶","😶‍🌫️","😱","😨","😓","😥"], numberOfPairs: pairNumber, color: .blue),
           MemoryGame<String>.Theme(name: "Halloween", emojis: ["🤡","👻","💀","☠️","👽","🤖","🎃"], numberOfPairs: pairNumber, color: .black),
           MemoryGame<String>.Theme(name: "other", emojis: ["😎","👀","🥸","😄","😚","🙂","😒","🥳","🤩","🥶","😶‍🌫️","😱","😨","😓","😥"], numberOfPairs: pairNumber, color: .red),
           MemoryGame<String>.Theme(name: "Family", emojis: ["👨🏼","🧑","👦","🧑‍🦳","👶","👳‍♀️","👲","👳","👮‍♀️","👱🏾‍♂️","👩‍🦰","👨🏿‍🦱","👦","🧔🏻"], numberOfPairs: pairNumber, color: .green)
           // Add more themes as needed
       ]
   
    private static let userInfo = MemoryGame<String>.UserInfo(score: 0)
    
    private static func createMemoryGame(theme: MemoryGame<String>.Theme) -> MemoryGame<String>{
        let emojis_copy = theme.emojis.shuffled();
        return MemoryGame(theme: theme){
            pairIndex in
            if emojis_copy.indices.contains(pairIndex)
            {
                return emojis_copy[pairIndex]
            }
            else{
                return "❗️"
            }
        }
    }
    
    // I can only access to the Model part from here
    @Published private var model : MemoryGame<String>
    
    init(theme: MemoryGame<String>.Theme = themes.first!) {
        self.model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    // game Setup
    func restartGame(){
     
        if let randomTheme = EmojiMemoryGame.themes.randomElement()
        {
            model = EmojiMemoryGame.createMemoryGame(theme: randomTheme)
        }
        else{
            model = EmojiMemoryGame.createMemoryGame(theme: EmojiMemoryGame.themes.first!)
        }
        model.shuffle()
    }
    
    var cards: Array<MemoryGame<String>.Card>{
        return model.cards
    }
    
    var theme: MemoryGame<String>.Theme {
        return model.theme
    }
    
    var score: Int{
        return model.userInfo.score
    }
    
    //MARK: - intents
    func shuffle(){
        model.shuffle()
    }
    
    func choose(_ card: MemoryGame<String>.Card){
        model.choose(card: card)
    }
}
