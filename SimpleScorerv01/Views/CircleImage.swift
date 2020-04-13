//
//  CircleImage.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct CircleImage: View {
    
    var image: Image
    
    var body: some View {
        Image(image: Image(uiImage: UIImage(named: self.playerScore.player.photoURL) ?? UIImage(systemName: "person")!))
            .resizable()
            .scaledToFit()
            .clipShape(Circle())
            .overlay(Circle().stroke(Color.white, lineWidth: 4))
//            .padding(2)
        //            .shadow(radius: 5)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage(image : Image("steph"))
            .previewLayout(.fixed(width: 50, height: 40))
            .background(Color(.gray))
    }
}
