//
//  AllScoresView.swift
//  SimpleScorerv01
//
//  Created by Dev on 6/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct AllScoresView: View {
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    @EnvironmentObject var game : Game
    
    var body: some View {
        ZStack {
            HStack {
                ForEach(self.game.playerScores, id: \.id) { playerScore in
                    VStack {
                        Text(playerScore.player.name)
                        ForEach(playerScore.pointsList.indices) { index in
                            Text(String(playerScore.pointsList[index]))
                        }
                        Text(String(playerScore.totalScore()))
                    }
                }
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Image(systemName: "chevron.right.square.fill")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color.gray)
                        .background(Color.clear.opacity(0))
                        .onTapGesture {
                            self.displayInfo.screenDisplayed = .scoreCards
                    }
                    .padding()
                }
            }
        }
    }
}

struct AllScoresView_Previews: PreviewProvider {
    static var previews: some View {
        AllScoresView()
            .environmentObject(GlobalDisplayInfo())
            .environmentObject(Game(withTestPlayers: ()))
    }
}
