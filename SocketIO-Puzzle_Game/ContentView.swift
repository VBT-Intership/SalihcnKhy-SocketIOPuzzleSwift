//
//  ContentView.swift
//  SocketIO-Puzzle_Game
//
//  Created by Salihcan Kahya on 15.07.2020.
//  Copyright © 2020 Salihcan Kahya. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var usernameText = ""
    @State var userExist = false
    @State var play = false
    
    var body: some View {
        NavigationView {
            GeometryReader {
                geo in
                VStack{
                    if !self.userExist{
                        RegisterView(usernameText: self.$usernameText, userCreated: self.$userExist, frame: .init(width: geo.size.width * 0.9, height: geo.size.height * 0.25))
                    }else{
                        Button(action:{
                            self.play = true
                        },label:{
                            Circle().fill(Color.white).shadow(radius: 4).frame(width: geo.size.width * 0.7, height: geo.size.width * 0.7).overlay(Text("PLAY").font(.largeTitle))
                        })
                    }
                    if self.play{
                        
                        NavigationLink(destination: WaitingRoomView(),isActive: self.$play ) {
                        EmptyView()
                        }
                    }
                }
            }
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
