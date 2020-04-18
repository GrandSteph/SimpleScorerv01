//
//  Player.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI
import Combine

struct Player: Identifiable, Hashable {
    
    var id = UUID()
    var name: String
    var shortName: String
    var photoURL: String
    var color: Color
    var colorStart: Color
    var colorEnd: Color
    
    
    func defaultPlayer() -> Player {
        return Player()
    }
    
}

extension Player {
    init() {
        self.name = "Default Name"
        self.shortName = "Def"
        self.photoURL = ""
        self.color = Color .orange
        self.colorStart = Color(red: 241 / 255, green: 242 / 255, blue: 181 / 255)
        self.colorEnd = Color(red: 18 / 255, green: 80 / 255, blue: 88 / 255)
    }

}
