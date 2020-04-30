//
//  Player.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI
import Combine

struct Player: Identifiable {
    
    var id = UUID()
    var name: String
//    var photoURL: String?
    var photoImage: UIImage?
    var colorStart: Color
    var colorEnd: Color
    
    
    func defaultPlayer() -> Player {
        return Player()
    }
    
}

extension Player {
    init() {
        self.name = "Default Name"
        self.colorStart = Color(red: 241 / 255, green: 242 / 255, blue: 181 / 255)
        self.colorEnd = Color(red: 18 / 255, green: 80 / 255, blue: 88 / 255)
    }

}
