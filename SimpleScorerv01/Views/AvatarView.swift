//
//  CircleImage.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 3/16/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct AvatarView: View {
    
    var imageURL : String?
    let name : String
    
    
    @ViewBuilder
    var body: some View {
        
        ZStack {
            Text(name.uppercased().prefix(1))
                .fontWeight(.regular)
                .font(.system(.largeTitle, design: .rounded))
                .foregroundColor(Color.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .contentShape(Circle())
                .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
            
            if imageURL != nil {
                if UIImage(named: imageURL!) != nil {
                    Image(imageURL!).renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(Color.offWhite, lineWidth: 1))
                }
            }
        } 
    }
}



struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        AvatarView(imageURL: "steph", name: "steph")
            .background(Color.orangeEnd)
            .previewLayout(.fixed(width: 200, height: 300))
        
    }
}
