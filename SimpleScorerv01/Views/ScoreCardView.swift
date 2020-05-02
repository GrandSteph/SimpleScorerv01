//
//  ScoreCardView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/17/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ScoreCardView: View {
    
    @Binding var playerScore: PlayerScore
    
    @State private var pointsScored = CGFloat(0)
    @State private var editing = false
    
    let frameHeight = CGFloat(135)
    
    var body: some View {
        
        ZStack {
            LinearGradient(playerScore.player.colorStart, playerScore.player.colorEnd)
            
            VStack (alignment: .leading, spacing: 0){
                
                HStack (alignment: .center, spacing: 0) {
                    
                    AvatarView(name: playerScore.player.name, image: playerScore.player.photoImage)
                        .padding(10)
                        .frame(width: frameHeight*2/3, height: frameHeight*2/3)
                    
                    VStack (alignment: .leading, spacing: 0) {
                        Text(self.playerScore.player.name)
                            .fontWeight(.semibold)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(Color .offWhite)
                    }
                    
                    Spacer()
                    
                    Group {
                        Text("\(self.playerScore.totalScore())")
                            .font(Font.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(Color .offWhite)
                            .offset(x: editing ? -10 : -25, y: 0)
                        
                        if editing {
                            
                            VStack {
                                Text("\(self.pointsScored >= 0 ? "+" : "-") \( String(format: "%.0f",abs(self.pointsScored)))")
                                    .layoutPriority(1)
                                    .font(Font.system(size: 35, weight: .bold, design: .rounded))
                                    .foregroundColor(Color .offWhite)
                                    .padding(.trailing, 10)
                                
                                
                                Text("= \( String(format: "%.0f",CGFloat(self.playerScore.totalScore()) + self.pointsScored))")
                                    .font(Font.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundColor(Color .offWhite)
                                    .padding(.trailing, 20)
                                
                            }
                        }
                    }.layoutPriority(1)
                    
                    
                }
                
                HStack (spacing: 0) {
                    
                    Button(action: {
                        self.playerScore.addPoints(scoreValue: -1)
                    }) {
                        Image(systemName: "minus.rectangle")
                            .foregroundColor(.purpleStart)
                    }
                    .buttonStyle(SimpleRectButtonStyle())
                    
                    ClickWheel(editing: self.$editing, playerScore: self.$playerScore, pointsScored: self.$pointsScored, wheelColor: Color .purpleStart)
                    
                    Button(action: {
                        self.playerScore.addPoints(scoreValue: 1)
                    }) {
                        Image(systemName: "plus.rectangle")
                            .foregroundColor(.purpleStart)
                    }
                    .buttonStyle(SimpleRectButtonStyle())
                }
                .frame(height: frameHeight/3)

                    
                    
                
            }
        }
        .frame(height: frameHeight)
        .clipShape(Rectangle()).cornerRadius(14)
        .opacity(1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct SimpleRectButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .border(Color.offWhite, width: 1)
            .background(
                Group {
                    if configuration.isPressed {
                        Rectangle()
                            .fill(Color.gray)
                    } else {
                        Rectangle()
                            .fill(Color.white)
                    }
                }
        )
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            BindingProvider(PlayerScore(player: Player(name: "Steph", colorStart: .orangeStart, colorEnd: .orangeEnd), pointsList: [])) { binding in
                ScoreCardView(playerScore: binding)
                    .previewLayout(.fixed(width: 375, height: 300))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
            }
//            BindingProvider(PlayerScore(player: Player(name: "Steph", shortName: "Step", photoURL: "st eph", color: Color.black, colorStart: .orangeStart, colorEnd: .orangeEnd), pointsList: [])) { binding in
//                ScoreCardView(playerScore: binding)
//                    .previewLayout(.fixed(width: 375, height: 300))
//                    .padding(.horizontal, 15)
//                    .padding(.bottom,15)
//            }
        }
        
    }
}
