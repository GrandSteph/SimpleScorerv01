//
//  GameSetupView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 5/7/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct GameSetupView: View {
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    @EnvironmentObject var game : Game
    @Binding var showPlayerEntry : Bool
    
    @State private var showingActionSheet = false
    
    let maxHeight = CGFloat(100)
    let maxWidth = CGFloat(300)
    
    var body: some View {
        
        ZStack {
//            Color.offWhite.edgesIgnoringSafeArea(.all)
            
            HStack {
                Spacer()
                VStack (spacing : 20) {
                    Spacer()
                    
                    Rectangle().cornerRadius(14).frame(maxWidth: maxWidth, maxHeight: maxHeight).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                    Rectangle().cornerRadius(14).frame(maxWidth: maxWidth, maxHeight: maxHeight).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                    Rectangle().cornerRadius(14).frame(maxWidth: maxWidth, maxHeight: maxHeight).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            AnimatedGradientView()
                .mask(
                    HStack {
                        Spacer()
                        VStack (spacing : 20) {
                            Spacer()
                            
                            Rectangle().cornerRadius(14).frame(maxWidth: maxWidth, maxHeight: maxHeight)
                            
                            Rectangle().cornerRadius(14).frame(maxWidth: maxWidth, maxHeight: maxHeight)
                            
                            Rectangle().cornerRadius(14).frame(maxWidth: maxWidth, maxHeight: maxHeight)
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    .padding()
            )
            
            HStack {
                Spacer()
                VStack (spacing : 20) {
                    Spacer()
                    
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .cornerRadius(14)
                        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                        .contentShape(Rectangle())
                        
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.offWhite, lineWidth: 1)
                    )
                        .overlay(
                            Text("RESET SCORES")
                                .fontWeight(.semibold)
                                .font(.system(.largeTitle, design: .rounded))
                                .foregroundColor(Color .offWhite)
                                .padding()
                    ).onTapGesture {
                        self.showingActionSheet = true
                    }.actionSheet(isPresented: $showingActionSheet) {
                        ActionSheet(title: Text("This will reset all scores to 0").font(.system(.headline, design: .rounded)), buttons: [
                            .default(Text("OK")) {
                                self.game.resetScores()
                                self.moveNextScreen()
                            },
                            .cancel()
                        ])
                    }
                    
                    
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .cornerRadius(14)
                        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            // needed to pass gesture down to overlay
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.offWhite, lineWidth: 1)
                    )
                        .overlay(
                            HStack {
                                if game.playerScores.count == 0 {
                                    Rectangle().fill(Color.clear).border(width: 1, edge: .trailing, color: .offWhite)
                                    .contentShape(Rectangle())
                                        .overlay(Text("Min").font(.system(.body, design: .rounded)).foregroundColor(Color.offWhite))
                                    .padding(.trailing)
                                } else {
                                    Rectangle().fill(Color.clear).border(width: 1, edge: .trailing, color: .offWhite)
                                        .contentShape(Rectangle())
                                        .overlay(Image(systemName: "minus").font(.system(.largeTitle, design: .rounded)).foregroundColor(Color.offWhite))
                                        .padding(.trailing)
                                        .onTapGesture {
                                            self.game.removeLastPlayer()
                                            self.displayInfo.setSizeAndScroll(nbrPlayers: self.game.playerScores.count)
                                    }
                                }
                                
                                
                                VStack {
                                    Text("\(self.game.playerScores.count)")
                                        .font(.system(.title, design: .rounded))
                                        
                                        .foregroundColor(Color .offWhite)
                                    
                                    if self.game.playerScores.count > 1 {
                                        Text("PLAYERS")
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(Color .offWhite)
                                    } else {
                                        Text(" PLAYER ")
                                            .font(.system(.body, design: .rounded))
                                            .foregroundColor(Color .offWhite)
                                    }
                                }.animation(.none)
                                
                                if game.playerScores.count < gradiants.count {
                                    Rectangle().fill(Color.clear).border(width: 1, edge: .leading, color: .offWhite)
                                        .contentShape(Rectangle())
                                        .overlay(Image(systemName: "plus").font(.system(.largeTitle, design: .rounded)).foregroundColor(Color.offWhite))
                                        .padding(.leading)
                                        .onTapGesture {
                                            let grad = self.displayInfo.gradients.last!
                                            if self.displayInfo.gradients.count > 1 {
                                                self.displayInfo.gradients.removeLast()
                                            }
                                            self.game.addEmptyPlayer(with: grad)
                                            self.displayInfo.setSizeAndScroll(nbrPlayers: self.game.playerScores.count)
                                    }
                                } else {
                                    Rectangle().fill(Color.clear).border(width: 1, edge: .leading, color: .offWhite)
                                    .contentShape(Rectangle())
                                        .overlay(Text("Max").font(.system(.body, design: .rounded)).foregroundColor(Color.offWhite))
                                    .padding(.trailing)
                                }
                            }
                    )
                    
                    
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .cornerRadius(14)
                        .frame(maxWidth: maxWidth, maxHeight: maxHeight)
                        .contentShape(Rectangle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.offWhite, lineWidth: 1)
                        )
                        .overlay(
                            Text("PLAY")
                                .fontWeight(.semibold)
                                .font(.system(.largeTitle, design: .rounded))
                                .foregroundColor(Color .offWhite)
                                .padding()
                    ).onTapGesture {
                            self.moveNextScreen()
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            //            Rectangle().fill(buttonSwitch ? Color.cyan1 : Color.orangeStart).frame(width: 200, height: 50).clipShape(Rectangle()).cornerRadius(14)
            
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "chevron.left.square.fill")
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color.gray)
                        .padding([.trailing,.bottom])
                        .onTapGesture {
                            self.moveNextScreen()
                        }
                    Spacer()
                }.padding()
            }
        }
    }
    
    func moveNextScreen() {
        self.displayInfo.screenDisplayed.current = .scoreCards
        self.displayInfo.screenDisplayed.previous = .gameSetup
        if self.game.needsNameEntry() {
            self.showPlayerEntry = true
        }
    }
}



struct GameSetupView_Previews: PreviewProvider {
    static var previews: some View {
            
        GameSetupView(showPlayerEntry: .constant(false)).environmentObject(Game())
    }
}

struct AnimatedGradientView: View {
    
     //LinearGradient(Color(hex: 0x373B44),Color(hex: 0x4286f4))

    // blue / red / yellow
//    @State var gradient = [Color(hex: 0x1a2a6c),Color(hex: 0xb21f1f),Color(hex: 0xfdbb2d)]
    @State var gradient = [Color.red, Color.orange, Color.purple]
    
    
    // pink / purple
//    @State var gradient = [Color(red: 255 / 255, green: 85 / 255, blue: 85 / 255), Color(red: 85 / 255, green: 85 / 255, blue: 255 / 255)]
//    @State var gradient = [Color(hex: 0xFC466B),Color(hex: 0x3F5EFB)]
    
    // blue
//    @State var gradient = [Color(red: 3 / 255, green: 79 / 255, blue: 135 / 255), Color(red: 0 / 255, green: 184 / 255, blue: 214 / 255)]
//    @State var gradient = [Color(hex: 0x373B44),Color(hex: 0x4286f4)]
    
    
    @State var startPoint = UnitPoint(x: -1, y: -1)
    @State var endPoint = UnitPoint(x: 1, y: 1)
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: self.gradient), startPoint: self.startPoint, endPoint: self.endPoint)
            .onAppear() {
                withAnimation (Animation.linear(duration: 5).repeatForever()){
                    self.startPoint = UnitPoint(x: 0, y: 0)
                    self.endPoint = UnitPoint(x: 2, y: 2)
                }
        }
    }
}


