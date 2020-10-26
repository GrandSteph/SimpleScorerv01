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
    
    @EnvironmentObject var game : Game
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    var playerScore: PlayerScore
    
    @State private var pointsScored = CGFloat(0)
    @State private var scoreEditing = false
    
    @State private var nameEditing = false
    @State private var username = ""
    
    let frameHeight = CGFloat(135)
    @State private var showBottomBar = false
    
    @State private var dragOffset = CGSize.zero
//    @State private var dragOffset = CGSize(width: -180, height: 0)
    
    var index : Int
    
    var body: some View {
        
        return
            ZStack {
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        self.game.removePlayer(player: self.playerScore.player)
                        self.dragOffset = CGSize.zero
                        self.displayInfo.setSizeAndScroll(nbrPlayers: self.game.playerScores.count)
                    }) {
                        Image(systemName: "trash.circle")
                            .font(.system(size: 45, weight: .light, design: .default))
                            .foregroundColor(Color.red)
                            .padding()
                            .contentShape(Rectangle()).frame(height: self.frameHeight*2/3)
                    }
//                    Button(action: {
//                        self.dragOffset = CGSize.zero
//                    }) {
//                        Image(systemName: "pencil.circle")
//                            .font(.system(size: 45, weight: .light, design: .default))
//                            .foregroundColor(Color.gray)
//                            .padding()
//                            .contentShape(Rectangle()).frame(height: self.frameHeight*2/3)
//                    }
                }
                
                ZStack {
                    
                    
                    
                    self.playerScore.player.colorGradient.frame(height: self.showBottomBar || self.displayInfo.scoreCardSize == .normal ? frameHeight : frameHeight*2/3)
                    
                    VStack (spacing: 0){
                        
                        HStack (alignment: .center, spacing: 0) {
                            AvatarView(user: playerScore.player)
                                .padding(10)
                                .frame(width: frameHeight*2/3)
                            
                            PlayerNameView(scoreEditing: $scoreEditing, nameEditing: $nameEditing, playerScore: playerScore, username: $username, indexOfScoreCard: index)
                            
                            ExpandableScoreSection
                        }
                        .frame(height: frameHeight*2/3)
                        
                        if self.showBottomBar || self.displayInfo.scoreCardSize == .normal {
                            ScoringBottomBarTools
                                .frame(height: frameHeight/3)
                                .disabled(self.dragOffset.width != 0)
                        }
                    }
                }
                .clipShape(Rectangle()).cornerRadius(14)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                .offset(self.dragOffset)
                .animation(.easeOut).transition(.slide)
            }
            .onTapGesture {
                self.scoreEditing = true
                self.showBottomBar = true
                self.dragOffset.width = 0
            }
            .gesture(
                DragGesture(minimumDistance: 25, coordinateSpace: .local)
                    .onChanged({ (value) in
                        if !self.scoreEditing {
                            self.dragOffset.width = value.translation.width
                        }
                    })
                    .onEnded({ (value) in
                        if value.translation.width < -90 && !self.scoreEditing {
                            self.dragOffset.width = -75
                        } else {
                            self.dragOffset = CGSize.zero
                        }
                    }))
        
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
                        
                        if self.displayInfo.scoreCardSize == .compact {
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
                .padding(.horizontal,self.scoreEditing ? 0 : 20)
            
            
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
                        
                    }
                    
                    
                Rectangle().fill(Color.offWhite.opacity(0.5))
                        .border(width: 1, edge: .leading, color: .offWhite)
                        .overlay(Image(systemName: "checkmark").foregroundColor(Color.white))
                        .frame(minWidth:70, maxWidth:70, maxHeight: .infinity)
                        .onTapGesture {
//                            let index = self.game.playerScores.firstIndex(where: {$0.id == self.playerScore.id})!
//                            self.game.playerScores[index].addPoints(scoreValue: Int(String(format: "%.0f",self.pointsScored))!)
                            self.game.addPointsFor(player: self.playerScore.player, points: Int(String(format: "%.0f",self.pointsScored))!)
                            self.pointsScored = 0
                            self.scoreEditing = false
                            if self.displayInfo.scoreCardSize == .compact {
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
    @EnvironmentObject var game : Game
    
    @Binding var scoreEditing : Bool
    @Binding var nameEditing : Bool
    var playerScore : PlayerScore
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
                        .onLongPressGesture {
                            self.nameEditing = true
                        }
                } else {
                    TextField("Name?", text: self.$username,onEditingChanged: {change in }, onCommit: {
                        
                        
                        if self.username.count == 0 {
                            self.showingAlert = true
                        } else {
                            
                            self.nameEditing = false
                            let index = self.game.playerScores.firstIndex(where: {$0.id == self.playerScore.id})!
                            self.game.playerScores[index].player.name = self.username
                            self.game.playerScores[index].player.initials = self.game.avatarInitialsForPlayer(player: self.game.playerScores[index].player)
                            
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
        
        
        if self.displayInfo.screenDisplayed == .gameSetup {
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

            ScoreCardView(playerScore: PlayerScore(player: Player(name: "Steph", initials: "St", colorGradient: LinearGradient.gradDefault), pointsList: []),index: 1)
                    .previewLayout(.fixed(width: 375, height: 200))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
                

        }
        .environmentObject(Game())
        .environmentObject(GlobalDisplayInfo())
    }
}
