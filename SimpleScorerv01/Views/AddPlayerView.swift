//
//  AddPlayerView.swift
//  SimpleScorerv01
//
//  Created by Stephane Giloppe on 4/27/20.
//  Copyright © 2020 Stephane Giloppe. All rights reserved.
//

import SwiftUI
import Combine


struct AddPlayerView: View {
    
    @Binding var game : Game
    @ObservedObject var kGuardian : KeyboardGuardian
    
    enum Stage {
        case
        collapsed ,
        atNameEntry ,
        atPictureChoice
    }
    
    @State private var stage = Stage.collapsed
    @State private var username: String = ""
    
    @State private var showActionSheet = false

    @Binding var showImagePicker: Bool
    @Binding var pickerSource: UIImagePickerController.SourceType
    @Binding var imagePicked: UIImage
    
    let frameHeight = CGFloat(135)
    
    var body: some View {
        
        
        
        ZStack {

            if stage == .collapsed {
                Button(action: {
                    self.stage = .atNameEntry
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 30))
                        .foregroundColor(Color.white)
                        .padding(15)
                        .contentShape(Rectangle())
                        .background(Color.orangeStart)
                        .clipShape(Rectangle()).cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                }
            } else if stage == .atNameEntry {
                
                LinearGradient(Color.orangeStart, Color.orangeEnd)
                
                    
                    VStack (alignment: .center) {
                        TextField("Enter name", text: self.$username,onEditingChanged: { if $0 { /*self.kGuardian.showField = 0 */} }, onCommit: {self.stage = .atPictureChoice})
                            .font(.system(size: 30))
                            .font(.system(.largeTitle, design: .rounded))
                            .padding()
                            .foregroundColor(Color.white)
                            .background(Color.offWhite).opacity(0.8)
                            .cornerRadius(10.0)
                            .padding(.horizontal, self.frameHeight/2)
                            .keyboardType(.default)
                            .edgesIgnoringSafeArea(.bottom)
                    }
                   

                
                
                
            } else if stage == .atPictureChoice {
                
                LinearGradient(Color.orangeStart, Color.orangeEnd)
                
                HStack () {
                    
                    
                    Button(action: {
                        self.showActionSheet.toggle()
                    }) {
                        AvatarView(image: self.imagePicked)
                            .padding(10)
                            .frame(width: frameHeight*2/3, height: frameHeight*2/3)
                    }
                    .actionSheet(isPresented: $showActionSheet, content: {
                        ActionSheet(title: Text("Picture source"), buttons: [
                            .default(Text("Camera"), action: {
                                self.pickerSource = .camera
                                self.showImagePicker.toggle()
                                self.imagePicked = UIImage()
                            }),
                            .default(Text("Photo Library"), action: {
                                self.pickerSource = .photoLibrary
                                self.showImagePicker.toggle()
                                self.imagePicked = UIImage()
                                
                            }),
                            .destructive(Text("Cancel"))
                        ])
                    })
                        
//                    .sheet(isPresented: self.$showImagePicker, content: {
//                        ImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked, source: self.pickerSource)
//                            .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
//                    })
                    
                    Text(self.username)
                        .fontWeight(.semibold)
                        .font(.system(.largeTitle, design: .rounded))
                        .foregroundColor(Color .offWhite)
                    
                    Spacer()
                    
                    Button(action: {
                        self.game.addPlayer(player: Player(name: self.username, photoImage: self.imagePicked, colorGradient: LinearGradient.grad2))
                        self.stage = .collapsed
                        self.username = ""
                        self.imagePicked = UIImage()
                    }) {
                        Image(systemName: "checkmark")
                            .font(.system(size: 30, weight: .light, design: .default))
                            .foregroundColor(Color.white)
                            .padding()
                            .contentShape(Circle())
                            //                        .overlay(Circle().strokeBorder(Color.white, lineWidth: 2))
                            .padding()
                    }
                    
                    
                    
                } // End of HStack
                
            }
            
//            if self.showImagePicker {
//                ImagePickerView(isPresented: self.$showImagePicker, selectedImage: self.$imagePicked, source: self.pickerSource)
//            }
            
        } // End of ZStack
        .frame(height: stage == .collapsed ? 70 : frameHeight)
        .frame(maxWidth: .infinity)
        .clipShape(Rectangle()).cornerRadius(14)
        .opacity(1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

//struct AddPlayerView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddPlayerView(game: .constant(Game()), kGuardian: KeyboardGuardian(textFieldCount: 1))
//    }
//}





