//
//  PlayersNameEntry.swift
//  SimpleScorerv01
//
//  Created by Dev on 6/2/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct PlayersNameEntry: View {
    
    @Binding var game : Game
    @Binding var isVisible : Bool
    
    // This is a copy of the number of players to allows smooth move between textfields
    // It's easier to just become first responsder when the textfield is last
    // Since I can't remove players from game, I make a copy and manage it in textField
    // and commitAndMove
    @State private var textFields = [Int]()
    
    // Master username. Updated by label in TaggedTextField
    @State private var username : String = ""
    
    let gradients = gradiants.shuffled()
    var frameHeight = CGFloat(90)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                ForEach(self.game.playerScores) { playerScore in
                    //            ForEach(game.playerScores.indices) { i in
                    
                    
                    //                Text(self.game.playerScores[i].player.name)
                    
                    if playerScore.player.name == Player.defaultName {
                        ZStack {
                            
                            self.gradients[self.index(for: playerScore)!]
                            
                            VStack {
                                
                                Spacer()
                                
                                HStack {
                                    
                                    AvatarView(user: self.$game.playerScores[self.index(for: playerScore)!].player)
                                        .padding(10)
                                        .frame(width: self.frameHeight, height: self.frameHeight)
                                    
                                    
                                    TaggedTextField(username: self.$username, tag: self.index(for: playerScore)!, parentView: self, textFields: self.$textFields)
                                    
                                    Rectangle().fill(Color.clear)
                                        .border(width: 1, edge: .leading, color: .offWhite)
                                        .overlay(Image(systemName: "chevron.right").foregroundColor(Color.white))
                                        .frame(minWidth:60, maxWidth:60, maxHeight: .infinity)
                                        .onTapGesture {
                                            self.commitNameAndMove(forIndex: self.index(for: playerScore)!)
                                    }
                                }
                                
                                Spacer()
                            }
                        }
                        .frame(height: self.frameHeight)
                        .clipShape(Rectangle()).cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                        .zIndex(self.zIndex(for: self.game.playerScores[self.index(for: playerScore)!]))
//                        .offset(self.offset(for: self.game.playerScores[self.index(for: playerScore)!]))
                    }
                }
            }
            .padding()
        }
    }
    
    func commitNameAndMove(forIndex i : Int) {
        
        var allPlayersHaveNames = true
        
        self.game.playerScores[i].player.name = self.username
        self.game.playerScores[i].player.colorGradient = self.gradients[i]
        if self.textFields.last != nil {
            if self.textFields.last! == i {
                print("\(self.textFields) - \(i)")
                self.textFields.removeLast()
            }
        }
        
        for playerScore in self.game.playerScores {
            print("name \(playerScore.player.name) for tag \(i)")
            if playerScore.player.name == Player.defaultName {
                allPlayersHaveNames = false
            }
            
        }
        if allPlayersHaveNames {
            self.isVisible = false
        }
    }
    
    private func zIndex(for playerScore: PlayerScore) -> Double {
        guard let cardIndex = index(for: playerScore) else {
            return 0.0
        }
        
        return -Double(cardIndex)
    }
    
    private func index(for playerScore: PlayerScore) -> Int? {
        
        guard let index = self.game.playerScores.firstIndex(where: { $0.id == playerScore.id }) else {
            return nil
        }
        
        return index
    }
    
    private func offset(for playerScore: PlayerScore) -> CGSize {
        
        guard let cardIndex = index(for: playerScore) else {
            return CGSize()
        }
        
        return CGSize(width: 0, height: -50 * CGFloat(cardIndex))
    }
}

struct TaggedTextField: View {
    
    @Binding var username : String
    let tag : Int
    var parentView : PlayersNameEntry
    @Binding var textFields : [Int]
    @State private var label = ""
    
    var body: some View {
        TextField("Player #\(tag+1)", text: $label, onEditingChanged: {change in }, onCommit: {
            self.username = self.label
            self.parentView.commitNameAndMove(forIndex: self.tag)
        })
            .introspectTextField { textField in
                textField.tag = self.tag
                if !self.textFields.contains(self.tag) {
                    self.textFields.append(self.tag)
                }
                
                if self.textFields.last! == self.tag {
                    textField.becomeFirstResponder()
                }
        }
        .font(.system(.largeTitle, design: .rounded))
        .background(Color.offWhite.opacity(0.6))
        .foregroundColor(Color.offWhite)
        .foregroundColor(Color .offWhite)
    }
}

struct PlayersNameEntry_Previews: PreviewProvider {
    static var previews: some View {
        BindingProvider(Game(withTestPlayers: ())) { binding in
            PlayersNameEntry(game: binding, isVisible: .constant(true))
        }
        
    }
}
