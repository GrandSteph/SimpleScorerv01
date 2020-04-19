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
    
    @EnvironmentObject var game : Game
    
    @Binding var isPresented: Bool
    var playerScore: PlayerScore
    @Binding var pointScored: CGFloat
    var wheelColor: Color
    
    var scoreIndex: Int {
        game.playerScores.firstIndex(where: { $0.id == playerScore.id})!
    }
    
    var body: some View {
        
        GeometryReader { geo in
            
            ZStack {
                Group {
                    Circle()
                        .fill(Color .white)
                    Circle()
                        .stroke(self.wheelColor, lineWidth: self.isPresented ? 2 : 2)
                    
                    Circle().scale(1/10).foregroundColor(self.wheelColor)
                    
                    Circle().scale(1/5).foregroundColor(self.wheelColor).offset(x: 0, y: max(-geo.size.width, -geo.size.height)/3)
                }
                .rotationEffect(Angle(degrees: Double(self.wheelRotation)))
                .scaleEffect(self.isPresented ? 0.5 : 0.5)
            }
            .frame(maxWidth: .infinity).background(Color .white)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .global)
                    .onEnded({ (value) in
                        self.isPresented = false
                        self.game.addScore(pointsValue: Int(String(format: "%.0f",self.pointScored))!, playerScoreID: self.playerScore.id)
                        self.pointScored = 0
                    })
                    .onChanged { value in
                        self.isPresented = true
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
                                self.pointScored += speed / 15
                                print("1")
                            case 8..<15:
                                self.pointScored += speed / 10
                                print("2")
                            default:
                                self.pointScored += speed / 5
                                print("3")
                            }
                        }
                        self.lastDragLocation = value
                }
            )
        }
    }
}


struct ClickWheel_Previews: PreviewProvider {
    static var previews: some View {
        ClickWheel(
            isPresented: .constant(true)
            ,playerScore: PlayerScore(player: Player(),pointsList: [1,2])
            ,pointScored: .constant(CGFloat(0)), wheelColor: Color .black
        ).environmentObject(Game())
    }
}
