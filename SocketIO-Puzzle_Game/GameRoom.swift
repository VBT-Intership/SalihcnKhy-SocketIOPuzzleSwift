//
//  GameRoom.swift
//  SocketIO-Puzzle_Game
//
//  Created by Gülnur Kasarcı on 18.07.2020.
//  Copyright © 2020 Salihcan Kahya. All rights reserved.
//

import SwiftUI

struct GameRoom: View {
    
    @Binding var roomName : String
    @State var puzzleWord = ""

    func setPuzzleWord(_ notification : Notification){
        
        if let data = notification.object as? String{
            puzzleWord = data
        }
    }
    
    var body: some View {
        VStack{
            Text("Room : "  + roomName).font(.headline)
            Text("Word : "  + puzzleWord).font(.subheadline)
            
        }
      .onAppear{
            
            self.addObserverAndListen()
        }
    }
    func addObserverAndListen(){
        NotificationCenter.default.addObserver(forName: .init("newWord"), object: nil, queue: nil, using: self.setPuzzleWord(_:))
        UserTasks.shared.ConnectGameRoom(with: self.roomName, completion: {
            
            UserTasks.shared.Listen(to: "setWord") { (data) in
                
                guard let data = data as? String else {return}
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newWord"), object: data)
            }
            UserTasks.shared.SendMessage(with: "getWord")
        })
    }
}

struct GameRoom_Previews: PreviewProvider {
    static var previews: some View {
        GameRoom(roomName: .constant("halo"))
    }
}
