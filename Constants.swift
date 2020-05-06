//
//  Constants.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/27/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

enum CardSize {
    case
    tiny ,
    compact ,
    normal
}

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

extension LinearGradient {
    init(_ colors: Color...) {
        self.init(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    static let grad1 =  LinearGradient(Color(hex: 0x0f2027),Color(hex: 0x203a43),Color(hex: 0x2c5364))
    static let grad2 =  LinearGradient(Color(hex: 0x7f7fd5),Color(hex: 0x86a8e7),Color(hex: 0x91eae4))
    static let grad3 =  LinearGradient(Color(hex: 0xa770ef),Color(hex: 0xcf8bf3),Color(hex: 0xfdb99b))
    static let grad4 =  LinearGradient(Color(hex: 0x3a7bd5),Color(hex: 0x3a6073))
    static let grad5 =  LinearGradient(Color(hex: 0x43cea2),Color(hex: 0x185a9d))
    static let grad6 =  LinearGradient(Color(hex: 0x4568DC),Color(hex: 0xB06AB3))
    static let grad7 =  LinearGradient(Color(hex: 0x2193b0),Color(hex: 0x6dd5ed))
    static let grad8 =  LinearGradient(Color(hex: 0x00b09b),Color(hex: 0x96c93d))
    static let grad9 =  LinearGradient(Color(hex: 0xfeac5e),Color(hex: 0xc779d0),Color(hex: 0x4bc0c8))
    static let grad10 =  LinearGradient(Color(hex: 0xf09819),Color(hex: 0xedde5d))
    static let grad11 =  LinearGradient(Color(hex: 0xf79d00),Color(hex: 0x64f38c))
    static let grad12 =  LinearGradient(Color(hex: 0xef32d9),Color(hex: 0x89fffd))

}

extension Color {

    init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(UIColor(red: components.R, green: components.G, blue: components.B, alpha: 1))
    }

}





