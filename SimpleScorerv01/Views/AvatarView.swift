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
    var name : String?
    var image : Image?
    
    
    @ViewBuilder
    var body: some View {
        
        ZStack {
            if name != nil {
                Text(name!.uppercased().prefix(1))
                    .fontWeight(.regular)
                    .font(.system(.largeTitle, design: .rounded))
                    .foregroundColor(Color.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
                    .contentShape(Circle())
                    .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
            } else {
                Image(systemName: "camera")
                    .font(.system(size: 30, weight: .light, design: .default))
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Circle())
                    .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
            }
            
            if imageURL != nil {
                if UIImage(named: imageURL!) != nil {
                    Image(imageURL!).renderingMode(.original)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .overlay(Circle().strokeBorder(Color.offWhite, lineWidth: 1))
                }
            }
            
            if image != nil {
                image!.renderingMode(.original)
                .resizable()
                .scaledToFit()
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(Color.offWhite, lineWidth: 1))
            }
        } 
    }
}



struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            AvatarView(imageURL: "steph", name: "steph")
                .background(Color.orangeEnd)
                .previewLayout(.fixed(width: 200, height: 300))
            
            AvatarView()
            .background(Color.orangeEnd)
            .previewLayout(.fixed(width: 200, height: 300))
        }
        
        
    }
}
