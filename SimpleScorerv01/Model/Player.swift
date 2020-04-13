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
    
//    init (name: String, shortName: String, photoURL: String, color: Color) {
//        self.name = name
//        self.shortName = shortName
//        self.photoURL = photoURL
//        self.color = color
//    }
    
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
    }
}
