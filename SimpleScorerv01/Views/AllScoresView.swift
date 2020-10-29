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
    
    @State private var cellPicked  = (-1, PlayerScore())
    @State private var showKeypad = false
    
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
                            
                            PlayerScoreColumn(cell: $cellPicked, showKeypad: $showKeypad, playerScore: playerScore, game: game, geometry: geometry, scoreColumnMaxWidth: scoreColumnMaxWidth, cellHeight: pointCellsHeight)
                                .frame(maxWidth:scoreColumnMaxWidth)
                                .background(playerScore.player.colorGradient)
                                .clipShape(Rectangle()).cornerRadius(14)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                        }
//                        Spacer()
                    }
                    .padding()
                }
                if showKeypad {
                    padTempView(cell: $cellPicked)
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



struct PlayerScoreColumn: View {
    
    @Binding var cell : (Int,PlayerScore)
    @Binding var showKeypad : Bool
    
    var playerScore : PlayerScore
    var game : Game
    var geometry : GeometryProxy
    let scoreColumnMaxWidth : CGFloat
    let cellHeight :  CGFloat
    
    var body: some View {
        ZStack{
            //
            VStack (spacing:0){
                
                let maxHeightForPoints = geometry.size.height - scoreColumnMaxWidth - 50
                
//                Text(String(format: "%.0f", Double(geometry.size.width)))
//                Text(String(format: "%.0f", Double(geometry.size.width)/Double(game.playerScores.count)))
//                Text(String(format: "%.0f", Double(scoreColumnMaxWidth)))
                
                
                AvatarView(user: playerScore.player)
                    
                    .padding(7)
                    .frame(maxHeight:scoreColumnMaxWidth)
                    
                
                ScrollView(maxHeightForPoints/CGFloat(game.currentMaxNumberOfRounds()+1) < cellHeight ? .vertical : []) {
                    ForEach(playerScore.pointsList.indices) { index in
//                        CellView(playerScore: playerScore, index: index, cellHeight: cellHeight, cell: $cell)
                        Rectangle()
                            .fill(index % 2 == 0 ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                            .frame(height:cellHeight)
                            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/, width: (cell.0 == index && cell.1.id == playerScore.id) ? 5 : 0)
                            .overlay(Text(String(playerScore.pointsList[index])).foregroundColor(Color .white))
                            .padding(-3)
                            .onTapGesture(count: 1, perform: {
                                if (cell.0 == index && cell.1.id == playerScore.id) {
                                    cell.0 = -1
                                    cell.1 = PlayerScore()
                                    showKeypad = false
                                } else {
                                    cell.0 = index
                                    cell.1 = playerScore
                                    showKeypad = true
                                }
                                
                            })
                    }
                }
                .border(width: 1, edge: .bottom, color: .offWhite)
                .border(width: 1, edge: .top, color: .offWhite)
                
                Rectangle().fill(Color.clear)
                    .overlay(Text(String(playerScore.totalScore())).foregroundColor(Color .offWhite))
                    .frame(height:50)
                
            }.padding(0)
        }
        
    }
}

struct padTempView: View {
    
    @Binding var cell : (Int,PlayerScore)
//    @State var playerScore : PlayerScore
    
    var body: some View {
        VStack {
            Text(cell.1.player.name)
            Text(String(cell.0))
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

