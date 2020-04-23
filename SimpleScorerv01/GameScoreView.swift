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
    @State private var shouldScroll = true
    
    private var axes: Axis.Set {
        return shouldScroll ? .vertical : []
    }
    
    func numberOfColumns(for screenWidth: CGFloat) -> Int {
        
        return Int(screenWidth) / 325
    }
    
    var body: some View {

        GeometryReader { geometry in
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            ScrollView(self.axes) {
                VStack()  {
                    ScoreCardsGridView(columns: self.numberOfColumns(for: geometry.size.width), game: self.$game)
                    
                    Button(action: {
                        self.game.addPlayer(player: Player())
                    }) {
                        Image(systemName: "plus.rectangle")
                            .foregroundColor(.purpleStart)
                    }
                }
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



struct ScoreCardsGridView: View {
    let columns: Int
    
    @Binding var game: Game
    
    var rows : Int {
        (game.playerScores.count / columns) + 1
    }
    
    var body: some View {
        VStack {
            ForEach(0 ..< self.rows, id: \.self) { row in
                HStack {
                    ForEach(1 ... self.columns, id: \.self) { column in
                        Group {
                            if ((row*self.columns+column-1) < self.game.playerScores.count) {
                                ScoreCardView(game:self.$game, playerScore: self.game.playerScores[row*self.columns+column-1])
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
            }
        }
    }
}
