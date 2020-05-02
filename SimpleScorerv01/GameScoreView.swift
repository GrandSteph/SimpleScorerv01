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
    
    @State private var rotatedCube = false
    
    @GestureState private var dragOffset = CGSize.zero
    @ObservedObject private var kGuardian = KeyboardGuardian(textFieldCount: 1)
    
    @State private var imagePicked = UIImage()
    @State private var showImagePicker = false
    @State private var pickerSource = UIImagePickerController.SourceType.camera
    
    private var axes: Axis.Set {
        return shouldScroll ? .vertical : []
    }
    
    func numberOfColumns(for screenWidth: CGFloat) -> Int {
        
        return Int(screenWidth) / 325
    }
    
    func dragToRotation(translation : CGSize) -> Angle {
        
        return Angle(degrees: Double(translation.width/4.16))
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                Color.offWhite.edgesIgnoringSafeArea(.all)
                
//                VStack {
//                    Spacer()
//                    Button(action: {
//                        self.rotatedCube.toggle()
//                    }) {
//                        Image(systemName: "hand.point.left")
//                            .font(.system(size: 60, weight: .thin))
//                            .foregroundColor(.white)
//                    }
//                    Spacer()
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity)
//                .background(self.rotatedCube ? Color.darkGray : Color.gray)
//                .rotation3DEffect( Angle(degrees: 90) + self.dragToRotation(translation: self.dragOffset), axis: (x: 0, y:1 , z:0),anchor: .leading)
//                .edgesIgnoringSafeArea(.all)
//                .offset(x: self.dragOffset.width + geometry.size.width, y: 0)
//                .animation(.linear)
                Group {
                    ScrollView(self.axes) {
                        VStack()  {
                            ScoreCardsGridView(columns: self.numberOfColumns(for: geometry.size.width), game: self.$game)
                            Spacer()
                            AddPlayerView(game: self.$game, kGuardian: self.kGuardian,showImagePicker: self.$showImagePicker, pickerSource: self.$pickerSource , imagePicked: self.$imagePicked)
                                .padding(.horizontal, 20)
                                .background(GeometryGetter(rect: self.$kGuardian.rects[0]))
                                .onAppear { self.kGuardian.addObserver() }
                                .onDisappear { self.kGuardian.removeObserver() }
                            
                        }.offset(y: self.kGuardian.slide < 0 ? self.kGuardian.slide : 0)//.animation(.easeOut(duration: 0.16))
                    }
                }
//                .background(self.rotatedCube ? Color.white : Color.offWhite)
//                .rotation3DEffect(self.dragToRotation(translation: self.dragOffset), axis: (x: 0, y:1 , z:0), anchor: .trailing)
//                .offset(x: self.dragOffset.width, y: 0)
//                .animation(.linear)
                
                if self.showImagePicker {
                    ImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked, source: self.pickerSource)
                        .edgesIgnoringSafeArea(.all)
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
//                        if abs(value.translation.width) > geometry.size.width / 3 {
//                            print("\(value.translation.width) - \(geometry.size.width / 4)")
//                        }
//                    })
//            )
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
                                ScoreCardView(playerScore:self.$game.playerScores[row*self.columns+column-1])
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
    }
}

