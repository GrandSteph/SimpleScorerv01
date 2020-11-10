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
    @Published var roundsLabels = [Int] ()
    
    // MARK: - Player functins
    func addPlayer(player: Player) {
        playerScores.append(PlayerScore(player: player, pointsList: []))
    }
    
    func indexOf(player : Player) -> Int? {
        for index in self.playerScores.indices {
            if self.playerScores[index].player.id == player.id {
                return index
            }
        }
        return nil
    }
    
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
    
    func avatarInitialsForPlayer(player : Player) -> String {
        
        var initials = player.name.uppercased().prefix(1)
        
        for playerScore in self.playerScores {
            
            if player.id != playerScore.player.id {
                
                if player.name.uppercased().first == playerScore.player.name.first {
                    
                    let difference = zip(player.name.uppercased(), playerScore.player.name.uppercased()).filter{ $0 != $1 }
                    
                    if difference.count > 0 {
                        
                        guard let secondChar = difference.first(where: { ($0.0 != $0.1) && ($0.0 != player.name.uppercased().first)}) else {
                            return String(initials)
                        }
                        
                        initials += String(secondChar.0).lowercased()
//                        return String(initials)
                    }
                }
            }
        }
        return String(initials)
    }
    
    // MARK: - Score functions
    
    func addPointsFor(player : Player, points : Int) {
        
        let nbrOfRounds = self.currentMaxNumberOfRounds()
        
        if self.playerScores[self.indexOf(player: player)!].pointsList.count == nbrOfRounds {
            self.roundsLabels.append(nbrOfRounds+1)
            self.playerScores[self.indexOf(player: player)!].addPoints(scoreValue: points)
        } else if self.playerScores[self.indexOf(player: player)!].pointsList.count == (nbrOfRounds - 1) {
            self.playerScores[self.indexOf(player: player)!].addPoints(scoreValue: points)
        } else {
            self.playerScores[self.indexOf(player: player)!].addPoints(scoreValue: 0)
            self.addPointsFor(player: player, points: points)
        }
    }
    
    func deletePointsFor(player : Player, round : Int) {
        let index = self.indexOf(player: player)!
        
        self.playerScores[index].pointsList.remove(at: round)
        
        // Adjust roundNbr for all points
        // (Decrease round for those after)
        for point in self.playerScores[index].pointsList {
            if point.round > round {
                let pointIndex = self.playerScores[index].indexFor(round: point.round)!
                self.playerScores[index].pointsList[pointIndex].round -= 1
            }
        }
        
        for point in self.playerScores[index].pointsList {
            print(point.round)
        }
    }
    
    func findScore(playerScore: PlayerScore) -> PlayerScore {
        return playerScores[playerScores.firstIndex(where: {$0.id == playerScore.id})!]
    }
    
    func resetScores () {
        for (index, _) in playerScores.enumerated() {
            playerScores[index].resetScore()
        }
        
    }
    
//    func maxScore() -> Int {
//        var maxScore = Int (0)
//        for score in self.playerScores {
//            if maxScore < score.totalScore()  {
//                maxScore = score.totalScore()
//            }
//        }
//        return maxScore
//    }
    
    func currentMaxNumberOfRounds() -> Int {
        var maxNbrRounds = 0
        for score in self.playerScores {
            if score.pointsList.count > maxNbrRounds  {
                maxNbrRounds = score.pointsList.count
            }
        }
        return maxNbrRounds
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
        self.addPlayer(player: Player(name: "Emma", initials: "Em",  colorGradient: gradiants[Int.random(in: 1 ..< 5)]))
        self.addPlayer(player: Player(name: "Marc", initials: "M",  colorGradient: gradiants[Int.random(in: 5 ..< 10)]))
        self.addPlayer(player: Player(name: "Mat", initials: "Mt",  colorGradient: gradiants[Int.random(in: 10 ..< 15)]))
        self.addPlayer(player: Player(name: "Eva", initials: "Ev",  colorGradient: gradiants[Int.random(in: 15 ..< 20)]))
        self.addPlayer(player: Player(name: "Louis", initials: "Lo",  colorGradient: gradiants[Int.random(in: 1 ..< 20)]))
        self.addPlayer(player: Player(name: "Zoe", initials: "Z",  colorGradient: gradiants[Int.random(in: 1 ..< 20)]))
        self.addPlayer(player: Player(name: "Gabriel", initials: "G",  colorGradient: gradiants[Int.random(in: 1 ..< 20)]))
        self.addPlayer(player: Player(name: "Emily", initials: "El",  colorGradient: gradiants[Int.random(in: 1 ..< 20)]))
        self.addPlayer(player: Player(name: "Chris", initials: "C",  colorGradient: gradiants[Int.random(in: 1 ..< 20)]))
        self.addPlayer(player: Player(name: "Steve", initials: "S",  colorGradient: gradiants[Int.random(in: 1 ..< 20)]))
        
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 0 ..< 5)])
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 5 ..< 10)])
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 10 ..< 15)])
//        self.addEmptyPlayer(with: gradiants[Int.random(in: 15 ..< 20)])
        
        self.playerScores[0].addPoints(scoreValue: -1)
        self.playerScores[0].addPoints(scoreValue: -2)
        self.playerScores[0].addPoints(scoreValue: 5)
        self.playerScores[0].addPoints(scoreValue: 7)
        self.playerScores[0].addPoints(scoreValue: 10)
        self.playerScores[0].addPoints(scoreValue: -12)
        self.playerScores[0].addPoints(scoreValue: 8)
        self.playerScores[0].addPoints(scoreValue: 13)
        self.playerScores[0].addPoints(scoreValue: 20)
        self.playerScores[0].addPoints(scoreValue: 12)
        self.playerScores[0].addPoints(scoreValue: 9)
        self.playerScores[0].addPoints(scoreValue: 0)
        self.playerScores[0].addPoints(scoreValue: 3)
        self.playerScores[0].addPoints(scoreValue: -12)
        self.playerScores[0].addPoints(scoreValue: -1)
        self.playerScores[0].addPoints(scoreValue: 5)
        self.playerScores[0].addPoints(scoreValue: 7)
        self.playerScores[0].addPoints(scoreValue: 7)
        
        self.playerScores[1].addPoints(scoreValue: 10)
        self.playerScores[1].addPoints(scoreValue: 11)
        self.playerScores[1].addPoints(scoreValue: 1)
        self.playerScores[1].addPoints(scoreValue: 13)
        self.playerScores[1].addPoints(scoreValue: 0)
        self.playerScores[1].addPoints(scoreValue: -1)
        self.playerScores[1].addPoints(scoreValue: -2)
        self.playerScores[1].addPoints(scoreValue: -5)
        self.playerScores[1].addPoints(scoreValue: 8)
        self.playerScores[1].addPoints(scoreValue: 10)
        self.playerScores[1].addPoints(scoreValue: 10)
        self.playerScores[1].addPoints(scoreValue: 10)
        self.playerScores[1].addPoints(scoreValue: 6)
        self.playerScores[1].addPoints(scoreValue: 7)
        self.playerScores[1].addPoints(scoreValue: 3)
        self.playerScores[1].addPoints(scoreValue: 7)
        self.playerScores[1].addPoints(scoreValue: 7)
        self.playerScores[1].addPoints(scoreValue: 7)

        self.playerScores[2].addPoints(scoreValue: 2)
        self.playerScores[2].addPoints(scoreValue: 20)
        self.playerScores[2].addPoints(scoreValue: 22)
        self.playerScores[2].addPoints(scoreValue: 2)
        self.playerScores[2].addPoints(scoreValue: 2)
        self.playerScores[2].addPoints(scoreValue: 2)
        self.playerScores[2].addPoints(scoreValue: 24)
        self.playerScores[2].addPoints(scoreValue: -2)
        self.playerScores[2].addPoints(scoreValue: 6)
        self.playerScores[2].addPoints(scoreValue: 4)
        self.playerScores[2].addPoints(scoreValue: 4)
        self.playerScores[2].addPoints(scoreValue: 4)
        self.playerScores[2].addPoints(scoreValue: 2)
        self.playerScores[2].addPoints(scoreValue: -1)
        self.playerScores[2].addPoints(scoreValue: 12)
        self.playerScores[2].addPoints(scoreValue: 22)
        self.playerScores[2].addPoints(scoreValue: 32)
        self.playerScores[2].addPoints(scoreValue: 2)

        self.playerScores[3].addPoints(scoreValue: 1)
        self.playerScores[3].addPoints(scoreValue: 2)
        self.playerScores[3].addPoints(scoreValue: 3)
        self.playerScores[3].addPoints(scoreValue: 4)
        self.playerScores[3].addPoints(scoreValue: -4)
        self.playerScores[3].addPoints(scoreValue: 32)
        self.playerScores[3].addPoints(scoreValue: 103)
        self.playerScores[3].addPoints(scoreValue: 3)
        self.playerScores[3].addPoints(scoreValue: 2)
        self.playerScores[3].addPoints(scoreValue: -30)
        self.playerScores[3].addPoints(scoreValue: 4)
        self.playerScores[3].addPoints(scoreValue: 22)
        self.playerScores[3].addPoints(scoreValue: 0)
        self.playerScores[3].addPoints(scoreValue: 0)
        self.playerScores[3].addPoints(scoreValue: 13)
        self.playerScores[3].addPoints(scoreValue: 53)
        self.playerScores[3].addPoints(scoreValue: -43)
        self.playerScores[3].addPoints(scoreValue: 3)
//

        
        for n in 1...18 {
            self.roundsLabels.append(n)
        }
    }
    
}

extension Game {
    convenience init(withTestPlayers: Void) {
        self.init()
        self.addTestPlayers()
    }
}


