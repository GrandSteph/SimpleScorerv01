//
//  ContentView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI
import Combine

struct GameScoreView: View {
    
    @EnvironmentObject var game : Game
    @State private var shouldScroll = true
    
    // PlayerEntry
    @State private var showPlayerEntry = false
    
    // cube display
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    @GestureState private var dragOffset = CGSize.zero
    
    // image picker
    @State private var imagePicked = UIImage()
    @State private var showImagePicker = false
    @State private var pickerSource = UIImagePickerController.SourceType.photoLibrary
    
    private var axes: Axis.Set {
        return shouldScroll ? .vertical : []
    }
    
    func nbrRowsColumns(screenWidth: CGFloat, playerCount: Int) -> (rows : Int, columns : Int) {
        
        let nbrColumns = Double((screenWidth) / 325).rounded(.down)
        let nbrRows = Double(Double(playerCount) / nbrColumns).rounded(.up)
        return (Int(nbrRows),Int(nbrColumns))
    }
    
    func dragToRotation(translation : CGSize) -> Angle {
        return Angle(degrees: Double(translation.width/4.16))
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                
                GameSetupView(showPlayerEntry: self.$showPlayerEntry)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(self.displayInfo.isGameSetupVisible ? Color.darkGray : Color.gray)
//                .rotation3DEffect( Angle(degrees: 90) + self.dragToRotation(translation: self.dragOffset), axis: (x: 0, y:1 , z:0),anchor: .leading)
//                .offset(x: self.dragOffset.width + geometry.size.width, y: 0)
                .rotation3DEffect(Angle(degrees: self.displayInfo.isGameSetupVisible ? 0 : 90), axis: (x: 0, y:1 , z:0),anchor: .leading)
                .offset(x: self.displayInfo.isGameSetupVisible ? 0 : geometry.size.width, y: 0)
                .edgesIgnoringSafeArea(.all)
                .animation(.linear)
//
                Group {
                    ZStack {
                        if self.game.playerScores.count != 0 {
                            ScrollView(self.axes) {
                                VStack()  {
//                                    if self.game.playerScores.count > 0 {
//                                        ScoreCardsGridView( rows:self.nbrRowsColumns(screenWidth: geometry.size.width, playerCount: self.game.playerScores.count).rows,
//                                                            columns: self.nbrRowsColumns(screenWidth: geometry.size.width, playerCount: self.game.playerScores.count).columns,
//                                                            scoreCardSize: self.$ScoreCardSize)
//                                    }
                                    ForEach (self.game.playerScores, id: \.id) { playerScore in
                                        ScoreCardView(playerScore: playerScore, index: self.game.playerScores.firstIndex(where: {$0.id == playerScore.id})!)
                                    }
                                    
                                    Image(systemName: self.displayInfo.scoreCardSize == .compact ? "chevron.compact.down" : "chevron.compact.up")
                                        .font(.system(.largeTitle, design: .rounded))
                                        .foregroundColor(Color.gray)
                                        .background(Color.clear.opacity(0))
                                        .onTapGesture {
                                            if self.displayInfo.scoreCardSize == .compact {
                                                self.displayInfo.scoreCardSize = .normal
                                            } else {
                                                self.displayInfo.scoreCardSize = .compact
                                            }
                                    }.padding()
                                }
//                                ForEach(self.game.playerScores.indices, id: \.self) { index in
//                                    VStack()  {
//                                        ScoreCardView(playerScore: self.$game.playerScores[index], size: .normal, index: index)
//                                            .padding(15)
//                                    }
//                                }
                                .keyboardAdaptive()
                                //                            .offset(x: 0, y: -260)
                            }
                        } else {
                            EmptyView()
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Image(systemName: "chevron.left.square.fill")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .foregroundColor(Color.gray)
                                    .background(Color.clear.opacity(0))
                                    .onTapGesture {
                                        self.displayInfo.isGameSetupVisible = true
                                }.padding()
                            }
                            
                        }
                        
                    }
                }
                .background(self.displayInfo.isGameSetupVisible ? Color.white : Color.offWhite)
//                .rotation3DEffect(self.dragToRotation(translation: self.dragOffset), axis: (x: 0, y:1 , z:0), anchor: .trailing)
//                .offset(x: self.dragOffset.width, y: 0)
                .rotation3DEffect(Angle(degrees: self.displayInfo.isGameSetupVisible ? -90 : 0), axis: (x: 0, y:1 , z:0), anchor: .trailing)
                .offset(x: self.displayInfo.isGameSetupVisible ? -geometry.size.width : 0, y: 0)
                .animation(.linear)

                if self.showImagePicker {
                    CircleImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked, source: self.pickerSource)
                        .edgesIgnoringSafeArea(.all)
                }
                
                if self.showPlayerEntry {
//                    PlayersNameEntry(game: self.$game, isVisible: self.$showPlayerEntry)
                    PlayersEntryView(isVisible: self.$showPlayerEntry)
                }
                
                
            }
//            .gesture(
//                DragGesture()
//                    .updating(self.$dragOffset, body: { (value, state, transaction) in
//                        if value.startLocation.x > (geometry.size.width - 25) {
//                            state = value.translation
//                        }
//                    })
//                    .onEnded({ (value) in
//                        self.displayInfo.isGameSetupVisible = true
//                    })
//            )

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            GameScoreView()
//             .previewLayout(.fixed(width: 650, height: 320))
            GameScoreView()
                .environmentObject(GlobalDisplayInfo())
                .environmentObject(Game(withTestPlayers: ()))
//                .previewDevice("iPad Air 2")
        }
        
    }
}



struct ScoreCardsGridView: View {
    let rows : Int
    let columns: Int
    
    @EnvironmentObject var game: Game
    @Binding var scoreCardSize: CardSize
    
    var body: some View {
        VStack {
            ForEach(0 ..< self.rows, id: \.self) { row in
                HStack {
                    ForEach(1 ... self.columns, id: \.self) { column in
                        Group {
                            if ((row*self.columns+column-1) < self.game.playerScores.count) {
                                ScoreCardView(
                                    playerScore:self.game.playerScores[row*self.columns+column-1],
                                    index: row*self.columns+column-1
                                )
                            } else {
                                Rectangle().opacity(0)
                            }
                        }.padding(.horizontal, 5)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom,10)
                .padding(.top,5)
            }
        }
    }
}



