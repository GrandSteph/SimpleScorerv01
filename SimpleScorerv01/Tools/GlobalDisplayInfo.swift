//
//  GlobalDisplayInfo.swift
//  SimpleScorerv01
//
//  Created by Dev on 5/26/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

class GlobalDisplayInfo: ObservableObject {
    @Published var isGameSetupVisible : Bool = false
    @Published var indexOFTextfieldFocused : Int = 1000
    @Published var gradients = gradiants.shuffled()
    @Published var scoreCardSize = CardSize.normal
    @Published var shouldScroll = false
        
}

