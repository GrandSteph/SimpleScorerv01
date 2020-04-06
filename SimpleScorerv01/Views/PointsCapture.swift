//
//  PointsCapture.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/24/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct PointsCapture: View {
    
    @EnvironmentObject var game : Game
    @Binding var isPresented: Bool
    @State private var displayValue = ""
    
    var playerScoreID: PlayerScore.ID
    
    let Numericalbuttons = [
        [7,8,9],
        [4,5,6],
        [1,2,3]]
    
    var body: some View {
        VStack(spacing: 0) {
//            CircleImage(image: Image("\(game.findScore(uuid: playerScoreID).player.photoURL)")).padding()
            CircleImage(image: Image("steph")).padding()
            
            Button(action: {
                
            }) {
                Text("\(self.displayValue)").font(.system(size: 35))
            }
            .foregroundColor(Color .white)
            .frame(width: 180, height: 60, alignment: .trailing)
            .padding(.horizontal)
            .overlay(Capsule().stroke(Color.white, lineWidth: 4))
            .padding()
            
            
            ForEach(self.Numericalbuttons, id: \.self) { row in
                HStack {
                    ForEach(row, id: \.self) { button in
                        Button(action: {
                            self.displayValue += String(button)
                            
                        }) {
                            Text("\(button)")
                        }
                        .buttonStyle(CircleButton())
                    }
                }
            }

            HStack {
                Button(action: {
                    self.displayValue = String(self.displayValue.dropLast())
                }) {
                    Image(systemName: "delete.left").font(.system(size: 25)).offset(x: -3, y: 0)
                }
                .buttonStyle(CircleButton())

                Button(action: {

                }) {
                    Text("0")
                }
                .buttonStyle(CircleButton())

                Button(action: {
                    if self.displayValue == "" {
                        self.displayValue = "0"
                    }
                    self.isPresented = false
                    let index = self.game.playerScores.firstIndex(where: {$0.id == self.playerScoreID})
                    self.game.playerScores[index!].addPoints(scoreValue: Int(self.displayValue)!)
                }) {
                    Image(systemName: "checkmark").font(.system(size: 25))
                }
                .buttonStyle(CircleButton())

            }
        }
        .padding()
        .background(Color(.sRGB,red: 90/255, green: 197/255, blue: 191/255))
        .cornerRadius(20)
        .frame(maxWidth: 400)
        .padding()
    }
}

struct CircleButton: ButtonStyle {
    
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            //            .multilineTextAlignment(.center)
            .foregroundColor(Color .white)
            .frame(width: 60, height: 60)
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
            //            .minimumScaleFactor(0.4)
            //            .lineLimit(1)
            .padding(.horizontal,4)
            .padding(.vertical,4)
    }
}

struct PointsCapture_Previews: PreviewProvider {
    static var previews: some View {
        PointsCapture(isPresented: .constant(true), playerScoreID: Player.ID())
            .environmentObject(Game())
            .previewDevice("iPhone 7")
            //            .previewLayout(.fixed(width: 400, height: 500))
            .background(Color .gray)
    }
}


