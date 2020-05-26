//
//  GlobalDisplayInfo.swift
//  SimpleScorerv01
//
//  Created by Dev on 5/26/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

class GlobalDisplayInfo: ObservableObject {
    @Published var isGameSetupVisible : Bool = true
    @Published var nextAvailableInt : Int = 0
    
    func getNextAvailableInt() -> Int {
        nextAvailableInt += 1
        return self.nextAvailableInt
    }
}

