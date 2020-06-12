//
//  ScoreCardView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/17/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI
import Introspect

struct ScoreCardView: View {
    
    @Binding var playerScore: PlayerScore
    var size: CardSize
    
    @State private var pointsScored = CGFloat(0)
    @State private var scoreEditing = false
    
    @State private var nameEditing = false
    @State private var username = ""
    
    @State private var frameHeight = CGFloat(90)
    @State private var showBottomBar = false
    
    var index : Int
    
    var body: some View {
        
        return
            ZStack {
                
                self.playerScore.player.colorGradient
                
                VStack (spacing: 0){
                    
                    HStack (alignment: .center, spacing: 0) {
                        
                        AvatarView(user: $playerScore.player)
                            .padding(10)
                            .frame(width: self.showBottomBar ? frameHeight*2/3 : frameHeight)
                        
                        PlayerNameView(scoreEditing: $scoreEditing, nameEditing: $nameEditing, playerScore: $playerScore, username: $username, indexOfScoreCard: index)

                        ExpandableScoreSection
                            .onTapGesture {
                                self.scoreEditing = true
                                self.frameHeight = CGFloat(135)
                                self.showBottomBar = true
                        }
                        

                    }
                    .frame(height:  self.showBottomBar ? frameHeight*2/3 : frameHeight)
                    
                    
                    if self.showBottomBar {
                        ScoringBottomBarTools.animation(.easeOut).transition(.slide)
                    }
                }
            }
            .frame(height: frameHeight)
            .clipShape(Rectangle()).cornerRadius(14)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            .onAppear {
                if self.size == .normal {
                    self.frameHeight = CGFloat(135)
                    self.showBottomBar = true
                }
        }
    
    }
    
    var ExpandableScoreSection: some View {
        Group {
            VStack {
                if scoreEditing {
                    VStack {
                        Image(systemName: "xmark").foregroundColor(Color.white)
                            .padding()
                            .contentShape(Rectangle())
                        Spacer()
                    }
                    .frame(minWidth:20, maxWidth:20, maxHeight: .infinity)
                    .onTapGesture {
                        self.pointsScored = 0
                        self.scoreEditing = false
                        
                        if self.size == .compact {
                            self.frameHeight = CGFloat(90)
                            self.showBottomBar = false
                        }
                    }
                }
            }
            
            Spacer()
            
            Text("\(self.playerScore.totalScore())")
                .font(Font.system(size: fontSize(nbrChar: String(self.playerScore.totalScore()).count, fontSize: 50), weight: .bold, design: .rounded))
                .lineLimit(1)
            .layoutPriority(1)
                .foregroundColor(Color .offWhite)
                .padding(.horizontal,self.scoreEditing ? 0 : 20).animation(.none)
            
            
            if scoreEditing {

                    VStack {
                        Text("\(self.pointsScored >= 0 ? "+" : "-") \( String(format: "%.0f",abs(self.pointsScored)))")
                            .font(Font.system(size: 25, weight: .bold, design: .rounded))
                            .lineLimit(1)
                            .foregroundColor(Color .offWhite)
                            .padding(.trailing,10)
                        
                        
                        Text("= \( String(format: "%.0f",CGFloat(self.playerScore.totalScore()) + self.pointsScored))")
                            .font(Font.system(size: 10, weight: .bold, design: .rounded))
                            .foregroundColor(Color .offWhite)
                        
                    }.animation(.none)
                    
                    
                    Rectangle().fill(Color.clear)
                        .border(width: 1, edge: .leading, color: .offWhite)
                        .overlay(Image(systemName: "checkmark").foregroundColor(Color.white))
                        
                        
                        .frame(minWidth:40, maxWidth:40, maxHeight: .infinity)
                        .onTapGesture {
                            self.playerScore.addPoints(scoreValue: Int(String(format: "%.0f",self.pointsScored))!)
                            self.pointsScored = 0
                            self.scoreEditing = false
                            if self.size == .compact {
                                self.frameHeight = CGFloat(90)
                                self.showBottomBar = false
                            }
                    }
            }
        }
    }
    
    var ScoringBottomBarTools: some View {
        HStack (spacing: 0) {
            
            Button(action: {
                self.scoreEditing = true
                self.pointsScored -= 1
            }) {
                Image(systemName: "minus.rectangle")
                    .foregroundColor(.purpleStart)
            }
            .buttonStyle(SimpleRectButtonStyle())
            
            ClickWheel(editing: self.$scoreEditing, pointsScored: self.$pointsScored, wheelColor: Color .purpleStart)
            
            Button(action: {
                self.scoreEditing = true
                self.pointsScored += 1
            }) {
                Image(systemName: "plus.rectangle")
                    .foregroundColor(.purpleStart)
            }
            .buttonStyle(SimpleRectButtonStyle())
        }
    }
    
    func fontSize(nbrChar :Int, fontSize :Int) -> CGFloat {
        
        if nbrChar <= 3 { return CGFloat(fontSize)}
        
        return self.scoreEditing ? CGFloat(fontSize - (nbrChar-2)*10 ) : CGFloat(fontSize - (nbrChar-3)*10)
    }
}



struct PlayerNameView: View {
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    @Binding var scoreEditing : Bool
    @Binding var nameEditing : Bool
    @Binding var playerScore : PlayerScore
    @Binding var username : String
    
    @State private var showingAlert = false
    
    var indexOfScoreCard : Int
    
    var body: some View {
        Group {
            if !scoreEditing {
                if !self.nameEditing && self.playerScore.player.name != Player.defaultName {
                    Text(self.playerScore.player.name)
                        .font(Font.system(size: fontSize(nbrChar: self.playerScore.player.name.count, fontSize: 40), weight: .semibold, design: .rounded))
                            .lineLimit(1)
                        .foregroundColor(Color .offWhite)
                        .onTapGesture {
                            self.nameEditing = true
                    }
                } else {
                    TextField("Name?", text: self.$username,onEditingChanged: {change in }, onCommit: {
                        
                        
                        if self.username.count == 0 {
                            self.showingAlert = true
                        } else {
                            
                            self.nameEditing = false
                            self.playerScore.player.name = self.username
                            
                            self.username = ""
                            self.displayInfo.indexOFTextfieldFocused += 1
                        }
                        
                        
                    })
                        .introspectTextField { textField in
                            if self.shouldBecomeFirstResponder() && !textField.isFirstResponder {
                                textField.becomeFirstResponder()
                            }
                        }
                        .font(.system(.largeTitle, design: .rounded))
                        .background(Color.offWhite.opacity(0.6))
                        .foregroundColor(Color.offWhite)
                        .foregroundColor(Color .offWhite)
                }
            }
        }.alert(isPresented: $showingAlert) {
            Alert(title: Text("No name entered"), message: Text("Please enter a name"), dismissButton: .default(Text("OK")))
        }
    }
    
    func fontSize(nbrChar :Int, fontSize :Int) -> CGFloat {
        
        if nbrChar <= 5 { return CGFloat(fontSize)}
        
        return CGFloat(fontSize - (nbrChar-5)*7 )
    }
    
    func shouldBecomeFirstResponder() -> Bool {
        
        
        if self.displayInfo.isGameSetupVisible {
            if self.indexOfScoreCard < self.displayInfo.indexOFTextfieldFocused {
                self.displayInfo.indexOFTextfieldFocused = self.indexOfScoreCard
            }
            return false
        }
        
        if self.nameEditing {
            return true
        }
        
        return false
        
//        if self.playerScore.player.name == Player.defaultName {
//            if self.indexOfScoreCard == self.displayInfo.indexOFTextfieldFocused {
//                return true
//            } else {
//                return false
//            }
//        } else {
//            return false
//        }
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            BindingProvider(Game(withTestPlayers: ())) { binding in
                ScoreCardView(playerScore: binding.playerScores[0], size: .normal, index: 1)
                    .previewLayout(.fixed(width: 375, height: 200))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
                
                ScoreCardView(playerScore: binding.playerScores[1], size: .compact, index: 1)
                    .previewLayout(.fixed(width: 375, height: 200))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
                
                ScoreCardView(playerScore: binding.playerScores[2], size: .normal, index: 1)
                    .previewLayout(.fixed(width: 375, height: 200))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
                
                ScoreCardView(playerScore: binding.playerScores[3], size: .compact, index: 1)
                    .previewLayout(.fixed(width: 375, height: 100))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
            }
        }
    }
}
