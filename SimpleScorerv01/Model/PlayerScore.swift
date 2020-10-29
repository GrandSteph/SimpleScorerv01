//
//  Score.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import Foundation

struct PlayerScore: Identifiable {
    
    var id = UUID()
    var player: Player
    var pointsList: [Int]     

    
    func totalScore() -> Int {
        return pointsList.reduce(0, +)
    }
    
    mutating func addPoints(scoreValue: Int) {
        pointsList.append(scoreValue)
    }
    
    mutating func modifyScore(modification: Int, forRound: Int) {
    }
    
    mutating func resetScore () {
        pointsList = []
    }
    
}

extension PlayerScore {
    init() {
        self.id = UUID()
        self.player = Player()
        self.pointsList = []
        
    }
}
