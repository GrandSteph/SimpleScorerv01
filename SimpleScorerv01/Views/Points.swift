//
//  Points.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/23/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct Points: View {
    
    var points: [Int]
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer()
            ForEach(points.indices.reversed(), id: \.self) { i in
                Group{
                    CircleNumber(number: "\(self.points[i])" )
//                    i == self.points.first ? nil : VerticalSeparator()
                    VerticalSeparator()
                }
            }
            
        }
    }
}



struct VerticalSeparator: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 2, y: 0))
            path.addLine(to: CGPoint(x: 2, y: 0))
            path.addLine(to: CGPoint(x: 2, y: 20))
        }
        .stroke()
        .fill(Color.white)
        .frame(width: 4, height: 20, alignment: .center)
    }
}



struct Points_Previews: PreviewProvider {
    static var previews: some View {
        Points(points: [1,2,3,4])
            .environmentObject(Game())
            .background(Color .orange)
            .previewLayout(.fixed(width: 70, height: 300))
            
    }
}
