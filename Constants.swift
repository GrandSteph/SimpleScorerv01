//
//  Constants.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/27/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
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
    

    
    static let offWhite = Color(red: 235 / 255, green: 235 / 255, blue: 245 / 255)
    

}

struct SimpleRectButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(30)
            .contentShape(Rectangle())
            .frame(maxWidth:.infinity, maxHeight: 47)
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

struct BindingProvider<StateT, Content: View>: View {

    @State private var state: StateT
    private var content: (_ binding: Binding<StateT>) -> Content

    init(_ initialState: StateT, @ViewBuilder content: @escaping (_ binding: Binding<StateT>) -> Content) {
        self.content = content
        self._state = State(initialValue: initialState)
    }

    var body: some View {
        self.content($state)
    }
}
