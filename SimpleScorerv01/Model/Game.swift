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
        playerScores.append(PlayerScore(player: player, pointsList: [0,1,2]))
    }
    
    func addPlayer(player: Player, score: Int) {
        players.append(player)
        playerScores.append(PlayerScore(player: player, pointsList: [score]))
    }
    
    func indexOfPlayerInScores(player: Player) -> Int {
        return  playerScores.firstIndex(where: {$0.player.id == player.id})!
    }
    
    init () {
//        self.addPlayer(player: Player(name: "Gabriel", shortName: "Gaby", photoURL:"gaby", color: Color(.sRGB,red: 255/255, green: 195/255, blue: 11/255)))
//        self.addPlayer(player: Player(name: "Gabriel", shortName: "Gaby", photoURL:"gaby", color: Color(.sRGB,red: 255/255, green: 195/255, blue: 11/255)))
//        self.addPlayer(player: Player(name: "Gabriel", shortName: "Gaby", photoURL:"gaby", color: Color(.sRGB,red: 255/255, green: 195/255, blue: 11/255)))
//        self.addPlayer(player: Player(name: "Gabriel2", shortName: "Gaby", photoURL:"gaby", color: Color(.sRGB,red: 255/255, green: 195/255, blue: 11/255)))
        self.addPlayer(player: Player(name: "Stephane", shortName: "Steph", photoURL:"steph", color: Color(.sRGB,red: 90/255, green: 197/255, blue: 191/255)))
        self.addPlayer(player: Player(name: "Sophie", shortName: "Sof", photoURL:"sof", color: Color(.sRGB, red: 189/255, green: 0/255, blue: 82/255)))
        self.addPlayer(player: Player(name: "Chloe", shortName: "Chloe", photoURL:"chloe", color: Color(.sRGB,red: 251/255, green: 78/255, blue: 84/255)))
        self.addPlayer(player: Player(name: "Gabriel", shortName: "Gaby", photoURL:"gaby", color: Color(.sRGB,red: 255/255, green: 195/255, blue: 11/255)))
    }
    

}
