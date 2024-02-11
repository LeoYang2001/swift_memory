//
//  CardView.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/30/24.
//

import SwiftUI

struct DiscardedCardView: View {
    let card: MemoryGame<String>.Card
    let themeColor: Color
    
    init(_ card: MemoryGame<String>.Card, themeColor: Color) {
        self.card = card
        self.themeColor = themeColor
    }
    
    
    
    var body: some View {
        TimelineView(.animation)
        {
            timeline in
            Pie( endAngle: .degrees(card.bonusPercentRemaining * 360))
                .opacity(0.4)
                .overlay(
                    cardContents
                )
                .padding(5)
                .modifier(Cardify(isFaceUp: true, isMatched:false, themeColor: themeColor))
        
        }
    }
    
    var cardContents: some View{
        Text(card.content)
            .font(.system(size: 220))
            .minimumScaleFactor(0.01)
            .multilineTextAlignment(.center)
            .aspectRatio(1, contentMode: .fit)
            .padding(5)
//            .rotationEffect(.degrees(card.isMatched ? 360 : 0))
//            .animation(.spin(duration: 1), value: card.isMatched)
    }
        
        
}

//
//struct CardView_Previews: PreviewProvider{
//
//    typealias Card = MemoryGame<String>.Card
//
//    static var previews: some View {
//        VStack{
//            HStack{
//                CardView(Card( isFaceUp: true, content: "This is very long string and i hope it will fit", id: "test1"), themeColor: .red)
//                CardView(Card(content: "X", id: "test1"), themeColor: .red)
//            }
//            HStack{
//                CardView(Card( isFaceUp:true, content: "X", id: "test1"), themeColor: .red)
//                CardView(Card(isMatched:true,  content: "X", id: "test1"), themeColor: .red)
//            }
//        }
//            .padding()
//    }
//}
