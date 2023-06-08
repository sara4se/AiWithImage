//
//  w.swift
//  AItTestImageTWQ
//
//  Created by Sara Alhumidi on 17/11/1444 AH.
//

import SwiftUI
 

struct Circle3: View {
    @State private var shineOffset: CGFloat = -300
    
    var body: some View {
        ZStack {
            Color(.black)
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color(hex: "#AB99FD"), Color(hex: "#87F1FB"), Color(hex: "#DBE2EB")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 200, height: 200)
                .overlay(
                    Circle().stroke(LinearGradient(gradient: Gradient(colors: [Color(hex: "#AB99FD"), Color(hex: "#87F1FB"), Color(hex: "#DBE2EB")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .offset(x: shineOffset, y: 0)
                .blur(radius: 20)
                .animation(Animation.linear(duration: 2).repeatForever(autoreverses: true))
                  )
                .frame(width: 200, height: 200)
              
                 
        }.edgesIgnoringSafeArea(.all)
        .onAppear {
            shineOffset = 300
        }
    }
}

struct Circle3_Previews: PreviewProvider {
    static var previews: some View {
        Circle3()
    }
}

