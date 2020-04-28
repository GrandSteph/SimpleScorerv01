//
//  CircleImage.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    var player: Player
    
    @ViewBuilder
    var body: some View {
        
        if UIImage(named: self.player.photoURL) != nil {

            Image(self.player.photoURL)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())

            //                .overlay(Circle().strokeBorder(Color.white, lineWidth: 4))
        } else {
            Button(action: {
                
            }) {

                    Text(String(self.player.name.uppercased().prefix(1)))
                        .fontWeight(.regular)
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color.white)
                        .padding()
                        .contentShape(Circle())
                        .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))

            }
            
            
        }
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(player: Player(name: "Steph", shortName: "Steph", photoURL: "s teph", color: Color.orange, colorStart: Color.orangeEnd, colorEnd: Color.orangeStart))
            .background(Color.orangeEnd)
            .previewLayout(.fixed(width: 200, height: 300))
        
    }
}
