//
//  Cardify.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/30/24.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable{
    init(isFaceUp: Bool, isMatched: Bool, themeColor: Color) {
        rotation = isFaceUp ? 0 : 180
        self.isMatched = isMatched
        self.themeColor = themeColor
        
    }
    
    var isFaceUp: Bool{
        rotation < 90
    }
    let isMatched: Bool
    let themeColor: Color
    
    var rotation: Double
    var animatableData: Double{
        get { rotation }
        set{ rotation = newValue }
    }
    
    func body(content: Content) -> some View {
                ZStack(alignment: .center, content: {
                let base = RoundedRectangle(cornerRadius:12)
                Group{
                    base.foregroundColor(isFaceUp ? .white : themeColor)
                    base.strokeBorder(lineWidth: 3)
                    .overlay(content)
                    .opacity(isFaceUp ? 1 : 0)
                }
                })
                .foregroundColor(themeColor)
                .opacity(isFaceUp || !isMatched ? 1 : 0)
                .rotation3DEffect(.degrees(rotation), axis: (0,1,0))
        
    }
}
extension View{
    func cardify(isFaceUp: Bool, isMatched: Bool, themeColor: Color) -> some View{
        return self.modifier(Cardify(isFaceUp: isFaceUp, isMatched: isMatched, themeColor: themeColor))
    }
}
