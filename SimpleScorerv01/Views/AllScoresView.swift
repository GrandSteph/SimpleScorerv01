//
//  AllScoresView.swift
//  SimpleScorerv01
//
//  Created by Dev on 6/19/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct AllScoresView: View {
    
    @EnvironmentObject var displayInfo : GlobalDisplayInfo
    
    var body: some View {
        Image(systemName: "chevron.right.square.fill")
            .font(.system(.largeTitle, design: .rounded))
            .foregroundColor(Color.gray)
            .background(Color.clear.opacity(0))
            .onTapGesture {
                self.displayInfo.screenDisplayed.current = .scoreCards
                self.displayInfo.screenDisplayed.previous = .allScores
        }.padding()
    }
}

struct AllScoresView_Previews: PreviewProvider {
    static var previews: some View {
        AllScoresView().environmentObject(GlobalDisplayInfo())
    }
}
