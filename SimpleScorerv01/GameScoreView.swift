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
    @State var dragOffset = CGSize.zero
    @State var previousWidth = CGFloat(0)
    @State var swipingLeft = true
    
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
    
    func setSwipingDirection (width : CGFloat) {
        if width - previousWidth > 0 {
            swipingLeft = false
        } else {
            swipingLeft = true
        }
        previousWidth = width
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                
                AllScoresView()
                    .modifier(cubeRotation(dragOffset: $dragOffset, screen: .allScores, screenWidth: geometry.size.width))
                
                GameSetupView(showPlayerEntry: self.$showPlayerEntry)
                    .modifier(cubeRotation(dragOffset: $dragOffset, screen: .gameSetup, screenWidth: geometry.size.width))

                // Score Cards View
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
                        
                        // bottom Scroll Buttons
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "arrow.left.circle")
                                    .font(.system(.largeTitle, design: .rounded))
                                    .foregroundColor(Color.gray)
                                    .background(Color.clear.opacity(0))
                                    .onTapGesture {
                                        self.displayInfo.screenDisplayed = .allScores

                                }.padding()
                                Spacer()
                                Image(systemName: "arrow.right.circle")
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
                .modifier(cubeRotation(dragOffset: $dragOffset, screen: .scoreCards, screenWidth: geometry.size.width))

                if self.showImagePicker {
                    CircleImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked, source: self.pickerSource)
                        .edgesIgnoringSafeArea(.all)
                }
                
                if self.showPlayerEntry {
                    PlayersEntryView(isVisible: self.$showPlayerEntry)
                }
            }
            .gesture(

                DragGesture()
                    .onChanged { gesture in
//                        print("\(gesture.translation.width) - Prev \(previousWidth) - left? \(swipingLeft)")
                        if !(self.displayInfo.allScoreScrolling) {
                            self.setSwipingDirection(width: gesture.translation.width)
                            
                            if gesture.startLocation.x > (geometry.size.width - 25) && self.displayInfo.screenDisplayed != ScreenType.gameSetup {
                                self.dragOffset = gesture.translation
                            } else if gesture.startLocation.x < 25 && self.displayInfo.screenDisplayed != ScreenType.allScores {
                                self.dragOffset = gesture.translation
                            } else {
                                self.dragOffset = .zero
                            }
                        } else {
                            self.dragOffset = .zero
                        }
                        
                    }
                    .onEnded({ (value) in
                        
                        if self.dragOffset != .zero {
                            if self.dragOffset.width > 0 && !self.swipingLeft {
                                if (ScreenType(rawValue: self.displayInfo.screenDisplayed.rawValue - 1) != nil) {
                                    self.displayInfo.screenDisplayed = ScreenType(rawValue: self.displayInfo.screenDisplayed.rawValue - 1)!
                                }
                            } else if self.dragOffset.width < 0 && self.swipingLeft {
                                if (ScreenType(rawValue: self.displayInfo.screenDisplayed.rawValue + 1) != nil) {
                                    self.displayInfo.screenDisplayed = ScreenType(rawValue: self.displayInfo.screenDisplayed.rawValue + 1)!
                                }
                            }
                            self.dragOffset = .zero
                        }
                    })
            )
        }
    }
}

struct cubeRotation: ViewModifier {
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    @Binding var dragOffset : CGSize
    
    let screen : ScreenType
    
    let screenWidth : CGFloat
    
    func angle() -> Angle {
        return Angle(degrees: 90 * Double(screen - self.displayInfo.screenDisplayed)) + self.dragToRotation(translation: self.dragOffset)
    }
    
    func edge() -> UnitPoint {
        
        if (screen - self.displayInfo.screenDisplayed) == 0 {
            if dragOffset.width > 0 {
                return .leading
            } else {
                return .trailing
            }
        } else if (screen - self.displayInfo.screenDisplayed) > 0 {
            if dragOffset.width > 0 {
                return .trailing
            } else {
                return .leading
            }
        } else {
            if dragOffset.width > 0 {
                return .trailing
            } else {
                return .leading
            }
        }
    }
    
    func offSet() -> CGFloat {
        return screenWidth * CGFloat(screen - self.displayInfo.screenDisplayed) + self.dragOffset.width * 1.2
    }
    
    func dragToRotation(translation : CGSize) -> Angle {
        
        return Angle(degrees: Double(translation.width/4.16))

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



