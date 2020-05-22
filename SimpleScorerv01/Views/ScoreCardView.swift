//
//  ScoreCardView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/17/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI
//import Introspect

struct ScoreCardView: View {
    
    @Binding var playerScore: PlayerScore
    var size: CardSize
    var backGroundGradient: LinearGradient
    
    @State private var pointsScored = CGFloat(0)
    @State private var editing = false
    
    @State private var nameEditing = false
    @State private var username = ""
    
    var body: some View {
        
        var frameHeight : CGFloat {
            self.size == .compact ? CGFloat(90) : CGFloat(135)
        }
        
        return
            ZStack {
                
                self.playerScore.player.colorGradient
                
                VStack (alignment: .leading, spacing: 0){
                    
                    HStack (alignment: .center, spacing: 0) {
                        
                        AvatarView(user: $playerScore.player).padding(10).frame(maxWidth: self.size != .compact ? frameHeight*2/3 : frameHeight)
                        
                        PlayerNameView(editing: $editing, nameEditing: $nameEditing, playerScore: $playerScore, username: $username, backGroundGradient: backGroundGradient)

                        ExpandableScoreSection(editing: $editing, pointsScored: $pointsScored, playerScore: $playerScore)
                    }
                    .frame(height: self.size == .compact ? frameHeight : frameHeight*2/3)
                   
                    
                    if self.size != .compact {
                        ScoringBottomBarTools(frameHeight: frameHeight, editing: $editing, pointsScored: $pointsScored)
                    }
                }
            }
            .frame(height: frameHeight)
            .clipShape(Rectangle()).cornerRadius(14)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct ExpandableScoreSection: View {
    
    @Binding var editing : Bool
    @Binding var pointsScored : CGFloat
    @Binding var playerScore : PlayerScore
    
    var body: some View {
        
        Group {
            VStack {
                if editing {
                    ZStack {
                    
                     VStack {
                         Image(systemName: "xmark").foregroundColor(Color.white)
                             .padding()
                             .contentShape(Rectangle())
                         Spacer()
                     }
                }
                .frame(minWidth:40, maxWidth:40, maxHeight: .infinity)
                .onTapGesture {
                    self.pointsScored = 0
                    self.editing = false
                    }
                } else {
                    EmptyView()
                }
            }
            
            Spacer()
            
            Text("\(self.playerScore.totalScore())")
                .font(Font.system(size: 50, weight: .bold, design: .rounded))
                .lineLimit(1)
                .foregroundColor(Color .offWhite)
                .padding(.horizontal,self.editing ? 0 : 20)

            
            if editing {
                
                HStack {
                    
                    
                    VStack {
                        Text("\(self.pointsScored >= 0 ? "+" : "-") \( String(format: "%.0f",abs(self.pointsScored)))")
                            .font(Font.system(size: 25, weight: .bold, design: .rounded))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .foregroundColor(Color .offWhite)
                        
                        
                        Text("= \( String(format: "%.0f",CGFloat(self.playerScore.totalScore()) + self.pointsScored))")
                            .font(Font.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(Color .offWhite)
                        
                    }
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.black)
                            .opacity(0.05)
                        Rectangle().fill(Color.clear)
                            .border(width: 1, edge: .leading, color: .offWhite)
                        Image(systemName: "checkmark").foregroundColor(Color.white)
                    }
                    .frame(minWidth:40, maxWidth:40, maxHeight: .infinity)
                    .onTapGesture {
                        self.playerScore.addPoints(scoreValue: Int(String(format: "%.0f",self.pointsScored))!)
                        self.pointsScored = 0
                        self.editing = false
                    }
                }
            }
        }
    }
}

struct ScoringBottomBarTools: View {
    
    let frameHeight : CGFloat
    @Binding var editing : Bool
    @Binding var pointsScored : CGFloat
    
    var body: some View {
        HStack (spacing: 0) {
            
            Button(action: {
                self.editing = true
                self.pointsScored -= 1
            }) {
                Image(systemName: "minus.rectangle")
                    .foregroundColor(.purpleStart)
            }
            .buttonStyle(SimpleRectButtonStyle())
            
            ClickWheel(editing: self.$editing, pointsScored: self.$pointsScored, wheelColor: Color .purpleStart)
            
            Button(action: {
                self.editing = true
                self.pointsScored += 1
            }) {
                Image(systemName: "plus.rectangle")
                    .foregroundColor(.purpleStart)
            }
            .buttonStyle(SimpleRectButtonStyle())
        }
        .frame(height: frameHeight/3)
    }
}

struct PlayerNameView: View {
    
    @Binding var editing : Bool
    @Binding var nameEditing : Bool
    @Binding var playerScore : PlayerScore
    @Binding var username : String
    var backGroundGradient : LinearGradient
    
    var body: some View {
        Group {
            if !editing {
                if !self.nameEditing && self.playerScore.player.name != Player.defaultName {
                    Text(self.playerScore.player.name)
                        .fontWeight(.semibold)
                        .font(.system(.largeTitle, design: .rounded))
                        .lineLimit(1)
                        .foregroundColor(Color .offWhite)
                        .onTapGesture {
                            self.nameEditing = true
                    }
                } else {
                    TextField("Name?", text: self.$username, onCommit: {
                            self.nameEditing = false
                            self.playerScore.player.name = self.username
                            self.playerScore.player.colorGradient = self.backGroundGradient
                            self.username = ""
                    })
//                        .introspectTextField { textField in
//                            textField.becomeFirstResponder()
//                        }
                        .font(.system(.largeTitle, design: .rounded))
                        .background(Color.offWhite.opacity(0.6))
                        .foregroundColor(Color.offWhite)
                        .foregroundColor(Color .offWhite)
                }
            }
        }
        
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            BindingProvider(Game(withTestPlayers: ())) { binding in
                ScoreCardView(playerScore: binding.playerScores[0], size: .normal, backGroundGradient: gradiants[Int.random(in: 0 ..< 20)])
                    .previewLayout(.fixed(width: 375, height: 200))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
                
                ScoreCardView(playerScore: binding.playerScores[1], size: .compact, backGroundGradient: gradiants[Int.random(in: 0 ..< 20)])
                                   .previewLayout(.fixed(width: 375, height: 200))
                                   .padding(.horizontal, 15)
                                   .padding(.bottom,15)
                
                ScoreCardView(playerScore: binding.playerScores[2], size: .normal, backGroundGradient: gradiants[Int.random(in: 0 ..< 20)])
                                   .previewLayout(.fixed(width: 375, height: 200))
                                   .padding(.horizontal, 15)
                                   .padding(.bottom,15)
                
                ScoreCardView(playerScore: binding.playerScores[3], size: .compact, backGroundGradient: gradiants[Int.random(in: 0 ..< 20)])
                .previewLayout(.fixed(width: 375, height: 100))
                .padding(.horizontal, 15)
                .padding(.bottom,15)
            }
        }
    }
}
