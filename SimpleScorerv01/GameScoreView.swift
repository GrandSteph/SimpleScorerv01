//
//  ContentView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct GameScoreView: View {
    
    @EnvironmentObject var game: Game
    
    @State private var shouldScroll = false
    @State private var showPointsCapture = false
    @State private var playerScoreToEdit = PlayerScore.ID()
    
    private var axes: Axis.Set {
        return shouldScroll ? .horizontal : []
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(self.axes) {
                    HStack(spacing: 0)  {
                        ForEach(self.game.playerScores) { playerScore in
                            ScoreCell(playerScore: playerScore, showPointsCapture: self.$showPointsCapture, playerScoreToEditID: self.$playerScoreToEdit)
                                .frame(minWidth: 60, maxWidth: .infinity)
                        }
                    }
                    .background(Color.white)
                    .edgesIgnoringSafeArea(.all)
                }

  
                .overlay(
                    Rectangle()
                        .opacity(self.showPointsCapture ? 0.4 : 0)
                )
                    .blur(radius: self.showPointsCapture ? 10 : 0)
                
                
                if self.showPointsCapture {
//                    PointsCapture(isPresented: self.$showPointsCapture, playerScoreID:self.playerScoreToEdit)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
////                        .background(Color .white.opacity(0.5))
//                        .shadow(radius: 35)
                    
                    Neumorphism()


                }
            }
            .background(Color .gray)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameScoreView().environmentObject(Game())
                .previewDevice("iPad Air 2")
            GameScoreView().environmentObject(Game())
                .previewDevice("iPhone 7")
        }
        
    }
}
