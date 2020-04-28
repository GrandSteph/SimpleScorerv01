//
//  AddPlayerView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/27/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct AddPlayerView: View {
    var body: some View {
        ZStack {
            LinearGradient(Color.purpleStart, Color.purpleEnd)
            
            VStack (alignment: .leading, spacing: 0){
                
                HStack (alignment: .center, spacing: 0) {
                    
                    Image(uiImage: UIImage(systemName: "person")!)
                        .resizable()
                        .scaledToFit()
                        .clipShape(Circle())
                        .padding(10.0)
                    
                    VStack (alignment: .leading, spacing: 0) {
                        Text("Player name")
                            .fontWeight(.semibold)
                            .font(.system(.largeTitle, design: .rounded))
                            .foregroundColor(Color .offWhite)
                        
                        //                        Text(String(self.game.ranking(for: self.playerScore)))
                        //                            .fontWeight(.semibold)
                        //                            .font(.system(.body, design: .rounded))
                        //                            .foregroundColor(Color .offWhite)
                        
                    }
                    
                    Spacer()
                    
                    Group {
                        Text("0")
                            .font(Font.system(size: 50, weight: .bold, design: .rounded))
                            .foregroundColor(Color .offWhite)
                            .offset(x: -25, y: 0)
                        
                       
                    }.layoutPriority(1)
                    
                    
                }.frame(maxHeight: 100)
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 135)
        .clipShape(Rectangle()).cornerRadius(14)
        .opacity(1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct AddPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlayerView()
    }
}
