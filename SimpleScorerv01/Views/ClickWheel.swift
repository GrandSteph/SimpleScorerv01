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
    
    @State private var points = CGFloat(0.0)
    @State private var wheelRotation = CGFloat(0)
    
    @EnvironmentObject var game : Game
    
    @Binding var isPresented: Bool
    var playerScore: PlayerScore
    
    var scoreIndex: Int {
        game.playerScores.firstIndex(where: { $0.id == playerScore.id})!
    }
    
    var body: some View {
        
        
        ZStack (alignment: .bottom) {
            
            
            VStack {
                
                HStack {
                    Text("\(self.game.findScore(playerScoreId: self.playerScore.id).totalScore())")
                        .font(.system(size: 35))
                        .foregroundColor(Color .white)
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                    
                    CircleImage(name: self.playerScore.player.photoURL).frame(maxHeight: 108)
                    
                    Text(String(format: "%.0f",self.points))
                        .font(.system(size: 35))
                        .foregroundColor(Color .white)
                        .frame(width: 100, height: 100)
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .minimumScaleFactor(0.4)
                        .lineLimit(1)
                }
                .padding()
                GeometryReader { geo in
                    
                    ZStack {
                        
                        
                        
                        Group {
                            Circle()
                                .fill(Color .white)
                            Circle().scale(1/5).offset(x: 0, y: -120)
                            Circle().scale(1/10).foregroundColor(Color .red)
                            
                        }
                        .rotationEffect(Angle(degrees: Double(self.wheelRotation)))
                    .padding()
                        
                        
                    }
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onEnded({ (value) in
                                self.isPresented = false
                                self.game.addScore(pointsValue: Int(String(format: "%.0f",self.points))!, playerScoreID: self.playerScore.id)
                            })
                            .onChanged { value in
                                
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
                                        self.points += speed / 15
                                        print("1")
                                    case 8..<15:
                                        self.points += speed / 10
                                        print("2")
                                    default:
                                        self.points += speed / 5
                                        print("3")
                                    }
                                }
                                self.lastDragLocation = value
                                
                        }
                    )
                }
            }
            
            
        }
        .background(self.playerScore.player.color)
        .frame(maxWidth: .infinity)
            
        .cornerRadius(40)
        .padding(.vertical)
        
    }
}


struct ClickWheel_Previews: PreviewProvider {
    static var previews: some View {
        ClickWheel(
            isPresented: .constant(true)
            ,playerScore: PlayerScore(player: Player(),pointsList: [1,2])
        ).environmentObject(Game())
    }
}
