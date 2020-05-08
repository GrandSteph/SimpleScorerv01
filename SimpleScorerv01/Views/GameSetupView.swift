//
//  GameSetupView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 5/7/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct GameSetupView: View {
    
    @State private var buttonSwitch = true
    
    let gradient = LinearGradient(gradient: Gradient(colors: [.blue, .green, .purple, .red]),
                                  startPoint: .topLeading,
                                  endPoint: .bottomTrailing)
    
    let borderGradient = LinearGradient(gradient: Gradient(colors: [.offWhite, .white]),
                                        startPoint: .top,
                                        endPoint: .bottom)
    
    var body: some View {
        
        ZStack {
            Color.offWhite.edgesIgnoringSafeArea(.all)
            
            HStack {
                Spacer()
                VStack (spacing : 20) {
                    Spacer()
                    
                    Rectangle().cornerRadius(14).frame(height: 100).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                    Rectangle().cornerRadius(14).frame(height: 100).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                    
                    if self.buttonSwitch {
                        Rectangle().cornerRadius(14).frame(height: 100).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                    } else {
                        Rectangle().cornerRadius(14).frame(height: 100).shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 10)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()
            
            gradient
                .mask(
                    HStack {
                        Spacer()
                        VStack (spacing : 20) {
                            Spacer()
                            
                            Rectangle().cornerRadius(14).frame(height: 100)
                            
                            Rectangle().cornerRadius(14).frame(height: 100)
                            
                            if self.buttonSwitch {
                                Rectangle().cornerRadius(14).frame(height: 100)
                            } else {
                                Rectangle().cornerRadius(14).frame(height: 100)
                            }
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
                        .frame(height: 100)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation{
                                self.buttonSwitch.toggle()
                            }
                        }
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.offWhite, lineWidth: 1)
                        )
                        .overlay(
                                Text("NEW GAME")
                                    .fontWeight(.semibold)
                                    .font(.system(.largeTitle, design: .rounded))
                                    .modifier(ScalableLabelFont())
                                    .padding()
                        )
                    
                    
                    Rectangle()
                        .stroke(lineWidth: 0)
                        .cornerRadius(14)
                        .frame(height: 100)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            withAnimation{
                                self.buttonSwitch.toggle()
                            }
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.offWhite, lineWidth: 1)
                    )
                    .overlay(
                        Text("RESUME PREVIOUS GAME")
                            .font(.system(.title, design: .rounded))
                            .modifier(ScalableLabelFont())
                            .padding()
                    )
                    
                    if self.buttonSwitch {
                        Rectangle()
                            .stroke(lineWidth: 0)
                            .cornerRadius(14)
                            .frame(height: 100)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    self.buttonSwitch.toggle()
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.offWhite, lineWidth: 1)
                            )
                            .overlay(
                                Text("CHANGE PLAYERS")
                                    .font(.system(.title, design: .rounded))
                                    .modifier(ScalableLabelFont())
                                    .padding()
                            )

                    } else {
                        Rectangle()
                            .stroke(lineWidth: 0)
                            .cornerRadius(14)
                            .frame(height: 100)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                withAnimation {
                                    self.buttonSwitch.toggle()
                                }
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.offWhite, lineWidth: 1)
                            )
                            .overlay(
                                Text("CANCEL")
                                    .font(.system(.title, design: .rounded))
                                    .modifier(ScalableLabelFont())
                                    .padding()
                            )

                    }
                    
                    Spacer()
                }
                Spacer()
            }
            .padding()
            //            Rectangle().fill(buttonSwitch ? Color.cyan1 : Color.orangeStart).frame(width: 200, height: 50).clipShape(Rectangle()).cornerRadius(14)
        }
    }
}



struct GameSetupView_Previews: PreviewProvider {
    static var previews: some View {
        GameSetupView()
    }
}


