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
    @State private var ScoreCardSize = CardSize.normal
    
    @State private var rotatedCube = true
    @GestureState private var dragOffset = CGSize.zero
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    @State private var imagePicked = UIImage()
    @State private var showImagePicker = false
    @State private var pickerSource = UIImagePickerController.SourceType.photoLibrary
    
    private var axes: Axis.Set {
        return shouldScroll ? .vertical : []
    }
    
    func nbrRowsColumns(screenWidth: CGFloat, playerCount: Int) -> (rows : Int, columns : Int) {
        
        let nbrColumns = Int(screenWidth) / 325
        let nbrRows = playerCount / nbrColumns
        return (nbrRows,nbrColumns)
    }
    
    func dragToRotation(translation : CGSize) -> Angle {
        
        return Angle(degrees: Double(translation.width/4.16))
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                
                GameSetupView(isDisplayed: self.$rotatedCube, game: self.$game)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(self.rotatedCube ? Color.darkGray : Color.gray)
//                .rotation3DEffect( Angle(degrees: 90) + self.dragToRotation(translation: self.dragOffset), axis: (x: 0, y:1 , z:0),anchor: .leading)
//                .offset(x: self.dragOffset.width + geometry.size.width, y: 0)
                .rotation3DEffect(Angle(degrees: self.rotatedCube ? 0 : 90), axis: (x: 0, y:1 , z:0),anchor: .leading)
                .offset(x: self.rotatedCube ? 0 : geometry.size.width, y: 0)
                .edgesIgnoringSafeArea(.all)
                .animation(.linear)
//
                Group {
                    if self.game.playerScores.count > 0 {
                        ScrollView(self.axes) {
                            VStack()  {
                                ScoreCardsGridView( rows:self.nbrRowsColumns(screenWidth: geometry.size.width, playerCount: self.game.playerScores.count).rows,
                                                    columns: self.nbrRowsColumns(screenWidth: geometry.size.width, playerCount: self.game.playerScores.count).columns,
                                                    game: self.$game,
                                                    scoreCardSize: self.ScoreCardSize)
    //                            Spacer()
    //                            AddPlayerView(game: self.$game, kGuardian: self.kGuardian,showImagePicker: self.$showImagePicker, pickerSource: self.$pickerSource , imagePicked: self.$imagePicked)
    //                                .padding(.horizontal, 20)
    //                                .background(GeometryGetter(rect: self.$kGuardian.rects[0]))
    //                                .onAppear { self.kGuardian.addObserver() }
    //                                .onDisappear { self.kGuardian.removeObserver() }

                            }.animation(.none)
    //                            .offset(y: self.kGuardian.slide < 0 ? self.kGuardian.slide : 0)//.animation(.easeOut(duration: 0.16))
                        }
                    } else {
                        /*@START_MENU_TOKEN@*/EmptyView()/*@END_MENU_TOKEN@*/
                    }
                }
                .background(self.rotatedCube ? Color.white : Color.offWhite)
                    //                .rotation3DEffect(self.dragToRotation(translation: self.dragOffset), axis: (x: 0, y:1 , z:0), anchor: .trailing)
                    //                .offset(x: self.dragOffset.width, y: 0)
                    .rotation3DEffect(Angle(degrees: self.rotatedCube ? -90 : 0), axis: (x: 0, y:1 , z:0), anchor: .trailing)
                    .offset(x: self.rotatedCube ? -geometry.size.width : 0, y: 0)
//                    .edgesIgnoringSafeArea(.all)
                    .animation(.linear)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "chevron.left.square.fill")
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(Color.gray)
                            .padding([.trailing,.bottom])
                            .onTapGesture {
                                self.rotatedCube.toggle()
//                                self.game.removePlayer()
                            }
                    }
                }
                .rotation3DEffect(Angle(degrees: self.rotatedCube ? -90 : 0), axis: (x: 0, y:1 , z:0), anchor: .trailing)
                .offset(x: self.rotatedCube ? -geometry.size.width : 0, y: 0)

                if self.showImagePicker {
                    CircleImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked, source: self.pickerSource)
                        .edgesIgnoringSafeArea(.all)
                }
            }
//                DragGesture()
//                    .updating(self.$dragOffset, body: { (value, state, transaction) in
//                        if value.startLocation.x > (geometry.size.width - 25) {
//                            state = value.translation
//                        }
//                    })
//                    .onEnded({ (value) in
//                        self.rotatedCube = true
//                    })
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            GameScoreView()
//            GameScoreView().previewDevice("iPad Air 2")
        }
        
    }
}



struct ScoreCardsGridView: View {
    let rows : Int
    let columns: Int
    
    @Binding var game: Game
    var scoreCardSize: CardSize
    
    
    var body: some View {
        VStack {
            ForEach(0 ..< self.rows, id: \.self) { row in
                HStack {
                    ForEach(1 ... self.columns, id: \.self) { column in
                        Group {
                            if ((row*self.columns+column-1) < self.game.playerScores.count) {
//                                ScoreCardView(playerScore:self.$game.playerScores[row*self.columns+column-1], size: self.scoreCardSize)
                                ScoreCardView(playerScore:Binding(   // << use proxy binding !!
                                                    get: { self.game.playerScores[row*self.columns+column-1] },
                                                    set: { self.game.playerScores[row*self.columns+column-1] = $0 }), size: self.scoreCardSize)
                            } else {
                                EmptyView()
                            }
                        }.padding(.horizontal, 5)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.bottom,15)
            }
        }
        
//        ForEach(Array(game.playerScores.enumerated()), id: \.element) { (index, playerScore) in
//            // do with `index` anything needed here
//
//            VStack {
//                ScoreCardView(playerScore: Binding(   // << use proxy binding !!
//                    get: { self.game.playerScores[index] },
//                    set: { self.game.playerScores[index] = $0 }), size: self.scoreCardSize)
//            }
//            .padding(.horizontal, 15)
//            .padding(.bottom,15)
//        }
    }
}

