//
//  CircleImage.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    var name: String
    
    var body: some View {
        //        Image(uiImage: UIImage(named: self.name) ?? UIImage(systemName: "person")!)
        //            .resizable()
        //            .scaledToFit()
        //            .clipShape(Circle())
        //            .overlay(Circle().stroke(Color.white, lineWidth: 4))
        
        Button(action: {
            
        }) {
            Image(systemName: "heart.fill")
                .foregroundColor(.white)
        }
        .buttonStyle(LightButtonStyle())
        .padding()
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(name : "steph")
            .background(Color.offWhite)
//            .previewLayout(.fixed(width: 120, height: 120))
        
    }
}
