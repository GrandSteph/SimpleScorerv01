//
//  PlayersEntryView.swift
//  SimpleScorerv01
//
//  Created by Dev on 6/4/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct PlayersEntryView: View {
    
    @Binding var game : Game
    
    var frameHeight = CGFloat(90)
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    @State private var username : String = ""
    
    @State private var cardViews = [CardView]()
    
    var body: some View {
        ZStack {
            
            Color.offWhite.edgesIgnoringSafeArea(.all).zIndex(-2)
            
            ZStack {
                ForEach(cardViews) { cardView in
                    cardView
                        .frame(height: self.frameHeight)
                        .clipShape(Rectangle()).cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                        .zIndex(self.zIndex(for: cardView.playerScore))
                        .offset(self.offset(for: cardView.playerScore))
                        .scaleEffect(self.scale(for: cardView.playerScore))
                        .padding()
                        .animation(.spring()).transition(.slide)
                        .onTapGesture {
                            self.cardViews.removeLast()
                        }
                    
                }
            }.onAppear {
                self.buildCardViews()
            }
        }
    }
    
    private func buildCardViews () {
  
        for playerScore in game.playerScores {
            let index = self.game.playerScores.firstIndex(where: { $0.id == playerScore.id })
            
            self.cardViews.append(CardView(playerScore: self.$game.playerScores[index!]))
        }
    }
    
    private func index(for playerScore: PlayerScore) -> Int? {

        guard let index = self.cardViews.firstIndex(where: { $0.playerScore.id == playerScore.id }) else {
            return nil
        }
        
//        print("\(playerScore.player.name) - \(self.cardViews.count) - \(index)")

        return index
    }
    
    private func zIndex(for playerScore: PlayerScore) -> Double {

        guard let cardIndex = index(for: playerScore) else {
            return 0.0
        }

        return -Double(self.cardViews.count - cardIndex)
    }

    private func offset(for playerScore: PlayerScore) -> CGSize {

        guard let cardIndex = index(for: playerScore) else {
            return CGSize()
        }
        
//        if self.cardViews.count == 0 { return CGSize(width: 0, height: -20 * CGFloat(cardIndex)) }
        
        return CGSize(width: 0, height: -20 * CGFloat(self.cardViews.count - cardIndex - 1))
    }
    
    private func scale(for playerScore: PlayerScore) -> CGFloat {

        guard let cardIndex = index(for: playerScore) else {
            return 1
        }

        return CGFloat(100 - (self.cardViews.count - cardIndex - 1)*10)/100
    }
}

struct CardView: Identifiable, View {
    
    let id = UUID()
    @Binding var playerScore : PlayerScore
    
    @State private var username = ""
    let frameHeight = CGFloat(90)
    
    var body: some View {
        ZStack {
        
            playerScore.player.colorGradient
            
            VStack {
                
                Spacer()
                
                HStack {
                    
                    AvatarView(user: $playerScore.player)
                        .padding(10)
                        .frame(width: self.frameHeight, height: self.frameHeight)
                    
                    
                    TextField("Player \(playerScore.player.name)", text: $username, onEditingChanged: {change in }, onCommit: {
                        
                    })
                    
                    Rectangle().fill(Color.clear)
                        .border(width: 1, edge: .leading, color: .offWhite)
                        .overlay(Image(systemName: "chevron.right").foregroundColor(Color.white))
                        .frame(width: 60, height: self.frameHeight)
                        
                    }
                
                Spacer()
                }
            
                
        }
    }
}

struct PlayersEntryView_Previews: PreviewProvider {
    static var previews: some View {
        BindingProvider(Game(withTestPlayers: ())) { binding in
            PlayersEntryView(game: binding)
        }
    }
}
