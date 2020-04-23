//
//  Score.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import Foundation

struct PlayerScore: Identifiable, Hashable {
    
    var id = UUID()
    let player: Player
    var pointsList: [Int]     

    
    func totalScore() -> Int {
        return pointsList.reduce(0, +)
    }
    
    mutating func addPoints(scoreValue: Int) {
        pointsList.append(scoreValue)
    }
    
    func modifyScore(modification: Int, andRound: Int) {
    }    
}
