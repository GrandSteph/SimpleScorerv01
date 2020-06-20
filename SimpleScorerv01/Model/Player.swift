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
    var name : String
    var initials : String
//    var photoURL: String?
    var photoImage: UIImage?
    var colorGradient: LinearGradient
}

extension Player {
    
    static let defaultName = "Name ?"
    
    init() {
        self.name = Player.defaultName
        self.colorGradient = LinearGradient.gradDefault
        self.initials = ""
    }
    
    
}
