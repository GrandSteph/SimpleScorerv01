//
//  ScoreCell.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ScoreCell: View {
    
    var playerScore: PlayerScore
    
    @Binding var showPointsCapture: Bool
    @Binding var playerScoreForEdit: PlayerScore

   
    var body: some View {
        VStack {
            
            Group {
                CircleImage(image: Image(playerScore.player.photoURL))
                    .padding(5)
                    .frame(minHeight: 80, maxHeight: 120)
                
                Text(playerScore.player.shortName)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color .white)
            } // Icone + Nom
            
            Group {
                Text(String(playerScore.totalScore()))
                    .foregroundColor(Color .white)
                    .font(.system(size: 60))
                    .fontWeight(.regular)
                    .padding(.vertical)
                    .minimumScaleFactor(0.4)
                    .lineLimit(1)
                    .frame( height: 120)
                    .padding(5)
            } // SCORE
            
            Spacer()
            
            Points(points: playerScore.pointsList)
            
            Group {
                Button(action: {
                    self.showPointsCapture.toggle()
                    self.playerScoreForEdit = self.playerScore
                }) {
                    Text("+").foregroundColor(.black).font(.system(size: 40))
                }
                .padding()
                .background(Color(.white))
                .opacity(0.5)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                .shadow(radius: 5)
            } // picker
            

        }
        .padding(.vertical, 30)
        .frame(maxWidth: .infinity)
        .background(playerScore.player.favoriteColor)
    }
}

struct ScoreCell_Previews: PreviewProvider {
        
    static var previews: some View {
        ScoreCell(
            playerScore: PlayerScore(player: Player(name: "Stephane", shortName: "Steph", photoURL:"steph", color: .orange),pointsList: [])
            ,showPointsCapture: .constant(false)
            ,playerScoreForEdit: .constant(PlayerScore(player: Player(name: "Stephane", shortName: "Steph", photoURL:"steph", color: .orange),pointsList: []))
        )
//            .environmentObject(Game())
//            .previewLayout(.fixed(width: 100, height: 800))
    }
}
