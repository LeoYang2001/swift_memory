//
//  ContentView.swift
//  Memorize
//
//  Created by 杨嘉煌 on 1/7/24.
//

import SwiftUI


struct ContentView: View {
    //View is not a struct but a behavior
    //content inside the bracket is computed property
    //there's thousands of views, and some view only mean the body would behave like some certain view depending on the computed property
    //inside the computed property, there's some behaviors going on including:
    //1.creating instances of structs
    //2.named parameters
    //3.parameter defaults
    var body: some View {
        HStack{
            CardView(isFaceUp: true)
            CardView()
            CardView()
            CardView()
        }
        .padding()
    }
    
}

struct CardView: View {
    var isFaceUp: Bool = false
    
    var body: some View {
        ZStack{
            if isFaceUp{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(lineWidth: 3)
                Text("😎")
                    .font(.largeTitle)
            }
            else{
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.orange)
            }
            
            
        }
        .foregroundColor(.orange)
    }
        
}


#Preview {
    ContentView()
}
