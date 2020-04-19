//
//  Game.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI
import Combine

class Game: ObservableObject {
    
    var players = [Player] ()
    @Published var playerScores = [PlayerScore] ()
    
    func addPlayer(player: Player) {
        players.append(player)
        playerScores.append(PlayerScore(player: player, pointsList: []))
    }
    
    func addPlayer(player: Player, score: Int) {
        players.append(player)
        playerScores.append(PlayerScore(player: player, pointsList: [score]))
    }
    
    private func indexOfPlayerInScores(player: Player) -> Int? {
        return  playerScores.firstIndex(where: {$0.player.id == player.id})
    }
    
    func findScore(playerScoreId: PlayerScore.ID) -> PlayerScore {
        if playerScores.firstIndex(where: {$0.id == playerScoreId}) != nil {
            return playerScores[playerScores.firstIndex(where: {$0.id == playerScoreId})!]
        } else {
            return PlayerScore(player: Player(), pointsList: [1,2,3])
        }
        
    }
    
    func addScore(pointsValue: Int, playerScoreID: PlayerScore.ID) {
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
    
    func ranking(for player:Player) -> Int {
        
        var ranking = 1
        
        guard let index = self.indexOfPlayerInScores(player: player)
            else {
                return 1000
        }
        let playerScore = self.playerScores[index].totalScore()
        
        for score in self.playerScores {
            if score.totalScore() > playerScore {
                ranking += 1
            }
        }
        return ranking
    }
    
    init () {

        self.addPlayer(player: Player(name: "Stephane", shortName: "Steph", photoURL:"steph", color: Color(.sRGB, red: 189/255, green: 0/255, blue: 82/255), colorStart: Color.cyan1, colorEnd: Color.cyan2))
        self.addPlayer(player: Player(name: "Sophie", shortName: "Sof", photoURL:"sof", color: Color(.sRGB, red: 189/255, green: 0/255, blue: 82/255), colorStart: Color.orangeStart, colorEnd: Color.orangeEnd))
        self.addPlayer(player: Player(name: "Chloe", shortName: "Chloe", photoURL:"chloe", color: Color(.sRGB,red: 251/255, green: 78/255, blue: 84/255), colorStart: Color.blueStart, colorEnd: Color.blueEnd))
        self.addPlayer(player: Player(name: "Gabriel", shortName: "Gaby", photoURL:"gaby", color: Color(.sRGB,red: 255/255, green: 195/255, blue: 11/255), colorStart: Color.purpleStart, colorEnd: Color.purpleEnd))
        
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
