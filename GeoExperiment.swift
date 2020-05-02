//
//  GeoExperiment.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/30/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct GeoExperiment: View {
    var body: some View {
        ZStack {
            OuterView()
                .background(Color.red)
                .coordinateSpace(name: "Red Custom")
            
            Path() { path in
                path.move(to: CGPoint(x: 60, y: 246))
                path.addLine(to: CGPoint(x: 60, y: 33))
                path.addLine(to: CGPoint(x: 80, y: 33))
                path.addLine(to: CGPoint(x: 80, y: 246))
            }
            .fill(Color.yellow)
            
            Path() { path in
                path.move(to: CGPoint(x: 290, y: 246))
                path.addLine(to: CGPoint(x: 290, y: 226))
                path.addLine(to: CGPoint(x: 310, y: 226))
                path.addLine(to: CGPoint(x: 310, y: 246))
            }
            .fill(Color.blue)
            
        }
        .background(Color.gray)
        .coordinateSpace(name: "Gray Custom")
    }
}

struct GeoExperiment_Previews: PreviewProvider {
    static var previews: some View {
        GeoExperiment()
    }
}

struct OuterView: View {
    var body: some View {
        VStack {
            Text("Top")
            InnerView()
                .background(Color.green)
            Text("Bottom")
        }
    }
}

struct InnerView: View {
    var body: some View {
        HStack {
            Text("Left")
            GeometryReader { geo in
                Text("Center")
                    .background(Color.blue)
                    .onTapGesture {
                        print("Global top   : \(geo.frame(in: .global).origin.y)")
                        print("Global height: \(geo.frame(in: .global).size.height )\n")
                        
                        print("CusRed top   : \(geo.frame(in: .named("Red Custom")).origin.y)")
                        print("CusRed height: \(geo.frame(in: .named("Red Custom")).size.height)\n")
                        
                        print("CusGra top   : \(geo.frame(in: .named("Gray Custom")).origin.y)")
                        print("CusRed height: \(geo.frame(in: .named("Gray Custom")).size.height)\n")
//                        print("Local top: \(geo.frame(in: .local).origin.y)")
                        
                        
                }
            }
            .frame(height:100)
            .background(Color.orange)
            Text("Right")
        }.frame(height:200)
    }
}


