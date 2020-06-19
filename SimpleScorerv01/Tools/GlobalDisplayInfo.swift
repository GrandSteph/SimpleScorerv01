//
//  GlobalDisplayInfo.swift
//  SimpleScorerv01
//
//  Created by Dev on 5/26/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

class GlobalDisplayInfo: ObservableObject {
    
    @Published var screenDisplayed = ScreenType.allScores
    @Published var indexOFTextfieldFocused : Int = 1000
    @Published var gradients = gradiants.shuffled()
    @Published var scoreCardSize = CardSize.normal
    @Published var shouldScroll = true

    func setSizeAndScroll (nbrPlayers : Int) {
        
        self.shouldScroll = false
        self.scoreCardSize = .normal
        
        if nbrPlayers > 4 {
            self.scoreCardSize = .compact
            
            if nbrPlayers > 6 {
                self.shouldScroll = true
            }
        }
        
        if nbrPlayers == 0 {
            self.screenDisplayed = .gameSetup
        }
        
        self.shouldScroll = true
    }
}

