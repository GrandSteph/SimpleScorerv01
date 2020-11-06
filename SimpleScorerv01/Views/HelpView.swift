//
//  HelpView.swift
//  SimpleScorerv01
//
//  Created by Dev on 11/6/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI

struct HelpView: View {
    
    @Binding var showHelp : Bool
    @Binding var DismissHelpForever : Bool
    
    @State private var showTap = true
    @State private var showHold = false
    @State private var showtotal = false
    
    // Hold
    @State private var opacity = Double(0)
    @State private var move = CGSize(width: 0, height: 0)
    @State private var rotation = Angle(degrees: 0)
    @State private var zoomHand = CGFloat(1)
    @State private var zoomCircle = CGFloat(0.85)
    
    // Tap
    @State private var opacityTap = Double(0)
    @State private var zoomHandTap = CGFloat(1)

    
    let imagesHold = [Image("handUp"),Image("holdOnly")]
    let imagesTap = [Image("handUp"),Image("handTap")]
    
    func doAnimHold () {
        
        withAnimation(Animation.linear(duration: 0.8).delay(0.2).repeatForever()) {
            self.opacity = 1
            self.zoomCircle = 1.20
        }
        
        withAnimation(Animation.linear(duration: 0.1).delay(0.2)) {
            self.zoomHand = 0.95
        }
        
        withAnimation(Animation.linear(duration: 0.2)) {
            self.move = CGSize(width: -10, height: -15)
            self.rotation = Angle(degrees: -20)
        }
    }
    


    
    var handHold: some View {
        
        ZStack {
            imagesHold[0].opacity(1).scaleEffect(zoomHand)
            imagesHold[1].opacity(opacity).scaleEffect(zoomCircle)
        }
        .offset(move)
        .rotationEffect(rotation)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.doAnimHold()
            }
        })
    }
    
    var handTap :some View {
        
        ZStack {
            imagesTap[0].opacity(1).scaleEffect(zoomHandTap)
            imagesTap[1].opacity(opacityTap)
        }
        .offset(move)
        .rotationEffect(rotation)
        .onAppear(perform: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                self.doAnimTap()
            }
        })
    }
    
    func doAnimTap () {
        
        withAnimation(Animation.linear(duration: 0.1).delay(0.2).repeatForever()) {
            self.opacityTap = 1
        }
        
        withAnimation(Animation.linear(duration: 0.1).delay(0.2)) {
            self.zoomHandTap = 0.95
        }
        
        withAnimation(Animation.linear(duration: 0.2)) {
            self.move = CGSize(width: -10, height: -15)
            self.rotation = Angle(degrees: -20)
        }
    }
    
    var body: some View {
        
        ZStack {
//            Color.offWhite.edgesIgnoringSafeArea(.all)
//            HStack {
//                Image("scoreColumn")
//                Spacer()
//            }
//            .padding(.leading,60)
            
            Color.black.edgesIgnoringSafeArea(.all).opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
            
            VStack {
                if showTap {
                    Text("Tap a number to EDIT")
                        .foregroundColor(.white)
                        .font(Font.system(size: 30, weight: .light, design: .rounded))
                    HStack {
                        handTap
                        
                    }
                }
                
                if showHold {
                    Text("Tap & Hold to DELETE")
                        .foregroundColor(.white)
                        .font(Font.system(size: 30, weight: .light, design: .rounded))
                    HStack {
                        handHold
                        
                    }
                }
//
//                if showtotal {
//                    Text("Tap Total to ADD score")
//                        .foregroundColor(.white)
//                        .font(Font.system(size: 30, weight: .light, design: .rounded))
//                    HStack {
//                        handTap
//                    }
//                }
            }
            .padding(.top, 50)
            if showHold {
                VStack {
                    Spacer()
                    Text("Dismiss Forever")
                        .foregroundColor(.white)
                        .font(Font.system(size: 15, weight: .light, design: .rounded))
                        .padding(.horizontal,15)
                        .padding(.vertical,5)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white, lineWidth: 1)
                        ).onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                            self.DismissHelpForever = true
                            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.didShowHelpAllScores)
                        })
                }
            }
            
        }
        .onTapGesture {
            if showTap {
                self.showHold = true
                self.showTap = false
            } else if self.showHold {
                self.showHold = false
                self.showHelp = false
            }
            
        }
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        HelpView(showHelp: .constant(true), DismissHelpForever: .constant(false))
    }
}
