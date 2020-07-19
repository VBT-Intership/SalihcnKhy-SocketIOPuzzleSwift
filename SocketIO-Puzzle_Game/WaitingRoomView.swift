//
//  WaitingRoomView.swift
//  SocketIO-Puzzle_Game
//
//  Created by Salihcan Kahya on 18.07.2020.
//  Copyright © 2020 Salihcan Kahya. All rights reserved.
//

import SwiftUI

struct WaitingRoomView: View {
    
    @State var isGameStarting = false
    @State var gameRoomName = ""
    
    
    func setRoomName(_ notification : Notification){
        
        if let data = notification.object as? String{
            print("\n\n ROME NAME IS " + data + "\n\n")
            gameRoomName = data
            isGameStarting = true
        }
    }
    var body: some View {
        ZStack {
            Color.yellow
                .opacity(0.1)
                .edgesIgnoringSafeArea(.all)

            VStack {
                    Spacer()
                    ProgressBar()
                        .frame(width: 150.0, height: 150.0)
                        .padding(40.0)
                    Spacer()
            }
            if isGameStarting {
                NavigationLink(destination: GameRoom(roomName: $gameRoomName), isActive: self.$isGameStarting) {
                  Text("")
                }.hidden()
            }
        }.onAppear{
            NotificationCenter.default.addObserver(forName: .init("roomName"), object: nil, queue: nil, using: self.setRoomName(_:))
            
                  UserTasks.shared.ConnectWaitingRoom(completion: {
                      
                      UserTasks.shared.Listen(to: "isGameStarting") {  (data) in
                          
                          guard let data = data as? String else { return}
                          NotificationCenter.default.post(name: NSNotification.Name(rawValue: "roomName"), object: data)
                      }
                      
                  })
        }
        
    }
}

struct ProgressBar: View {
    
    var repeatAnimation : Animation {
        Animation.linear(duration: 1.2).repeatForever(autoreverses: false)}
    @State var isAnimating = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(Color.red)
            
            Circle()
                .trim(from: 0.1, to: 0.3)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                .opacity(0.9)
                .foregroundColor(Color.red)
            
        }.rotationEffect(Angle(degrees: self.isAnimating ? 360 : 0.0))
            .animation(repeatAnimation)
            .onAppear { self.isAnimating = true }
        
    }
}

struct WaitingRoomView_Previews: PreviewProvider {
    static var previews: some View {
        WaitingRoomView()
    }
}
