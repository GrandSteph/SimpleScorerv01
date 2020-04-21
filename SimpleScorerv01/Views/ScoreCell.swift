//
//  ScoreCell.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ScoreCell: View {
    
    @State var game : Game
    
    var playerScore: PlayerScore
    
    @Binding var showPointsCapture: Bool
    @Binding var playerScoreToEdit: PlayerScore?
    
    var scoreScaleFactor : CGFloat {
        abs(1 / (1 + (CGFloat(String(game.maxScore()).count) - CGFloat(String(self.playerScore.totalScore()).count))/1.2))
        //                ((CGFloat(String(self.playerScore.totalScore()).count)))/CGFloat(String(game.maxScore()).count)
        //        switch (String(self.playerScore.totalScore()).count) {
        //        case 1:
        //            return 1/2 // 2
        //        case 2:
        //            return 1/1.5 // 1
        //        case 3:
        //            return 1 // 0
        //        default:
        //            return 1
        //        }
    }
    
    var body: some View {
        GeometryReader{ g in
            VStack {
                Spacer(minLength: 20)
                Group {
                    
                    CircleImage(name: self.playerScore.player.photoURL)
                        .padding(5)
                        .frame(minWidth: g.size.width, minHeight: g.size.width)
                        
                    
                    Text(self.playerScore.player.shortName)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(Color .white)
                }
                
                
                
                Text(String(self.playerScore.totalScore()))
                    .foregroundColor(Color .white)
                    .font(.system(size: 200, weight: .bold, design: .rounded) )
                    .lineLimit(1)
                    .minimumScaleFactor(0.1)
                    //                    .layoutPriority(1)
                    .padding(.horizontal, 10)
                    .frame(width: g.size.width, height: g.size.width, alignment: .center)
                    .scaleEffect(self.scoreScaleFactor)
                
                
                
                //                Spacer()
                ScrollView (.vertical) {
                    Points(points: self.playerScore.pointsList)
                }
                
                
                
                Button(action: {
                    self.playerScoreToEdit = self.playerScore
                    self.showPointsCapture.toggle()
                }) {
                    Text("+").foregroundColor(.black).font(.system(size: 40))
                }
                .padding()
                .background(Color(.white))
                .opacity(0.5)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 5)
                
                
                
            }
            .padding(.vertical, 30)
            .frame(maxWidth: .infinity)
//            .background(self.playerScore.player.color)
        }
    }
}

struct ScoreCell_Previews: PreviewProvider {
    
    
    static var previews: some View {
        let game = Game()
        
        return ScoreCell(
            game: game, playerScore: game.playerScores[0]
            ,showPointsCapture: .constant(false)
            ,playerScoreToEdit: .constant(game.playerScores[0])
        )
    }
}
