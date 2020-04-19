//
//  ScoreCardView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/17/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ScoreCardView: View {
    
    @EnvironmentObject var game : Game
    
    var playerScore: PlayerScore
    
    private var scoreIndex: Int {
        game.playerScores.firstIndex(where: { $0.id == playerScore.id})!
    }
    
    @State private var pointsScored = CGFloat(0)
    @State private var editing = false
    @State private var showWheel = false
    
    var body: some View {
        
        ZStack {
            LinearGradient(playerScore.player.colorStart, playerScore.player.colorEnd)
            
            VStack (alignment: .leading, spacing: 0){
                //                Spacer()
                
                HStack (alignment: .center, spacing: 0) {
                    
                    Image(uiImage: UIImage(named: self.playerScore.player.photoURL) ?? UIImage(systemName: "person")!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .padding(10.0)
                    
                    VStack (alignment: .leading, spacing: 0) {
                        Text(self.playerScore.player.shortName)
                            .fontWeight(.semibold)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(Color .offWhite)
                        
                        Text(String(self.game.ranking(for: self.playerScore.player)))
                            .fontWeight(.semibold)
                            .font(.system(.body, design: .rounded))
                            .foregroundColor(Color .offWhite)
                        
                    }
                    
                    Spacer()
                    
                    Group {
                        Text("\(self.playerScore.totalScore())")
                            .font(Font.system(size: 50, weight: .bold, design: .rounded))
                            //                        .minimumScaleFactor(0.4)
                            //                        .lineLimit(1)
                            .foregroundColor(Color .offWhite)
                            //                        .padding(editing ? .leading : .trailing,40)
                            .offset(x: editing ? -10 : -25, y: 0)
                        
                        if editing {
                            //                        Spacer()
                            
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
                                
                            }//.offset(x: 0, y: 4)
                        }
                    }.layoutPriority(1)
                    
                    
                }.frame(maxHeight: 100)
                
                Spacer()
                
                HStack (spacing: 0) {
                    //                    if !showWheel {
                    
                    Button(action: {
                        self.editing = true
                        self.pointsScored -= 1
                    }) {
                        Image(systemName: "minus.rectangle")
                            .foregroundColor(.purpleStart)
                    }
                    .buttonStyle(SimpleRectButtonStyle())
                    
                    Button(action: {
                        self.editing = false
                        self.game.playerScores[self.scoreIndex].addPoints(scoreValue: Int(self.pointsScored))
                        self.pointsScored = 0
                    }) {
                        ClickWheel(isPresented: self.$editing, playerScore: self.playerScore, pointScored: self.$pointsScored, wheelColor: Color .purpleStart)
                            .frame(maxWidth:.infinity, maxHeight: 47)
                    }
                    
                    
                    
                    Button(action: {
                        self.editing = true
                        self.pointsScored += 1
                    }) {
                        Image(systemName: "plus.rectangle")
                            .foregroundColor(.purpleStart)
                    }
                    .buttonStyle(SimpleRectButtonStyle())
                    //                    } else {
                    //
                    //                        ClickWheel(isPresented: self.$showWheel, playerScore: self.playerScore, pointScored: self.$pointsScored, wheelColor: Color .purpleStart)
                    //                        .padding()
                    //                            .background(Color .white)
                    //
                    //                    }
                }
                
                
                //
                
                
                
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: showWheel ? 400 : 135)
        .clipShape(Rectangle()).cornerRadius(14)
        .opacity(1)
            //            .offset(x: 0, y: -20)
            .padding(.horizontal, 25.0)
            .padding(.bottom, 15)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
    
}

struct SimpleRectButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Rectangle())
            .frame(maxWidth:.infinity, maxHeight: 47)
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
        ScoreCardView(playerScore: PlayerScore(player: Player(),pointsList: [])).environmentObject(Game())
    }
}


