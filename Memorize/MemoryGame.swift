//
//  MemoryGame.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/17/24.
//

import Foundation
import SwiftUI

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card> // access control, ViewModel can only read my cards.
    
    private(set) var theme: Theme
    
    private(set) var userInfo: UserInfo
    
    init(theme: Theme,  cardContentFactory: (Int) -> CardContent){
        cards = []
        self.theme = theme
        self.userInfo = UserInfo(score: 10)
        // add numberOfPairsOfCards
        for pairIndex in 0..<max(2, theme.numberOfPairs){
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex + 1)a"))
            cards.append(Card(content: content, id: "\(pairIndex + 1)b"))
        }
    }
    
    
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get{
            return cards.indices.filter{ index in cards[index].isFaceUp }.only
        }
        set{
//            for index in cards.indices {
//                if index == newValue{
//                    cards[index].isFaceUp = true
//                }
//                else{
//                    cards[index].isFaceUp = false
//                }
//            }
            return cards.indices.forEach{ cards[$0].isFaceUp = (newValue == $0)}
        }
    }
    
    mutating func penalty(){
        self.userInfo.score = self.userInfo.score - 1
    }
    mutating func award(_ chosenCard: Card, _ potentialMatchedCard: Card){
        self.userInfo.score = self.userInfo.score + 2 + chosenCard.bonus + potentialMatchedCard.bonus
    }
    
    mutating func choose(card: Card){
        
        if let chosenIndex = cards.firstIndex(where: {$0.id == card.id})
        {
            if !cards[chosenIndex].isFaceUp && !cards[chosenIndex].isMatched {
                    
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[chosenIndex].content == cards[potentialMatchIndex].content{
                        cards[chosenIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                        award(cards[chosenIndex], cards[potentialMatchIndex])
                    }
                    else if card.hasBeenSeen
                    {
                        penalty()
                    }
                }
                else{
                    indexOfTheOneAndOnlyFaceUpCard = chosenIndex
                }
                cards[chosenIndex].isFaceUp = true
                
            }
        }
       
    }
    
    
    mutating func shuffle(){
        cards.shuffle()
    }
    
    struct Card: Equatable, Identifiable, CustomDebugStringConvertible{
        var isFaceUp: Bool = false
        {
            didSet {
                if isFaceUp{
                    startUsingBonusTime()
                }
                else{
                    stopUsingBonusTime()
                }
                
                if oldValue && !isFaceUp{
                    hasBeenSeen = true
                }
            }
        }
        var isMatched: Bool = false{
            didSet{
                if isMatched{
                    stopUsingBonusTime()
                }
            }
        }
        var hasBeenSeen: Bool = false
        let content: CardContent
        
        var id: String
        var debugDescription: String {
            return "\(id): \(content) \(isFaceUp ? "up" : "down") \(isMatched ? "matched":"")"
        }
        
        
        // MARK: - Bonus Time
               
               // call this when the card transitions to face up state
           private mutating func startUsingBonusTime() {
               if isFaceUp && !isMatched && bonusPercentRemaining > 0, lastFaceUpDate == nil {
                   lastFaceUpDate = Date()
               }
           }
           
           // call this when the card goes back face down or gets matched
           private mutating func stopUsingBonusTime() {
               pastFaceUpTime = faceUpTime
               lastFaceUpDate = nil
           }
           
           // the bonus earned so far (one point for every second of the bonusTimeLimit that was not used)
           // this gets smaller and smaller the longer the card remains face up without being matched
           var bonus: Int {
               Int(bonusTimeLimit * bonusPercentRemaining)
           }
           
           // percentage of the bonus time remaining
           var bonusPercentRemaining: Double {
               bonusTimeLimit > 0 ? max(0, bonusTimeLimit - faceUpTime)/bonusTimeLimit : 0
           }
           
           // how long this card has ever been face up and unmatched during its lifetime
           // basically, pastFaceUpTime + time since lastFaceUpDate
           var faceUpTime: TimeInterval {
               if let lastFaceUpDate {
                   return pastFaceUpTime + Date().timeIntervalSince(lastFaceUpDate)
               } else {
                   return pastFaceUpTime
               }
           }
           
           // can be zero which would mean "no bonus available" for matching this card quickly
           var bonusTimeLimit: TimeInterval = 6
           
           // the last time this card was turned face up
           var lastFaceUpDate: Date?
           
           // the accumulated time this card was face up in the past
           // (i.e. not including the current time it's been face up if it is currently so)
           var pastFaceUpTime: TimeInterval = 0
        
        
    }
    
    struct Theme {
            var name: String
            var emojis: [CardContent]
            var numberOfPairs: Int
            var color: Color
    }
    
    struct UserInfo{
        var score: Int
    }
    
    
    
    
}


extension Array {
    var only: Element? {
        return count == 1 ? first : nil
    }
}
