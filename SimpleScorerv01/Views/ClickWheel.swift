//
//  ClickWheel.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/2/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ClickWheel: View {
    
    @State private var dragLocation: DragGesture.Value?
    @State private var lastDragLocation: DragGesture.Value?
    @State private var wheelRotation = CGFloat(0)
    
    
    @Binding var editing: Bool
//    @Binding var playerScore: PlayerScore
    @Binding var pointsScored: CGFloat
    var wheelColor: Color
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                Group {
                    Circle()
                        .fill(Color .white)
                    Circle()
                        .stroke(self.wheelColor, lineWidth: self.editing ? 2 : 2)
                    
                    Circle().scale(1/10).foregroundColor(self.wheelColor)
                    
                    Circle().scale(1/5).foregroundColor(self.wheelColor).offset(x: 0, y: max(-geo.size.width, -geo.size.height)/3)
                }
                .rotationEffect(Angle(degrees: Double(self.wheelRotation)))
                .scaleEffect(self.editing ? 0.5 : 0.5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.offWhite, width: 1)
            .background(Color .white)
            .gesture(
//                DragGesture().sequenced(before:
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onEnded({ (value) in
//                            self.editing = false
//                            self.playerScore.addPoints(scoreValue: Int(String(format: "%.0f",self.pointsScored))!)
//                            self.pointsScored = 0
                        })
                            .onChanged { value in
                                withAnimation {
                                    self.editing = true
                                }
                                let center = CGPoint(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
                                
                                
                                if self.lastDragLocation != nil {
                                    
                                    self.dragLocation = value
                                    
                                    let timeDifference = value.time.timeIntervalSince(self.lastDragLocation!.time)
                                    
                                    let radiansToDegrees = 180 / CGFloat.pi
                                    
                                    let previousAngle = atan2(self.lastDragLocation!.location.y - center.y, self.lastDragLocation!.location.x - center.x)
                                    let angle = atan2(self.dragLocation!.location.y - center.y, self.dragLocation!.location.x - center.x)
                                    
                                    self.wheelRotation = (angle * radiansToDegrees) + 90
                                    
                                    // did angle flip from +π to -π, or -π to +π?
                                    var speed = CGFloat(angle - previousAngle) / CGFloat(timeDifference)
                                    if angle - previousAngle > CGFloat.pi {
                                        speed = CGFloat(angle - previousAngle - (2 * CGFloat.pi)) / CGFloat(timeDifference)
                                        
                                    } else if previousAngle - angle > CGFloat.pi {
                                        speed = CGFloat(angle - previousAngle + (2 * CGFloat.pi)) / CGFloat(timeDifference)
                                        
                                    }
                                    
                                    self.lastDragLocation = value
                                    
                                    switch abs(speed) {
                                    case 0..<8:
                                        self.pointsScored += speed / 15
                                    case 8..<15:
                                        self.pointsScored += speed / 10
                                    default:
                                        self.pointsScored += speed / 5
                                    }
                                }
                                self.lastDragLocation = value
                        }
//                )
            )
        
            
            //            .onTapGesture {
            //                print(self.game.playerScores[0].pointsList)
            //                self.game.playerScores[self.game.playerScores.firstIndex(where: {$0 == self.playerScore})!].addPoints(scoreValue: Int(self.pointsScored))
            //                self.pointsScored = 0
            //                }
            
            //            .gesture(
            //                LongPressGesture(minimumDuration: 0.1, maximumDistance: 0)
            //                    .sequenced(before:
            //                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
            //                            .onEnded({ (value) in
            //                                self.isPresented = false
            //                                self.game.addScore(pointsValue: Int(String(format: "%.0f",self.pointsScored))!, playerScoreID: self.playerScore.id)
            //                                self.pointsScored = 0
            //                            })
            //                            .onChanged { value in
            //                                self.isPresented = true
            //                                let center = CGPoint(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
            //
            //
            //                                if self.lastDragLocation != nil {
            //
            //                                    self.dragLocation = value
            //
            //                                    let timeDifference = value.time.timeIntervalSince(self.lastDragLocation!.time)
            //
            //                                    let radiansToDegrees = 180 / CGFloat.pi
            //
            //                                    let previousAngle = atan2(self.lastDragLocation!.location.y - center.y, self.lastDragLocation!.location.x - center.x)
            //                                    let angle = atan2(self.dragLocation!.location.y - center.y, self.dragLocation!.location.x - center.x)
            //
            //                                    self.wheelRotation = (angle * radiansToDegrees) + 90
            //
            //                                    // did angle flip from +π to -π, or -π to +π?
            //                                    var speed = CGFloat(angle - previousAngle) / CGFloat(timeDifference)
            //                                    if angle - previousAngle > CGFloat.pi {
            //                                        speed = CGFloat(angle - previousAngle - (2 * CGFloat.pi)) / CGFloat(timeDifference)
            //
            //                                    } else if previousAngle - angle > CGFloat.pi {
            //                                        speed = CGFloat(angle - previousAngle + (2 * CGFloat.pi)) / CGFloat(timeDifference)
            //
            //                                    }
            //
            //                                    self.lastDragLocation = value
            //
            //                                    switch abs(speed) {
            //                                    case 0..<8:
            //                                        self.pointsScored += speed / 15
            //                                    case 8..<15:
            //                                        self.pointsScored += speed / 10
            //                                    default:
            //                                        self.pointsScored += speed / 5
            //                                    }
            //                                }
            //                                self.lastDragLocation = value
            //                        }
            //                    )
            //            )
        }
    }
}


struct ClickWheel_Previews: PreviewProvider {
    static var previews: some View {
        return ClickWheel(
            editing: .constant(true)
//            ,playerScore: .constant(game.playerScores[0])
            ,pointsScored: .constant(CGFloat(0))
            ,wheelColor: Color .black
        )
    }
}
