//
//  PlayView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/8/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct PlayView: View {
    
    @State private var globalCenter = CGPoint(x: 60, y: 20)
    @State private var customCenter = CGPoint(x: 40, y: 20)
    @State private var localCenter = CGPoint(x: 20, y: 20)
    
    var body: some View {
        ZStack {
            
            VStack {
                Text("Top").padding(80)
                HStack {
                    Text("Left").padding(80)
                    
                    GeometryReader { geo in
                        Text("               ")
                            .background(Color.blue)
                        .onTapGesture {
                                self.customCenter = CGPoint(x: geo.frame(in: .named("Custom")).midX, y: geo.frame(in: .named("Custom")).midY)
                                self.globalCenter = CGPoint(x: geo.frame(in: .global).midX, y: geo.frame(in: .global).midY)
                                self.localCenter = CGPoint(x: geo.frame(in: .local).midX, y: geo.frame(in: .local).midY)
                                
                                print("Global center: \(geo.frame(in: .global).midX) x \(geo.frame(in: .global).midY)")
                                print("Custom center: \(geo.frame(in: .named("Custom")).midX) x \(geo.frame(in: .named("Custom")).midY)")
                                print("Local center: \(geo.frame(in: .local).midX) x \(geo.frame(in: .local).midY)")
                        }
                            
                    }
                    .background(Color.orange)
                    
                    Text("Right")
                    
                }
                .background(Color.green)
                
                Text("Bottom")
            }
            .background(Color.red)
            .coordinateSpace(name: "Custom")
            
            Text("C").frame(width: 20, height: 20).position(self.customCenter).foregroundColor(Color.white)
            Text("G").frame(width: 20, height: 20).position(self.globalCenter).foregroundColor(Color.white)
            Text("L").frame(width: 20, height: 20).position(self.localCenter).foregroundColor(Color.white)
        }
    }
}

struct PlayView_Previews: PreviewProvider {
    static var previews: some View {
        PlayView()
    }
}




