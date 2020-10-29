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
    
    // image picker
    @State private var imagePicked = UIImage()
    @State private var showImagePicker = false
    @State private var pickerSource = UIImagePickerController.SourceType.photoLibrary
    
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
                
                AllScoresView()
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .modifier(cubeRotation(screen: .allScores, screenWidth: geometry.size.width))
                
                GameSetupView(showPlayerEntry: self.$showPlayerEntry)
//                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .modifier(cubeRotation(screen: .gameSetup, screenWidth: geometry.size.width))

                Group {
                    ZStack {
                        if self.game.playerScores.count != 0 {
                            ScrollView(self.displayInfo.shouldScroll ? .vertical : []) {
                                VStack()  {
                                    if self.game.playerScores.count > 0 {
                                        ScoreCardsGridView( rows:self.nbrRowsColumns(screenWidth: geometry.size.width, playerCount: self.game.playerScores.count).rows,
                                                            columns: self.nbrRowsColumns(screenWidth: geometry.size.width, playerCount: self.game.playerScores.count).columns)
                                            .frame(maxWidth:geometry.size.width)
                                    }
                                }
                                .keyboardAdaptive()
                                
                            }
                        } else {
                            EmptyView()
                        }
                        
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "chevron.left.square.fill")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .foregroundColor(Color.gray)
                                    .background(Color.clear.opacity(0))
                                    .onTapGesture {
                                        self.displayInfo.screenDisplayed = .allScores

                                }.padding()
                                Spacer()
                                Image(systemName: "chevron.right.square.fill")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .foregroundColor(Color.gray)
                                    .background(Color.clear.opacity(0))
                                    .onTapGesture {
                                        self.displayInfo.screenDisplayed = .gameSetup

                                }.padding()
                            }
                        }
                    }
                }
                .modifier(cubeRotation(screen: .scoreCards, screenWidth: geometry.size.width))

                if self.showImagePicker {
                    CircleImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked, source: self.pickerSource)
                        .edgesIgnoringSafeArea(.all)
                }
                
                if self.showPlayerEntry {
                    PlayersEntryView(isVisible: self.$showPlayerEntry)
                }
            }
        }
    }
}

struct cubeRotation: ViewModifier {
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    let screen : ScreenType
    
    let screenWidth : CGFloat
    
    func angle() -> Angle {
        return Angle(degrees: 90 * Double(screen - self.displayInfo.screenDisplayed))
    }
    
    func edge() -> UnitPoint {
    
        if (screen - self.displayInfo.screenDisplayed) > 0 {
            return .leading
        } else {
            return .trailing
        }
    }
    
    func offSet() -> CGFloat {
        return screenWidth * CGFloat(screen - self.displayInfo.screenDisplayed)
    }
    
    func body(content: Content) -> some View {
        content
            .rotation3DEffect(self.angle(), axis: (x: 0, y:1 , z:0), anchor: self.edge())
            .offset(x: self.offSet() , y: 0)
            .animation(.linear)
            .disabled(!(self.displayInfo.screenDisplayed == screen))
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
//            GameScoreView()
//                .previewLayout(.fixed(width: 1000, height: 320))
            GameScoreView()
//                .previewDevice("iPad Air 2")
        }
        .environmentObject(GlobalDisplayInfo())
        .environmentObject(Game(withTestPlayers: ()))
        
    }
}

extension AnyTransition {
    static var scaleAndOffset: AnyTransition {
        AnyTransition.asymmetric(
            insertion: .scale(scale: 0, anchor: .bottom),
            removal: .offset(x: -600, y: 00)
        )
    }
}

struct ScoreCardsGridView: View {
    let rows : Int
    let columns: Int
    
    @EnvironmentObject var game: Game
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    var body: some View {
        VStack {
            if self.displayInfo.scoreCardSize == .compact { Spacer() }
            ForEach(0 ..< self.rows, id: \.self) { row in
                Group {
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
                    
                     if self.displayInfo.scoreCardSize == .compact { Spacer() }
                }
                
                
            }
            
            
        }
    }
}



