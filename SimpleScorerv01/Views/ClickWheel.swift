//
//  ClickWheel.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/2/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct ClickWheel: View {
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    @State private var dragLocation: DragGesture.Value?
    @State private var lastDragLocation: DragGesture.Value?
    @State private var wheelRotation = CGFloat(0)
    
    @State private var backgroundColor = Color.white
    
    @State private var nbrLaps = CGFloat(0)
    
    
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
                        .stroke(self.wheelColor, lineWidth: 2)
                    
                    Circle().scale(1/10).foregroundColor(self.wheelColor)
                    
                    Circle().scale(1/5).foregroundColor(self.wheelColor).offset(x: 0, y: max(-geo.size.width, -geo.size.height)/3)
                }
                .rotationEffect(Angle(degrees: Double(self.wheelRotation)))
                .scaleEffect(0.5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .border(Color.offWhite, width: 1)
            .background(self.backgroundColor)
            .gesture(
//                DragGesture().sequenced(before:
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onEnded({ (value) in
//                            self.nbrLaps = 0
                        })
                            .onChanged { value in

                                self.editing = true

                                let center = CGPoint(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
                                
                                if self.lastDragLocation != nil {
                                    
                                    self.dragLocation = value
                                    
                                    let timeDifference = value.time.timeIntervalSince(self.lastDragLocation!.time)
                                    
                                    let radiansToDegrees = 180 / CGFloat.pi
                                    
                                    let previousAngle = atan2(self.lastDragLocation!.location.y - center.y, self.lastDragLocation!.location.x - center.x)
                                    let angle = atan2(self.dragLocation!.location.y - center.y, self.dragLocation!.location.x - center.x)
                                    
                                    
                                    
                                    // did angle flip from +π to -π, or -π to +π?

                                    if angle - previousAngle > CGFloat.pi {
                                        let speed = CGFloat(angle - previousAngle - (2 * CGFloat.pi)) / CGFloat(timeDifference)
                                        self.nbrLaps -= 1
                                        self.setPoints(speed: speed)
                                    } else if previousAngle - angle > CGFloat.pi {
                                        let speed = CGFloat(angle - previousAngle + (2 * CGFloat.pi)) / CGFloat(timeDifference)
                                        self.setPoints(speed: speed)
                                        self.nbrLaps += 1
                                    } else {
                                        let speed = CGFloat(angle - previousAngle) / CGFloat(timeDifference)
                                        self.setPoints(speed: speed)
                                    }
                                    
                                    self.wheelRotation = ((angle * radiansToDegrees)+90 ) + self.nbrLaps*360
                                    
//                                    print("\(String(format: "%.0f",self.wheelRotation)) - \(String(format: "%.0f",speed))")

                                    self.lastDragLocation = value
                                    
                                }
                                
                                self.lastDragLocation = value
                        }
//                )
            )
        }
    }
    
    func setPoints(speed : CGFloat) {
//        print(" --> \(String(format: "%.0f",speed))")
//            if abs(speed) > 15 {
//                self.backgroundColor = Color.red
//            } else {
//                self.backgroundColor = Color.white
//            }
        
            switch abs(speed) {
            case 0..<15:
                self.pointsScored += speed / 20
            case 15..<20:
                self.pointsScored += speed / 10
            default:
                self.pointsScored += speed / 5
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
