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
    var favoriteColor = Color.white
    
    init (name: String, shortName: String, photoURL: String, color: Color) {
        self.name = name
        self.shortName = shortName
        self.photoURL = photoURL
        self.favoriteColor = color
    }
    
}
