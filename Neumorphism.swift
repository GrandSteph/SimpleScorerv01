//
//  ContentView.swift
//  Neumorphism
//
//  Created by Paul Hudson on 25/02/2020.
//  Copyright © 2020 Paul Hudson. All rights reserved.
//

import SwiftUI

extension Color {
    
    static let purpleStart = Color(red: 84 / 255, green: 124 / 255, blue: 246 / 255)
    static let purpleEnd = Color(red: 125 / 255, green: 84 / 255, blue: 245 / 255)
        
    static let orangeStart = Color(red: 242 / 255, green: 169 / 255, blue: 100 / 255)
    static let orangeEnd = Color(red: 233 / 255, green: 107 / 255, blue: 157 / 255)
    
    static let blueStart = Color(red: 83 / 255, green: 181 / 255, blue: 242 / 255)
    static let blueEnd = Color(red: 85 / 255, green: 159 / 255, blue: 245 / 255)
    
    static let cyan1 = Color(red: 2 / 255, green: 170 / 255, blue: 176 / 255)
    static let cyan2 = Color(red: 0 / 255, green: 205 / 255, blue: 172 / 255)
    
    //
    
//    static let offOrange = Color(red: 225 / 255, green: 195 / 255, blue: 0 / 255)
//    static let orangeStart = Color(red: 245 / 255, green: 155 / 255, blue: 0 / 255)
//    static let orangeEnd = Color(red: 235 / 255, green: 195 / 255, blue: 0 / 255)
    
    static let offWhite = Color(red: 235 / 255, green: 235 / 255, blue: 245 / 255)
    static let whiteStart = Color(red: 225 / 255, green: 225 / 255, blue: 235 / 255)
    static let whiteEnd = Color(red: 195 / 255, green: 195 / 255, blue: 205 / 255)
    
    static let darkStart = Color(red: 50 / 255, green: 60 / 255, blue: 65 / 255)
    static let darkEnd = Color(red: 25 / 255, green: 25 / 255, blue: 30 / 255)
    
    static let lightStart = Color(red: 60 / 255, green: 160 / 255, blue: 240 / 255)
    static let lightEnd = Color(red: 30 / 255, green: 80 / 255, blue: 120 / 255)
    
    static let darkGray = Color(red: 50 / 255, green: 50 / 255, blue: 50 / 255)
}

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
    
    
}


struct SimpleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                Group {
                    if configuration.isPressed {
                        Circle()
                            .fill(Color.offWhite)
                            .overlay(
                                Circle()
                                    .stroke(Color.gray, lineWidth: 4)
                                    .blur(radius: 4)
                                    .offset(x: 2, y: 2)
                                    .mask(Circle().fill(LinearGradient(Color.black, Color.clear)))
                        )
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 8)
                                    .blur(radius: 4)
                                    .offset(x: -2, y: -2)
                                    .mask(Circle().fill(LinearGradient(Color.clear, Color.black)))
                        )
                    } else {
                        Circle()
                            .fill(Color.offWhite)
                            .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
                            .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
                    }
                }
        )
    }
}

struct LightBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.orangeStart, Color.orangeEnd))
                    .overlay(shape.stroke(LinearGradient(Color.orangeEnd, Color.orangeStart), lineWidth: 4))
                    .shadow(color: Color.whiteStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.whiteEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
//                    .fill(LinearGradient(Color.whiteStart, Color.whiteEnd))
                    .fill(Color.offWhite)
                    .overlay(shape.stroke(LinearGradient(Color.orangeStart, Color.orangeEnd), lineWidth: 4))
//                    .shadow(color: Color.white.opacity(0.4), radius: 10, x: -5, y: -5)
                    .shadow(color: Color.white, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.whiteEnd, radius: 10, x: 10, y: 10)
//                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 10, y: 10)
//                .shadow(color: Color.white.opacity(0.7), radius: 10, x: -5, y: -5)
            }
        }
    }
}

struct LightButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                LightBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
            .animation(nil)
    }
}

struct DarkBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.darkEnd, Color.darkStart))
                    .overlay(shape.stroke(LinearGradient(Color.darkStart, Color.darkEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(Color.darkEnd, lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}



struct DarkButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                DarkBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
            .animation(nil)
    }
}

struct DarkToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            DarkBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct ColorfulBackground<S: Shape>: View {
    var isHighlighted: Bool
    var shape: S
    
    var body: some View {
        ZStack {
            if isHighlighted {
                shape
                    .fill(LinearGradient(Color.lightEnd, Color.lightStart))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: 5, y: 5)
                    .shadow(color: Color.darkEnd, radius: 10, x: -5, y: -5)
            } else {
                shape
                    .fill(LinearGradient(Color.darkStart, Color.darkEnd))
                    .overlay(shape.stroke(LinearGradient(Color.lightStart, Color.lightEnd), lineWidth: 4))
                    .shadow(color: Color.darkStart, radius: 10, x: -10, y: -10)
                    .shadow(color: Color.darkEnd, radius: 10, x: 10, y: 10)
            }
        }
    }
}

struct ColorfulButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Circle())
            .background(
                ColorfulBackground(isHighlighted: configuration.isPressed, shape: Circle())
        )
            .animation(nil)
    }
}

struct ColorfulToggleStyle: ToggleStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            configuration.label
                .padding(30)
                .contentShape(Circle())
        }
        .background(
            ColorfulBackground(isHighlighted: configuration.isOn, shape: Circle())
        )
    }
}

struct Neumorphism: View {
    @State private var isToggled = true
    
    var body: some View {
        ZStack {
//            LinearGradient(Color.whiteStart, Color.whiteEnd)
            Color.offWhite
            
            
            VStack(spacing: 40) {
                
                HStack {
                    
                    
                    Button(action: {
                        
                    }) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                    }
                    .buttonStyle(SimpleButtonStyle())
                }
                .frame(maxWidth: .infinity, minHeight: 100).background(Color .offWhite)
                
                
                
                Button(action: {
                    
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(LightButtonStyle())
                
                
                
                
                Button(action: {
                    
                }) {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.white)
                }
                .buttonStyle(ColorfulButtonStyle())
                .frame(maxWidth: .infinity, minHeight: 150).background(LinearGradient(Color.darkStart, Color.darkEnd))
                //
                //                Toggle(isOn: $isToggled) {
                //                    Image(systemName: "heart.fill")
                //                        .foregroundColor(.white)
                //                }
                //                .toggleStyle(ColorfulToggleStyle())
                //
                //                Toggle(isOn: $isToggled) {
                //                    Image(systemName: "heart.fill")
                //                        .foregroundColor(.white)
                //                }
                //                .toggleStyle(DarkToggleStyle())
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        Neumorphism()
    }
}
