//
//  Game.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

class Game : ObservableObject {
    
    @Published var playerScores = [PlayerScore] ()
    
    func addPlayer(player: Player) {
        playerScores.append(PlayerScore(player: player, pointsList: []))
    }
    
//    mutating func addPlayer(player: Player, with pointList: [Int]) {
//        playerScores.append(PlayerScore(player: player, pointsList: pointList))
//    }
    
    func findScore(playerScore: PlayerScore) -> PlayerScore {
        return playerScores[playerScores.firstIndex(where: {$0.id == playerScore.id})!]
    }
    
    func indexOf(player : Player) -> Int? {
        for index in self.playerScores.indices {
            if self.playerScores[index].player.id == player.id {
                return index
            }
        }
        
        return nil
    }
    
//    mutating func addScore(pointsValue: Int, playerScoreID: PlayerScore.ID) {
//        playerScores[playerScores.firstIndex(where: {$0.id == playerScoreID})!].addPoints(scoreValue: pointsValue)
//    }
    
    func addEmptyPlayer() {
        
        self.addPlayer(player: Player())
    }
    
    func addEmptyPlayer(with gradient : LinearGradient) {
        var player = Player()
        player.colorGradient = gradient
        self.addPlayer(player: player)
    }
    
    func removeLastPlayer() {
        if playerScores.count > 0 {
            playerScores.removeLast()
        }
    }
    
    func removePlayer(player : Player) {
        self.playerScores.remove(at: self.indexOf(player: player)!)
    }
    
    func resetScores () {
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
    
    func checkIdenticalName(name : String) -> Bool {
        for playerScore in self.playerScores {
            if name.caseInsensitiveCompare(playerScore.player.name) == .orderedSame {
                return true
            }
        }
        
        return false
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
    
    func addTestPlayers (){
        
//        self.addPlayer(player: Player(name: "Steph", photoImage: UIImage(named: "steph-test"), colorGradient: gradiants[0]))
//        self.addPlayer(player: Player(name: "Sof", photoImage: UIImage(named: "vertical"), colorGradient: gradiants[1]))
//        self.addPlayer(player: Player(name: "Chloé", photoImage: UIImage(named: "chloe"), colorGradient: gradiants[3]))
//        self.addPlayer(player: Player(name: "Gaby", photoImage: UIImage(named: "gaby"), colorGradient: gradiants[4]))
//        
        self.addPlayer(player: Player(name: "Karine",  colorGradient: gradiants[Int.random(in: 0 ..< 5)]))
        self.addPlayer(player: Player(name: "Vincent",  colorGradient: gradiants[Int.random(in: 5 ..< 10)]))
        self.addPlayer(player: Player(name: "Mat",  colorGradient: gradiants[Int.random(in: 10 ..< 15)]))
        self.addPlayer(player: Player(name: "Gaby",  colorGradient: gradiants[Int.random(in: 15 ..< 20)]))
        
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 0 ..< 5)])
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 5 ..< 10)])
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 10 ..< 15)])
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 15 ..< 20)])
        
        
//                self.playerScores[0].addPoints(scoreValue: 123)
//        //
//                self.playerScores[1].addPoints(scoreValue: 1234)
//                self.playerScores[2].addPoints(scoreValue: 12345)
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
    convenience init(withTestPlayers: Void) {
        self.init()
        self.addTestPlayers()
    }
}


