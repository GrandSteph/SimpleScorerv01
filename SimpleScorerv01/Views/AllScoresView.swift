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
    
    @State private var cell  = (cellIndex: -1, playerScore: PlayerScore())
    @State private var showKeypad = false
    @State private var pointScored = CGFloat(0)
    @State private var sign = CGFloat(1)
    
    let scoreColumnMaxWidth = CGFloat(90)
    let pointCellsHeight = CGFloat(40)
    let frameHeight = CGFloat(135)
    
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                
                ScrollView(geometry.size.width/CGFloat(game.playerScores.count) < scoreColumnMaxWidth ? .horizontal : []) {
                    HStack {
                        ForEach(self.game.playerScores, id: \.id) { playerScore in
                            
                            PlayerScoreColumn(cell: $cell, showKeypad: $showKeypad, playerScore: playerScore, game: game, geometry: geometry, scoreColumnMaxWidth: scoreColumnMaxWidth, cellHeight: pointCellsHeight)
                                .frame(maxWidth:scoreColumnMaxWidth)
                                .background(playerScore.player.colorGradient)
                                .clipShape(Rectangle()).cornerRadius(14)
                                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                        }
                    }
                    .padding()
                }
                
                
                if showKeypad {
                    scoreCorrectionView
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
    
    var scoreCorrectionView: some View {
        ZStack {
            
            cell.playerScore.player.colorGradient
            
            VStack {
                HStack {
                    Image(systemName: "xmark").foregroundColor(Color.white)
                        .contentShape(Rectangle()).frame(width: 50, height: 50)
                        .offset(x: -10, y: -10)
                        .onTapGesture(count: 1, perform: {
                            showKeypad = false
                            sign = 1
                            pointScored = 0
                        })
                    
                    Spacer()
                }
                Spacer()
            }

            
            VStack (spacing:0){
                
                HStack {
                    Spacer()
                    
                    Text("\(String(cell.playerScore.pointsList[cell.0].score)) ⇢ \(self.sign >= 0 ? "" : "-") \( String(format: "%.0f",abs(pointScored)))")
                        .font(Font.system(size: fontSize(nbrChar: String(format: "%.0f",abs(pointScored)).count + String(cell.playerScore.pointsList[cell.cellIndex].score).count + 1, fontSize: 40)
                                          , weight: .bold
                                          , design: .rounded))
                        .scaledToFill()
                        .minimumScaleFactor(0.9)
                        .lineLimit(1)
                        .foregroundColor(Color .offWhite)
                        .padding(.horizontal,20)
                    
                    Spacer()
                    
                    Rectangle().fill(Color.offWhite.opacity(0.5))
                            .border(width: 1, edge: .leading, color: .offWhite)
                            .overlay(Image(systemName: "checkmark").foregroundColor(Color.white))
                            .frame(minWidth:70, maxWidth:70, maxHeight: .infinity)
                            .onTapGesture {
                                game.playerScores[game.indexOf(player: cell.playerScore.player)!].modifyScore(newScore: Int(pointScored * sign), forRound: cell.cellIndex)
                                showKeypad = false
                                sign = 1
                                pointScored = 0
                        }
                }
                .frame(height: frameHeight*2/3)
                
                KeyPadView(valueDisplayed: $pointScored, sign: $sign)
                    .frame(height: frameHeight*4/3)
                    
            }
            
        }
        .frame(width: 300, height: frameHeight*6/3)
        .clipShape(Rectangle()).cornerRadius(14)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
        
    }
}



struct PlayerScoreColumn: View {
    
    @Binding var cell : (cellIndex: Int, playerScore: PlayerScore)
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
                
                AvatarView(user: playerScore.player)
                    .padding(5)
                    .frame(maxHeight:scoreColumnMaxWidth)
                
                ScrollView(maxHeightForPoints/CGFloat(game.currentMaxNumberOfRounds()+1) < cellHeight ? .vertical : []) {
                    pointList
//                    pointsList(playerScore: playerScore, cellHeight: cellHeight)
                }
                .border(width: 1, edge: .bottom, color: .offWhite)
                .border(width: 1, edge: .top, color: .offWhite)
                .frame(maxHeight:cellHeight * CGFloat(game.currentMaxNumberOfRounds()))
                
                Rectangle().fill(Color.clear)
                    .overlay(
                        Text(String(playerScore.totalScore())))
                            .font(Font.system(size: fontSize(nbrChar: String(playerScore.totalScore()).count + 1, fontSize: 25)
                                              , weight: .bold
                                              , design: .rounded))
                    .foregroundColor(Color.offWhite)
                    .frame(height:50)
                
            }.padding(0)
        }
        
    }
    
    var pointList: some View {

        ForEach(playerScore.pointsList, id: \.self) { points in
            
            Rectangle()
                .fill(points.round % 2 == 0 ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                .frame(height:cellHeight)
                .border(Color.white, width: (cell.0 == points.round && cell.playerScore.id == playerScore.id && showKeypad) ? 5 : 0)
                .overlay(Text( ("\(String(points.score))")).foregroundColor(Color .white))
                .padding(-3)
                .onTapGesture(count: 1, perform: {
                    if (cell.cellIndex == points.round && cell.playerScore.id == playerScore.id) {
                        cell.cellIndex = -1
                        cell.playerScore = PlayerScore()
                        showKeypad = false
                    } else {
                        cell.cellIndex = points.round
                        cell.playerScore = playerScore
                        showKeypad = true
                    }
                })
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

