//
//  ContentView.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/7/24.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    typealias Card = MemoryGame<String>.Card
    
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    private let dealAnimation : Animation = .easeInOut(duration: 0.6)
    private let deckWidth: CGFloat = 50
    private let deckInter: TimeInterval = 0.1
    @State private var ifDealtYet: Bool = false
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(viewModel.theme.name).bold().font(.title3)
                .animation(nil)
                Spacer()
                discardedDeck
            }
            
            cards.layoutPriority(99)
        
            Spacer()
            HStack{
                Text("Score: \(viewModel.score)")
                    .fontWeight(.semibold)
                    .font(.title3)
                    .animation(nil)
                Spacer()
                deck
                Spacer()
                Button {
                    withAnimation {
                        viewModel.shuffle()
                    }
                } label: {
                    Text("Shuffle")
                        .fontWeight(.semibold)
                        .font(.title3)
                        .foregroundStyle(viewModel.theme.color)
                        .opacity(ifDealtYet ? 1 : 0.2)
                }
                .disabled(!ifDealtYet)
            }
        }
        .padding()
//        .background(.yellow)
    }
    
//    @ViewBuilder
    var cards: some View{
        AspectVGrid(viewModel.cards, aspectRatio: aspectRatio){card in
            Group{
                if isDealt(card){
                    CardView(card, themeColor: viewModel.theme.color)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .transition(.asymmetric(insertion: .identity, removal: .identity))
                        .padding(4)
                        .overlay(FlyingNumber(number: scoreChange(casedBy: card)))
                        .zIndex(scoreChange(casedBy: card) != 0 ? 1 : 0)
                        .onTapGesture {
                            choose(card)
                        }
                }
                else{
                    Text("")
                }
            }
        }
    }
    
    private func choose(_ card : Card){
        withAnimation(.easeInOut(duration: 0.8)) {
            let scoreBeforeChoosing = viewModel.score
            viewModel.choose(card)
            let scoreChange = viewModel.score - scoreBeforeChoosing
            lastScoreChange = (scoreChange, causedByCardId: card.id)
        }
    }
    
    
    @State private var lastScoreChange = (0, causedByCardId : "")
    @State private var dealt = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool{
        dealt.contains(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter {!isDealt($0)}
    }
    
    @Namespace private var dealingNamespace
    
    private var deck: some View{
        ZStack{
            ForEach(undealtCards) {
                card in
                CardView(card, themeColor: viewModel.theme.color)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth/aspectRatio)
        .onTapGesture{
            var delay: TimeInterval = 0
            for card in viewModel.cards{
                withAnimation(dealAnimation.delay(delay)){
                   _ = dealt.insert(card.id)
                }
                delay += 0.15
            }
            ifDealtYet = true
        }
        .onAppear(){
            viewModel.restartGame()
        }
    }
    
    private var discardedDeck: some View{
        ZStack{
            ForEach(viewModel.cards.filter{$0.isMatched}) {
                card in
                DiscardedCardView(card, themeColor: viewModel.theme.color)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
            }
        }
        .frame(width: deckWidth, height: deckWidth/aspectRatio)
    }
    
   
    
    private func scoreChange(casedBy card: Card) -> Int{
        let (amount, causedByCardId: id) = lastScoreChange
        return card.id == id ? amount : 0;
    }
}









   
   

//

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
