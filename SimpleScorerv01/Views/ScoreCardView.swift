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
    
    @State private var pointsScored = Int(0)
    @State private var editing = false
    
    @State private var offSetNewPoints = CGFloat(70)
    
    //    @Binding var showPointsCapture: Bool
    //    @Binding var playerScoreToEdit: PlayerScore?
    
    var body: some View {
        ZStack{
            //            Image("backgroundMockup").resizable().scaledToFit().edgesIgnoringSafeArea(.all)
            
            ZStack {
                LinearGradient(playerScore.player.colorStart, playerScore.player.colorEnd)
                
                
                
                VStack (alignment: .leading, spacing: 0){
                    //                    Spacer()
                    
                    HStack {
                        Image(uiImage: UIImage(named: self.playerScore.player.photoURL) ?? UIImage(systemName: "person")!)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .padding(12.0)
                        
                        VStack (alignment: .leading, spacing: 0) {
                            Text(self.playerScore.player.shortName)
                                .fontWeight(.semibold)
                                .font(.system(.largeTitle, design: .rounded))
                                .foregroundColor(Color .offWhite)
                            Text("#1")
                                .fontWeight(.semibold)
                                .font(.system(.body, design: .rounded))
                                .foregroundColor(Color .offWhite)
                        }.offset(x: -12, y: 0)
                        
                        Spacer()
                        
                        
                        
           
                            Text("\(self.playerScore.totalScore())")
                                                        .font(Font.system(size: 50, weight: .bold, design: .rounded))
                                                        .foregroundColor(Color .offWhite)
                            //                            .padding(.trailing, 5)
                        if editing {
                            VStack {
                                    Text("\(self.pointsScored >= 0 ? "+" : "-") \(abs(self.pointsScored))")
                                    .font(Font.system(size: 35, weight: .bold, design: .rounded))
                                    .foregroundColor(Color .offWhite)
                                        .padding(.trailing, 20)
                                        
                                    
                                    
                                    Text("= \(self.playerScore.totalScore() + self.pointsScored)")
                                    .font(Font.system(size: 10, weight: .bold, design: .rounded))
                                    .foregroundColor(Color .offWhite)
                                        .padding(.trailing, 20)
                                        
                            }.offset(x: 0, y: 4)
                        } else {
                            Rectangle().frame(width: 40, height: 0)
                        }
                            
                        
                        
                    }
                    
                    
                    HStack (spacing: 0) {
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
                            self.game.playerScores[self.scoreIndex].addPoints(scoreValue: self.pointsScored)
                            self.pointsScored = 0
                        }) {
                            Image(systemName: "dot.square")
                                .foregroundColor(.purpleStart)
                        }
                        .buttonStyle(SimpleRectButtonStyle())
                        
                        Button(action: {
                            self.editing = true
                            self.pointsScored += 1
                        }) {
                            Image(systemName: "plus.rectangle")
                                .foregroundColor(.purpleStart)
                        }
                        .buttonStyle(SimpleRectButtonStyle())
                        
                    }
                        
                    .background(Color.blue)
                    
                }
                
                // copy layer
                
                
                
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 135, alignment: .center)
            .clipShape(Rectangle()).cornerRadius(14)
            .opacity(1)
                //            .offset(x: 0, y: -20)
            .padding(.horizontal, 25.0)
                .padding(.bottom, 15)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
        }//.background(Color.green)
    }
}

struct ScoreCardView_Previews: PreviewProvider {
    static var previews: some View {
        ScoreCardView(playerScore: PlayerScore(player: Player(name: "Stephane", shortName: "Steph", photoURL:"steph", color: .orange, colorStart: Color .cyan2, colorEnd: Color .cyan1),pointsList: [1,2])
            
        )
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
