//
//  Game.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct Game {
    
    var playerScores = [PlayerScore] ()
    
    mutating func addPlayer(player: Player) {
        playerScores.append(PlayerScore(player: player, pointsList: []))
    }
    
//    mutating func addPlayer(player: Player, with pointList: [Int]) {
//        playerScores.append(PlayerScore(player: player, pointsList: pointList))
//    }
    
//    func findScore(playerScore: PlayerScore) -> PlayerScore {
//        return playerScores[playerScores.firstIndex(where: {$0 == playerScore})!]
//    }
    
//    mutating func addScore(pointsValue: Int, playerScoreID: PlayerScore.ID) {
//        playerScores[playerScores.firstIndex(where: {$0.id == playerScoreID})!].addPoints(scoreValue: pointsValue)
//    }
    
    mutating func addEmptyPlayer() {
        
        self.addPlayer(player: Player())
    }
    
    mutating func addEmptyPlayer(with gradient : LinearGradient) {
        var player = Player()
        player.colorGradient = gradient
        self.addPlayer(player: player)
    }
    
    mutating func removePlayer() {
        if playerScores.count > 0 {
            playerScores.removeLast()
        }
    }
    
    mutating func resetScores () {
        for (index, _) in playerScores.enumerated() {
            playerScores[index].resetScore()
        }
        
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
    
    func needsNameEntry() -> Bool {
        
        var allPlayersHaveNames = true
        
        for playerScore in self.playerScores {
            print(playerScore.player.name)
            if playerScore.player.name == Player.defaultName {
                allPlayersHaveNames = false
            }
        }
        
        return !allPlayersHaveNames && self.playerScores.count > 0
    }
    
    func listNames() -> String {
        var names = ""
        for playerScore in self.playerScores {
            names += playerScore.player.name + "\n"
        }
        
        return names
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
    
    mutating func addTestPlayers (){
        
//        self.addPlayer(player: Player(name: "Steph", photoImage: UIImage(named: "steph-test"), colorGradient: gradiants[0]))
//        self.addPlayer(player: Player(name: "Sof", photoImage: UIImage(named: "vertical"), colorGradient: gradiants[1]))
//        self.addPlayer(player: Player(name: "Chloé", photoImage: UIImage(named: "chloe"), colorGradient: gradiants[3]))
//        self.addPlayer(player: Player(name: "Gaby", photoImage: UIImage(named: "gaby"), colorGradient: gradiants[4]))
//        
//        self.addPlayer(player: Player(name: "Karine",  colorGradient: gradiants[Int.random(in: 0 ..< 5)]))
//        self.addPlayer(player: Player(name: "Vince",  colorGradient: gradiants[Int.random(in: 5 ..< 10)]))
//        self.addPlayer(player: Player(name: "Mat",  colorGradient: gradiants[Int.random(in: 10 ..< 15)]))
//        self.addPlayer(player: Player(name: "Gaby",  colorGradient: gradiants[Int.random(in: 15 ..< 20)]))
        
        self.addEmptyPlayer(with: gradiants[Int.random(in: 0 ..< 5)])
        self.addEmptyPlayer(with: gradiants[Int.random(in: 5 ..< 10)])
        self.addEmptyPlayer(with: gradiants[Int.random(in: 10 ..< 15)])
        self.addEmptyPlayer(with: gradiants[Int.random(in: 15 ..< 20)])
        
        
//                self.playerScores[0].addPoints(scoreValue: 222)
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

extension Game {
    init(withTestPlayers: Void) {
        self.init()
        self.addTestPlayers()
    }
}


