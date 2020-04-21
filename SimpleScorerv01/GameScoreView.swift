//
//  ContentView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct GameScoreView: View {
    
    @State private var game = Game()
    private var playerScore: PlayerScore?
    @State private var shouldScroll = false
    
    private var axes: Axis.Set {
        return shouldScroll ? .vertical : []
    }
    
    var body: some View {

        
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            ScrollView(self.axes) {
                VStack()  {
                    ForEach(self.game.playerScores) { playerScore in

                        ScoreCardView(game:self.$game, playerScore: playerScore)
                    }
                    
//                    Button(action: {
//                        self.game.addPlayer(player: Player())
//                    }) {
//                        Image(systemName: "plus.rectangle")
//                            .foregroundColor(.purpleStart)
//                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameScoreView()
            GameScoreView().previewDevice("iPad Air 2")
        }
        
    }
}
