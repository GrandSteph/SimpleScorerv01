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
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    var id = UUID()
    var name: String
//    var photoURL: String?
    var photoImage: UIImage?
    var colorGradient: LinearGradient
}

extension Player {
    
    static let defaultName = "Name ?"
    
    init() {
        self.name = Player.defaultName
        self.colorGradient = LinearGradient.gradDefault
    }
    
    
}
