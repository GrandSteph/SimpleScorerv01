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
        Image(uiImage: UIImage(named: self.name) ?? UIImage(systemName: "person")!)
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
        
        //        Image(name)
        //            .resizable()
        //            .scaledToFit()
        //            .clipShape(Circle())
        //            .overlay(Circle().stroke(Color.white, lineWidth: 4))
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(name : "steph")
            .previewLayout(.fixed(width: 50, height: 40))
            .background(Color(.gray))
    }
}
