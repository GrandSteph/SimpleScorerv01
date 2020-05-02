//
//  Game.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct Game {
    
    var players = [Player] ()
    var playerScores = [PlayerScore] ()
    
    mutating func addPlayer(player: Player) {
        players.append(player)
        playerScores.append(PlayerScore(player: player, pointsList: []))
    }
    
    mutating func addPlayer(player: Player, with pointList: [Int]) {
        players.append(player)
        playerScores.append(PlayerScore(player: player, pointsList: pointList))
    }
    
//    func findScore(playerScore: PlayerScore) -> PlayerScore {
//        return playerScores[playerScores.firstIndex(where: {$0 == playerScore})!]
//    }
    
    mutating func addScore(pointsValue: Int, playerScoreID: PlayerScore.ID) {
        playerScores[playerScores.firstIndex(where: {$0.id == playerScoreID})!].addPoints(scoreValue: pointsValue)
    }
    
    func maxScore() -> Int {
        var maxScore = Int (0)
        for score in self.playerScores {
            if maxScore < score.totalScore()  {
                maxScore = score.totalScore()
            }
        }
        return maxScore
    }
    
//    func ranking(for playerScore:PlayerScore) -> Int {
//
//        var ranking = 1
//
//        let playerScore = self.findScore(playerScore: playerScore).totalScore()
//
//        for score in self.playerScores {
//            if score.totalScore() > playerScore {
//                ranking += 1
//            }
//        }
//        return ranking
//    }
    
    init(players: [Player] = [], scores: [PlayerScore] = []) {
        self.players = players
        self.playerScores = scores
    }
    
    init () {
//        self.addPlayer(player: Player(name: "Stephane", photoImage: UIImage(named: "steph"), colorStart: Color.cyan1, colorEnd: Color.cyan2))
//        self.addPlayer(player: Player(name: "Sophie",   colorStart: Color.orangeStart, colorEnd: Color.orangeEnd))
//        self.addPlayer(player: Player(name: "Chloe", shortName: "Chloe", photoURL:"chloe", color: Color.blue, colorStart: Color.blueStart, colorEnd: Color.blueEnd))
//        self.addPlayer(player: Player(name: "Gabriel", shortName: "Gaby", photoURL:"gaby", color: Color.purple, colorStart: Color.purpleStart, colorEnd: Color.purpleEnd))
        
//        self.playerScores[0].addPoints(scoreValue: 13)
//        
//        self.playerScores[1].addPoints(scoreValue: 18)
//        self.playerScores[1].addPoints(scoreValue: 2)
//        self.playerScores[1].addPoints(scoreValue: 3)
//        
//        self.playerScores[2].addPoints(scoreValue: 24)
//        self.playerScores[2].addPoints(scoreValue: 2)
//        self.playerScores[2].addPoints(scoreValue: 3)
//        self.playerScores[2].addPoints(scoreValue: 4)
//        self.playerScores[2].addPoints(scoreValue: 5)
//        self.playerScores[2].addPoints(scoreValue: 6)
//        
//        self.playerScores[3].addPoints(scoreValue: 1)
//        self.playerScores[3].addPoints(scoreValue: 2)
//        self.playerScores[3].addPoints(scoreValue: 3)
//        self.playerScores[3].addPoints(scoreValue: 4)
//        self.playerScores[3].addPoints(scoreValue: 5)
//        self.playerScores[3].addPoints(scoreValue: 6)
//        self.playerScores[3].addPoints(scoreValue: 7)
//        self.playerScores[3].addPoints(scoreValue: 8)
//        self.playerScores[3].addPoints(scoreValue: 9)
    }
    

}
