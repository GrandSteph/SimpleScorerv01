//
//  ClickWheel.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/2/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ClickWheel: View {
    
    @State private var dragLocation = CGPoint(x: 0, y: 0)
    @State private var lastDragLocation: DragGesture.Value?
    @State private var rotatesClockwise = true
    @State private var points = Float(0.0)
    
    @Binding var isPresented: Bool
    @EnvironmentObject var game : Game
    var playerScoreID: PlayerScore.ID
    
    var body: some View {
        GeometryReader { geo in
            
            ZStack (alignment: .bottom) {
                VStack {
                    
                    HStack {
                        Text(String(format: "%.0f",self.game.playerScores[self.game.playerScores.firstIndex(where: {$0.id == self.playerScoreID})!].totalScore()))
                        .font(.system(size: 35))
                        .foregroundColor(Color .white)
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                                                
                        CircleImage(image: Image(self.game.playerScores[self.game.playerScores.firstIndex(where: {$0.id == self.playerScoreID})!].player.photoURL)).frame(maxHeight: 108)
                        
                        Text(String(format: "%.0f",self.points))
                        .font(.system(size: 35))
                        .foregroundColor(Color .white)
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    }
                    .padding()
                    
                    ZStack {
                        Circle()
                            .fill(Color .white)
//                            .padding()
//                            .padding(.vertical, 10)
                        
                        self.rotatesClockwise ? Image(systemName: "arrow.clockwise.circle").font(.system(size: 80)) : Image(systemName: "arrow.counterclockwise.circle.fill").font(.system(size: 80))
                        
                    }
//                    .background(Color .red)
                }
            }
//            .background(Color .green)
            .background(self.game.playerScores[self.game.playerScores.firstIndex(where: {$0.id == self.playerScoreID})!].player.favoriteColor)
            .frame(maxWidth: .infinity)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onEnded({ (value) in
                        self.isPresented = false
                        let index = self.game.playerScores.firstIndex(where: {$0.id == self.playerScoreID})
                        self.game.playerScores[index!].addPoints(scoreValue: Int(String(format: "%.0f",self.points))!)
                        print("  -->\( Int(String(format: "%.0f",self.points))!)")
                        
                        
                    })
                    .onChanged { value in
                        
                        
                        
                        var VerticalDragSpeed = CGFloat(0)
                        var HorizontalDragSpeed = CGFloat(0)
                        var speed = Float(0)
                        
                        //                        var dragSpeed = CGFloat(0)
                        
                        if self.lastDragLocation != nil {
                            let timeDifference = value.time.timeIntervalSince(self.lastDragLocation!.time)
                            VerticalDragSpeed = CGFloat(value.translation.height - self.lastDragLocation!.translation.height) / CGFloat(timeDifference)
                            HorizontalDragSpeed = CGFloat(value.translation.width - self.lastDragLocation!.translation.width) / CGFloat(timeDifference)

                        }
                        self.lastDragLocation = value
                        
                        self.dragLocation = value.location
                        let x = self.dragLocation.x - geo.frame(in: .global).midX
                        let y = self.dragLocation.y - geo.frame(in: .global).midY
                        let deltaAngle = atan2(y, x)
                        
                        print("x= \(String(format: "%.001f",x)) y= \(String(format: "%.001f",y)) delta= \(String(format: "%.001f",deltaAngle))")
                        
                        speed = abs(Float(HorizontalDragSpeed + VerticalDragSpeed))/1000
                        
                        self.points += self.rotatesClockwise ? speed : -speed
                        
                        if (x < 0 && y < 0) { // Upper left corner
                            if (VerticalDragSpeed <= 0 && HorizontalDragSpeed >= 0) {
                                self.rotatesClockwise = true
                            } else {
                                if (VerticalDragSpeed >= 0 && HorizontalDragSpeed <= 0) {
                                    self.rotatesClockwise = false
                                }
                            }
                        } else {
                            if (x > 0 && y < 0) { // Upper right corner
                                if (VerticalDragSpeed >= 0 && HorizontalDragSpeed >= 0) {
                                    self.rotatesClockwise = true
                                } else {
                                    if (VerticalDragSpeed <= 0 && HorizontalDragSpeed <= 0) {
                                        self.rotatesClockwise = false
                                    }
                                }
                            } else {
                                if (x > 0 && y > 0) { // Lower right corner
                                    if (VerticalDragSpeed >= 0 && HorizontalDragSpeed <= 0) {
                                        self.rotatesClockwise = true
                                    } else {
                                        if (VerticalDragSpeed <= 0 && HorizontalDragSpeed >= 0) {
                                            self.rotatesClockwise = false
                                        }
                                    }
                                } else {
                                    if (x < 0 && y > 0) { // Lower left corner
                                        if (VerticalDragSpeed <= 0 && HorizontalDragSpeed <= 0) {
                                            self.rotatesClockwise = true
                                        } else {
                                            if (VerticalDragSpeed >= 0 && HorizontalDragSpeed >= 0) {
                                                self.rotatesClockwise = false
                                            }
                                        }
                                    }
                                }
                                
                            }
                            
                        }
                }
            )
            .cornerRadius(40)
                .padding(.vertical)
        }
    }
}



//@available(iOS 13.4, *)
struct ClickWheel_Previews: PreviewProvider {
    static var previews: some View {
        ClickWheel(isPresented: .constant(true), playerScoreID: Player.ID()).environmentObject(Game())
    }
}
