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
    
    var body: some View {
        
        ZStack {
            LinearGradient(playerScore.player.colorStart, playerScore.player.colorEnd)
            
            VStack (alignment: .leading, spacing: 0){
                
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
                        
//                        Text(String(self.game.ranking(for: self.playerScore)))
//                            .fontWeight(.semibold)
//                            .font(.system(.body, design: .rounded))
//                            .foregroundColor(Color .offWhite)
                        
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
                    
                    
                }.frame(maxHeight: 100)
                
                Spacer()
                
                ScoreEntryRow(editing: self.$editing, playerScore: self.$playerScore, pointsScored: self.$pointsScored)
                
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 135)
        .clipShape(Rectangle()).cornerRadius(14)
        .opacity(1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct ScoreEntryRow: View {
    
    @Binding var editing : Bool
    @Binding var playerScore: PlayerScore
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
            
            ClickWheel(editing: self.$editing, playerScore: self.$playerScore, pointsScored: self.$pointsScored, wheelColor: Color .purpleStart)
                .frame(maxWidth:.infinity, maxHeight: 47)
            
            Button(action: {
                self.editing = true
                self.pointsScored += 1
            }) {
                Image(systemName: "plus.rectangle")
                    .foregroundColor(.purpleStart)
            }
            .buttonStyle(SimpleRectButtonStyle())
        }
    }
}

struct ScoreCardView_Previews: PreviewProvider {

    static var previews: some View {
           return BindingProvider(Game()) { binding in
            ScoreCardView(playerScore: binding.playerScores[0])
           }
       }
}
