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
    
    let scoreColumnMaxWidth = CGFloat(80)
    let pointCellsHeight = CGFloat(40)
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                
                ScrollView(geometry.size.width/CGFloat(game.playerScores.count) < scoreColumnMaxWidth ? .horizontal : []) {
                    HStack {
//                        Spacer()
                        ForEach(self.game.playerScores, id: \.id) { playerScore in
                            
                            PlayerScoreColumn(playerScore: playerScore, game: game, geometry: geometry, scoreColumnMaxWidth: scoreColumnMaxWidth, pointCellsHeight: pointCellsHeight)
                                .frame(maxWidth:scoreColumnMaxWidth)
                                .background(playerScore.player.colorGradient)
                                .clipShape(Rectangle()).cornerRadius(14)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                        }
//                        Spacer()
                    }
                    .padding()
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
}

struct AllScoresView_Previews: PreviewProvider {
    static var previews: some View {
        AllScoresView()
            .environmentObject(GlobalDisplayInfo())
            .environmentObject(Game(withTestPlayers: ()))
    }
}

struct pointsScrollView: View {
    
    var playerScore : PlayerScore
    let maxHeight : CGFloat
    let pointCellsHeight : CGFloat
    let game : Game
    
    var body: some View {
        ScrollView(maxHeight/CGFloat(game.currentMaxNumberOfRounds()+1) < pointCellsHeight ? .vertical : []) {
            if playerScore.pointsList.count > 0 {
                ForEach(playerScore.pointsList.indices) { index in
                    Rectangle()
                        .fill(index % 2 == 0 ? Color.white.opacity(0.1) : Color.clear)//.padding(-4)
                        .frame(height:pointCellsHeight)
                        .overlay(Text(String(playerScore.pointsList[index])).foregroundColor(Color .white))
                        .padding(-4)
                }
            }
            let missingRounds = game.currentMaxNumberOfRounds() - playerScore.pointsList.count
//            if missingRounds > 0 {
//                ForEach((1...missingRounds), id: \.self) {
//                    Rectangle()
//                        .fill($0 % 2 == 0 ? Color.white.opacity(0.1) : Color.clear)//.padding(-4)
//                        .frame(height:pointCellsHeight)
//                        .overlay(Text("-").foregroundColor(Color .white))
//                        .padding(-4)
//                }
//            }
        }
    }
}

struct PlayerScoreColumn: View {
    
    var playerScore : PlayerScore
    var game : Game
    var geometry : GeometryProxy
    let scoreColumnMaxWidth : CGFloat
    let pointCellsHeight :  CGFloat
    
    var body: some View {
        ZStack{
            //
            VStack {
                
                let maxHeightForPoints = geometry.size.height - scoreColumnMaxWidth - 50
                
//                Text(String(format: "%.0f", Double(geometry.size.width)))
//                Text(String(format: "%.0f", Double(geometry.size.width)/Double(game.playerScores.count)))
//                Text(String(format: "%.0f", Double(scoreColumnMaxWidth)))
                
                
                AvatarView(user: playerScore.player)
                    .padding(7)
                    .border(width: 1, edge: .bottom, color: .offWhite)
                    .frame(maxHeight:scoreColumnMaxWidth)
                
                pointsScrollView(playerScore: playerScore, maxHeight: maxHeightForPoints, pointCellsHeight: pointCellsHeight, game: game)
                
                Rectangle().fill(Color.clear)
                    .border(width: 1, edge: .top, color: .offWhite)
                    .overlay(Text(String(playerScore.totalScore())).foregroundColor(Color .offWhite))
                    .frame(height:50)
                
            }.padding(0)
        }
        
    }
}
