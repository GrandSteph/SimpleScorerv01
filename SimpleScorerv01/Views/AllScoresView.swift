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
//            HStack {
//                Spacer()
//
//                VStack {
//                    Text("")
//                    ForEach(self.game.roundsLabels, id: \.self) { label in
//                        Text(label)
//                    }
//                    Text("-")
//                    Text("")
//                }
//
//                ForEach(self.game.playerScores, id: \.id) { playerScore in
//                    Group {
//                        VStack {
//                            Text(playerScore.player.name.uppercased().prefix(1))
//                            ForEach(playerScore.pointsList, id: \.self) { points in
//                                Text(String(points))
//                            }
//                            Text("-")
//                            Text(String(playerScore.totalScore()))
//                        }
//                        Spacer()
//                    }
//                }
//            }
            
            VStack {
                HStack {
                    Text(".")
                    Spacer()
                    ForEach(self.game.playerScores, id: \.id) { playerScore in
                        Group {
                            Text(playerScore.player.name.uppercased().prefix(1))
                            Spacer()
                        }
                    }
                }
                ForEach(self.game.roundsLabels, id: \.self) { intLabel in
                    HStack {
                        Text("\(intLabel)")
                        Spacer()
                        ForEach(self.game.playerScores, id: \.id) { playerScore in
                            Group {
                                if playerScore.pointsList.count >= intLabel {
                                    Text(String(playerScore.pointsList[intLabel-1]))
                                } else {
                                    Text("-")
                                }
                                
                                Spacer()
                            }
                        }
                    }
                }
                HStack {
                    Text("=")
                    Spacer()
                    ForEach(self.game.playerScores, id: \.id) { playerScore in
                        Group {
                            Text(String(playerScore.totalScore()))
                            Spacer()
                        }
                    }
                }.padding(.vertical)
                
            }.padding()
            
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
