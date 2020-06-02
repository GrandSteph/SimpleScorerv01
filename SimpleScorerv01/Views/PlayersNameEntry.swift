//
//  PlayersNameEntry.swift
//  SimpleScorerv01
//
//  Created by Dev on 6/2/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct PlayersNameEntry: View {
    
    @Binding var game : Game
    @State private var isVisible = false
    @State private var username : String = ""
    
    let gradients = gradiants.shuffled()
    
    var frameHeight = CGFloat(90)
    
    var body: some View {
        
        ZStack {
            ForEach(game.playerScores.indices) { i in
                
                //                Text(self.game.playerScores[i].player.name)
                
                if self.game.playerScores[i].player.name == Player.defaultName {
                    ZStack {
                        
                        self.gradients[i]
                        
                        VStack {
                            HStack {
                                
                                AvatarView(user: self.$game.playerScores[i].player)
                                    .padding(10)
                                    .frame(width: self.frameHeight)
                                
                                TextField("Player #\(i)", text: self.$username,onEditingChanged: {change in }, onCommit: {
                                    
                                })
                                    .introspectTextField { textField in
                                        self.isVisible = true
                                        self.game.playerScores[i].player.colorGradient = self.gradients[i]
                                }
                                .font(.system(.largeTitle, design: .rounded))
                                .background(Color.offWhite.opacity(0.6))
                                .foregroundColor(Color.offWhite)
                                .foregroundColor(Color .offWhite)
                                
                                Rectangle().fill(Color.clear)
                                    .border(width: 1, edge: .leading, color: .offWhite)
                                    .overlay(Image(systemName: "chevron.right").foregroundColor(Color.white))
                                    .frame(minWidth:60, maxWidth:60, maxHeight: .infinity)
                                    .onTapGesture {

                                }
                            }
                        }
                    }
                    .frame(height: self.frameHeight)
                    .clipShape(Rectangle()).cornerRadius(14)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
            }
        }
        .padding()
    }
}

struct PlayersNameEntry_Previews: PreviewProvider {
    static var previews: some View {
        BindingProvider(Game(withTestPlayers: ())) { binding in
            PlayersNameEntry(game: binding)
        }
        
    }
}
