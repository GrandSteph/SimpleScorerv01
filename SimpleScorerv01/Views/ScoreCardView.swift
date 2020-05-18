//
//  ScoreCardView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/17/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ScoreCardView: View {
    
    @Binding var playerScore: PlayerScore
    var size: CardSize
    var backGroundGradient: LinearGradient
    
    @State private var pointsScored = CGFloat(120)
    @State private var editing = false
    
    @State private var nameEditing = false
    @State private var username = ""
    
    var body: some View {
        
        var frameHeight : CGFloat {
            self.size == .compact ? CGFloat(80) : CGFloat(135)
        }
        
        return
            ZStack {
                
                self.playerScore.player.colorGradient
                
                VStack (alignment: .leading, spacing: 0){
                    
                    HStack (alignment: .center, spacing: 0) {
                        
                        AvatarView(name: playerScore.player.name, image: playerScore.player.photoImage).padding(10).frame(maxWidth: self.size != .compact ? frameHeight*2/3 : frameHeight)
                        
                        if !editing {
                            if !self.nameEditing && self.playerScore.player.name != "Name ?" {
                                Text(self.playerScore.player.name)
                                    .fontWeight(.semibold)
                                    .font(.system(.largeTitle, design: .rounded))
                                    .minimumScaleFactor(0.5)
                                    .lineLimit(1)
                                    .foregroundColor(Color .offWhite)
                                    .onTapGesture {
                                        self.nameEditing = true
                                }
                            } else {
                                TextField("Name?", text: self.$username,
//                                     onEditingChanged: {
//                                       if $0 { /*self.kGuardian.showField = 0 */} },
                                     onCommit: {
                                        self.nameEditing = false
                                        self.playerScore.player.name = self.username
                                        self.playerScore.player.colorGradient = self.backGroundGradient
                                    })
                                    .font(.system(.largeTitle, design: .rounded))
                                    .background(Color.offWhite.opacity(0.6))
                                    .foregroundColor(Color.offWhite)
                                .foregroundColor(Color .offWhite)
                            }
                        } else {
                            ZStack {
                               
                                VStack {
                                    Image(systemName: "xmark").foregroundColor(Color.white)
                                        .padding()
                                        .contentShape(Rectangle())
                                    Spacer()
                                }.onTapGesture {
                                    self.pointsScored = 0
                                    self.editing = false
                                }
                           }
                           .frame(minWidth:40, maxWidth:40, maxHeight: .infinity)
                           .onTapGesture {
                               self.pointsScored = 0
                               self.editing = false
                           }
                        }
                        
                        
                        Spacer()
                        
                        Group {
                            Text("\(self.playerScore.totalScore())")
                                .font(Font.system(size: 50, weight: .bold, design: .rounded))
                                .lineLimit(1)
                                .foregroundColor(Color .offWhite)
                                .padding(.horizontal,self.editing ? 0 : 20)
                                .layoutPriority(1)
                            
                            if editing {
                                
                                HStack {
                                   
                                    
                                    VStack {
                                        Text("\(self.pointsScored >= 0 ? "+" : "-") \( String(format: "%.0f",abs(self.pointsScored)))")
                                            .font(Font.system(size: 25, weight: .bold, design: .rounded))
                                            .minimumScaleFactor(0.5)
                                            .lineLimit(1)
                                            .foregroundColor(Color .offWhite)
                                        
                                        
                                        Text("= \( String(format: "%.0f",CGFloat(self.playerScore.totalScore()) + self.pointsScored))")
                                            .font(Font.system(size: 10, weight: .bold, design: .rounded))
                                            .foregroundColor(Color .offWhite)
                                        
                                    }
                                    
                                    
                                    ZStack {
                                        Rectangle()
                                            .fill(Color.black)
                                            .opacity(0.05)
                                        Rectangle().fill(Color.clear)
                                            .border(width: 1, edge: .leading, color: .offWhite)
                                        Image(systemName: "checkmark").foregroundColor(Color.white)
                                    }
                                    .frame(minWidth:40, maxWidth:40, maxHeight: .infinity)
                                    .onTapGesture {
                                        self.playerScore.addPoints(scoreValue: Int(String(format: "%.0f",self.pointsScored))!)
                                        self.pointsScored = 0
                                        //                                        withAnimation {
                                        self.editing = false
                                        //                                        }
                                        
                                    }
                                }//.transition(.scale(scale: 0, anchor: .bottom))
                            } //else {Spacer()}
                        }
                        
                        
                    }
//                    .frame(height: frameHeight*2/3)
                   
                    
                    if self.size != .compact {
                        HStack (spacing: 0) {
                            
                            Button(action: {
                                //                                withAnimation {
                                self.editing = true
                                //                                }
                                self.pointsScored -= 1
                            }) {
                                Image(systemName: "minus.rectangle")
                                    .foregroundColor(.purpleStart)
                            }
                            .buttonStyle(SimpleRectButtonStyle())
                            
                            ClickWheel(editing: self.$editing, pointsScored: self.$pointsScored, wheelColor: Color .purpleStart)
                            
                            Button(action: {
                                //                                withAnimation {
                                self.editing = true
                                //                                }
                                self.pointsScored += 1
                            }) {
                                Image(systemName: "plus.rectangle")
                                    .foregroundColor(.purpleStart)
                            }
                            .buttonStyle(SimpleRectButtonStyle())
                        }
                        .frame(height: frameHeight/3)
                    }
                    
                    
                    
                    
                }
            }
            .frame(height: frameHeight)
            .clipShape(Rectangle()).cornerRadius(14)
            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct SimpleRectButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .border(Color.offWhite, width: 1)
            .background(
                Group {
                    if configuration.isPressed {
                        Rectangle()
                            .fill(Color.gray)
                    } else {
                        Rectangle()
                            .fill(Color.white)
                    }
                }
        )
    }
}

struct EdgeBorder: Shape {
    
    var width: CGFloat
    var edge: Edge
    
    func path(in rect: CGRect) -> Path {
        var x: CGFloat {
            switch edge {
            case .top, .bottom, .leading: return rect.minX
            case .trailing: return rect.maxX - width
            }
        }
        
        var y: CGFloat {
            switch edge {
            case .top, .leading, .trailing: return rect.minY
            case .bottom: return rect.maxY - width
            }
        }
        
        var w: CGFloat {
            switch edge {
            case .top, .bottom: return rect.width
            case .leading, .trailing: return self.width
            }
        }
        
        var h: CGFloat {
            switch edge {
            case .top, .bottom: return self.width
            case .leading, .trailing: return rect.height
            }
        }
        
        return Path( CGRect(x: x, y: y, width: w, height: h) )
    }
}

extension View {
    func border(width: CGFloat, edge: Edge, color: Color) -> some View {
        ZStack {
            self
            EdgeBorder(width: width, edge: edge).foregroundColor(color)
        }
    }
}



struct ScoreCardView_Previews: PreviewProvider {
    
    static var previews: some View {
        Group {
            BindingProvider(Game()) { binding in
                ScoreCardView(playerScore: binding.playerScores[0], size: .normal, backGroundGradient: gradiants[Int.random(in: 0 ..< 20)])
                    .previewLayout(.fixed(width: 375, height: 200))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
            }
            BindingProvider(PlayerScore(player: Player(), pointsList: [100])) { binding in
                ScoreCardView(playerScore: binding, size: .normal, backGroundGradient: gradiants[Int.random(in: 0 ..< 20)])
                    .previewLayout(.fixed(width: 375, height: 300))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
            }
            BindingProvider(Game()) { binding in
                ScoreCardView(playerScore: binding.playerScores[1], size: .compact, backGroundGradient: gradiants[Int.random(in: 0 ..< 20)])
                    .previewLayout(.fixed(width: 375, height: 300))
                    .padding(.horizontal, 15)
                    .padding(.bottom,15)
            }
//            BindingProvider(Game()) { binding in
//                VStack {
//                    Spacer()
//                    ScoreCardView(playerScore: binding.playerScores[0], size: .normal, backGroundGradient: gradiants[Int.random(in: 0 ..< 12)])
//                }
//
//            }
        }
        
    }
}
