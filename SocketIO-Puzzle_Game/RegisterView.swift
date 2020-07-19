//
//  RegisterView.swift
//  SocketIO-Puzzle_Game
//
//  Created by Gülnur Kasarcı on 18.07.2020.
//  Copyright © 2020 Salihcan Kahya. All rights reserved.
//

import SwiftUI

struct RegisterView: View {
    
    @Binding var usernameText : String
    @Binding var userCreated : Bool
    @State var hasError = false
    let frame : CGSize
    
    
    
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white).shadow(radius: 4)
            
            VStack(alignment: .center,spacing: 18){
                Text("Kullanıcı adı giriniz")
                    .padding(.top,10).font(Font.system(size: 20)).frame(width: self.frame.width * 0.9)
                buildTextField()
                buildAddButton()
                
            }.padding()
        }
        .frame(width: self.frame.width, height: self.frame.height)
    }
    
    
    fileprivate func buildTextField() -> some View {
        return HStack {
            Image(systemName: "person").foregroundColor(.gray).padding(.leading,10).padding(.trailing,5)
            TextField("Username", text: $usernameText)
                .multilineTextAlignment(.leading)
            if self.hasError{
                Image(systemName:"exclamationmark.triangle.fill").foregroundColor(Color.red).padding(.trailing,10)
            }
        }.frame(minWidth: self.frame.width * 0.8, minHeight: self.frame.height * 0.22 , maxHeight: self.frame.height * 0.25).overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
    }
    
    fileprivate func buildAddButton() -> some View {
        return Button(action :addButtonAction ,label :{
            ZStack{
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.white)
                    .shadow(radius: 1)
                    .frame(width: self.frame.width * 0.65, height: self.frame.height * 0.2)
                Text("Ekle")
            }
        })
    }
    
    func addButtonAction(){
        UserTasks.shared.SendMessage(with: "register", data: ["username":usernameText])
        UserTasks.shared.Listen(to: "register") { (data) in
            guard let data = data as? Bool else {return}
            if data{
                self.userCreated = true
            }else{
                withAnimation{
                    self.hasError = true
                }
            }
        }
    }
    
}

struct RegisterView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        RegisterView(usernameText: Binding<String>.constant(""), userCreated: .constant(false),frame: .init(width: 300, height: 150))
    }
}
