//
//  FlyingNumber.swift
//  Memorize
//
//  Created by 杨嘉煌 on 2/1/24.
//

import SwiftUI

struct FlyingNumber: View {
    let number: Int
    
    @State private var offset: CGFloat = 0
    
    var body: some View {
        if number != 0 {
            Text(number, format: .number.sign(strategy: .always()))
                .font(.largeTitle)
                .shadow(color: .black,radius: 1.5, x:1, y: 1)
                .foregroundStyle(number < 0 ? .red : .green)
                .offset(x:0, y: offset)
                .opacity(offset != 0 ? 0 : 1)
                .onAppear{
                    withAnimation(.easeIn(duration: 1.5)){
                        offset = number < 0 ? 200 : -200
                    }
                }
                .onDisappear{
                    offset = 0
                }
        }
    }
}
