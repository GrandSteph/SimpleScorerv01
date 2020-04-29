//
//  AddPlayerView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/27/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI



struct AddPlayerView: View {
    
    @Binding var game : Game
    
    enum Stage {
        case
        collapsed ,
        atNameEntry ,
        atPictureChoice ,
        done
    }
    
    @State private var stage = Stage.collapsed
    @State private var username: String = "Steph"
    
    let frameHeight = CGFloat(135)
    
    var body: some View {
        ZStack {

                if stage == .collapsed {
                    Button(action: {
                        self.stage = .atNameEntry
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 30))
                            .foregroundColor(Color.white)
                            .padding(15)
                            .contentShape(Rectangle())
                            .background(Color.orangeStart)
                            .clipShape(Rectangle()).cornerRadius(14)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                    }
                } else if stage == .atNameEntry {
                    
                    LinearGradient(Color.orangeStart, Color.orangeEnd)
                    
                    TextField("name", text: $username, onCommit: {self.stage = .atPictureChoice})
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.default)
                    
                    
                } else if stage == .atPictureChoice {
                    
                    LinearGradient(Color.orangeStart, Color.orangeEnd)
                    
                    HStack () {
                        Button(action: {
                            self.game.addPlayer(player: Player(name: self.username, shortName: self.username, photoURL: "steph", color: .orange, colorStart: .orangeStart, colorEnd: .orangeEnd))
                            self.stage = .collapsed
                        }) {
                            AvatarView(imageURL: "steph", name: "steph")
                                                       .padding(10)
                                                       .frame(width: frameHeight, height: frameHeight/2)
                        }
                        Text(self.username)
                            .fontWeight(.semibold)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(Color .offWhite)
                        
                        Spacer()
                    }
                    
                }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 135)
        .clipShape(Rectangle()).cornerRadius(14)
        .opacity(1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct AddPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayerView(game: .constant(Game()))
    }
}
