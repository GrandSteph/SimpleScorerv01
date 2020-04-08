//
//  CircleNumber.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/24/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct CircleNumber: View {
    
    let number: String
    
    var body: some View {
        Text("\(number)")
            .multilineTextAlignment(.center)
            .foregroundColor(Color .white)
            .padding(4)
            .frame(width: 40, height: 40)
            .overlay(Circle().stroke(Color.white, lineWidth: 1))
            .minimumScaleFactor(0.4)
            .lineLimit(1)
            .padding(.horizontal, 4.0)
            .padding(.vertical, 2.0)
    }
}

struct CircleNumber_Previews: PreviewProvider {
    static var previews: some View {
        CircleNumber(number: "4").background(Color .green) .previewLayout(.fixed(width: 100, height: 100))
    }
}
