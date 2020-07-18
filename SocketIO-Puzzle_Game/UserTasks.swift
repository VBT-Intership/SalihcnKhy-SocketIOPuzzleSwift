//
//  UserTasks.swift
//  SocketIO-Puzzle_Game
//
//  Created by Gülnur Kasarcı on 18.07.2020.
//  Copyright © 2020 Salihcan Kahya. All rights reserved.
//

import Foundation

class UserTasks {
    
    
    
    public static var shared = UserTasks()
    
    private var siom = SocketIOManager.shared
    
    private init(){}
    

    func ConnectWaitingRoom(completion : @escaping ()->Void){
        siom.changeNamespace(nps: "/waitingRoom") {
            
            print("connected waiting room")
            completion()
            
        }
    }
    func Listen(to event: String, completion : @escaping (Any)->Void){
        self.siom.addListener(to: event) { (data) in
            completion(data)
            self.siom.socket.removeAllHandlers()
        }
    }
    func SendMessage(with event: String, data : Any){
        siom.emit(message: (to: event, data: data))
    }
    func ConnectGameRoom(with name: String,completion : @escaping ()->Void){
            self.siom.changeNamespace(nps: "/gameRooms/"+name) {
                completion()
                self.siom.socket.removeAllHandlers()
        }
    }
    
}
