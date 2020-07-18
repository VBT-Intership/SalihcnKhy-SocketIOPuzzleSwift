//
//  SocketIOManager.swift
//  SocketIO-Puzzle_Game
//
//  Created by Salihcan Kahya on 15.07.2020.
//  Copyright © 2020 Salihcan Kahya. All rights reserved.
//

import Foundation
import SocketIO


class SocketIOManager {
    
    
    let manager = SocketManager(socketURL: URL(string: "http://192.168.1.104:3000")!, config: [.log(true), .compress])
    var socket: SocketIOClient!

    static let shared = SocketIOManager()

    
    private init(){
        socket = manager.defaultSocket
    }
    
    func StartConnection(){
        socket.connect()
    }
    
    func changeNamespace(nps : String , completion : @escaping ()->Void){
        
        socket = manager.socket(forNamespace: nps)
        
        socket.on(clientEvent: .connect) { (_, _) in
            
            completion()
        }
        socket.connect()
        
    }
    func emit(message : (to: String, data:  Any )){
        socket.emit(message.to, with: [message.data])
    }
    
    func addListener(to event: String, completion : @escaping (Any)->Void){
        socket.on(event) { (data, _) in
                
          completion(data[0])
        }
    }
    
}
