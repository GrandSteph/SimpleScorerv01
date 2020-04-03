//
//  ClickWheel.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/2/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI



//@available(iOS 13.4, *)
struct ClickWheel: View {
    
    @State private var dragLocation = CGPoint(x: 0, y: 0)
    @State private var lastDragLocation: DragGesture.Value?
    @State private var rotatesClockwise = false
    @State private var points = Float(10.526)
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                Spacer()
                CircleNumber(number: String(format: "%.0f",self.points))
                ZStack {

                    Circle()
                        .trim(from: 0, to: 0.4)
                        .stroke(Color(.systemBlue), lineWidth: 80)
                    
                    Circle()
                        .trim(from: 0.4, to: 0.6)
                        .stroke(Color(.systemTeal), lineWidth: 80)
                    
                    Circle()
                        .trim(from: 0.6, to: 0.75)
                        .stroke(Color(.systemPurple), lineWidth: 80)
                    
                    Circle()
                        .trim(from: 0.75, to: 1)
                        .stroke(Color(.systemYellow), lineWidth: 80)
                    
                    self.rotatesClockwise ? Image(systemName: "arrow.clockwise.circle").font(.system(size: 80)) : Image(systemName: "arrow.counterclockwise.circle.fill").font(.system(size: 80))
                }
                .background(Color .red)
//                .frame(width: 300, height: 300)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .global)
                        .onChanged { value in
                            
                            var VerticalDragSpeed = CGFloat(0)
                            var HorizontalDragSpeed = CGFloat(0)
                            var speed = Float(0)
                            
                            //                        var dragSpeed = CGFloat(0)
                            
                            if self.lastDragLocation != nil {
                                let timeDifference = value.time.timeIntervalSince(self.lastDragLocation!.time)
                                VerticalDragSpeed = CGFloat(value.translation.height - self.lastDragLocation!.translation.height) / CGFloat(timeDifference)
                                HorizontalDragSpeed = CGFloat(value.translation.width - self.lastDragLocation!.translation.width) / CGFloat(timeDifference)
                                //                            dragSpeed = (VerticalDragSpeed + HorizontalDragSpeed)/2
                            }
                            self.lastDragLocation = value
                            
                            self.dragLocation = value.location
                            let x = self.dragLocation.x - geo.frame(in: .global).midX
                            let y = self.dragLocation.y - geo.frame(in: .global).midY
                            
                            speed = abs(Float(HorizontalDragSpeed + VerticalDragSpeed))/1000

                            
//                            print("(x = \(String(format: "%.01f", x)),y = \(String(format: "%.01f", y))) - Speed(h = \(String(format: "%.01f", HorizontalDragSpeed)),v = \(String(format: "%.01f", VerticalDragSpeed))")
                            print("Points = \(String(format: "%.01f",self.points)) Speed = \(String(format: "%.01f", HorizontalDragSpeed + VerticalDragSpeed))")
                            self.points += self.rotatesClockwise ? speed : -speed
                            
                            if (x < 0 && y < 0) { /*upper left corner*/
                                print("Upper left corner")
                                if (VerticalDragSpeed < 0 && HorizontalDragSpeed > 0) {
                                    self.rotatesClockwise = true
                                } else {
                                    if (VerticalDragSpeed > 0 && HorizontalDragSpeed < 0) {
                                        self.rotatesClockwise = false
                                    }
                                }
                            } else {
                                if (x > 0 && y < 0) {
                                    print("Upper right corner")
                                    if (VerticalDragSpeed > 0 && HorizontalDragSpeed > 0) {
                                        self.rotatesClockwise = true
                                    } else {
                                        if (VerticalDragSpeed < 0 && HorizontalDragSpeed < 0) {
                                            self.rotatesClockwise = false
                                        }
                                    }
                                } else {
                                    if (x > 0 && y > 0) {
                                        print("Lower right corner")
                                        if (VerticalDragSpeed > 0 && HorizontalDragSpeed < 0) {
                                            self.rotatesClockwise = true
                                        } else {
                                            if (VerticalDragSpeed < 0 && HorizontalDragSpeed > 0) {
                                                self.rotatesClockwise = false
                                            }
                                        }
                                    } else {
                                        if (x < 0 && y > 0) {
                                            print("Lower left corner")
                                            if (VerticalDragSpeed < 0 && HorizontalDragSpeed < 0) {
                                                self.rotatesClockwise = true
                                            } else {
                                                if (VerticalDragSpeed > 0 && HorizontalDragSpeed > 0) {
                                                    self.rotatesClockwise = false
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                                
                            }
                    }
                )
            }
            .background(Color .green)
//            .padding()
        }
    }
}



//@available(iOS 13.4, *)
struct ClickWheel_Previews: PreviewProvider {
    static var previews: some View {
        ClickWheel()
    }
}
