//
//  SwiftSockets.swift
//  iOSArchitecture_MVVM
//
//  Created by Mandeep Singh on 5/13/20.
//  Copyright © 2020 Surjeet Singh. All rights reserved.
//

import Foundation
import SwiftWebSocket

struct SwiftCallBacks {
    
    typealias callBack = () -> ()
    typealias handler = (_ success:Any) -> () // for success case
}

open class SwiftSockets {
    
    static let shared = SwiftSockets()
    var isConnected: Bool = false {
        didSet {
            self.onConnected?()
        }
    }
    var onMessage: SwiftCallBacks.handler?
    var onConnected: SwiftCallBacks.callBack?

    var socket : WebSocket!
}

extension SwiftSockets {
    
    //MARK:- initi
    func initilaize(urlString: String?) {
        guard let string = urlString else {
            fatalError("urlString is not defined")
        }
        self.webSocketString(string)
    }
    
    private func webSocketString(_ socketString: String) {
        
        guard let userToken = self.getAuthToken else {
            print("User is not having token")
            return
        }
        
        let finalString = socketString + userToken
        self.connectSocket(finalString)
    }
    
    private var getAuthToken : String? {
        if let token = UserSession.userToken {
            return "\(Keys.tokenKey)" + token
        }
        return nil
    }
    
    private func connectSocket(_ socketString: String) {
        
        socket = WebSocket(socketString)
        socket.event.open = {
            print("opened")
            self.isConnected = true
        }
        socket.event.close = { code, reason, clean in
            print("close")
            self.isConnected = false
        }
        socket.event.error = { error in
            print("error \(error)")
            self.isConnected = false
        }
        socket.event.message = { message in
            guard self.isConnected else {
               print("Socket is not connected by the User")
               return
            }
            
            if let str = message as? String {
                if let dict = str.convertToDictionary() {
                    self.onMessage?(dict)
                }
            } else {
                self.onMessage?(message)
            }
        }
    }
    
    func connectSocket() {
        if let socket = self.socket {
            socket.open()
        }
    }
    
    func disconnectSocket() {
        guard self.isConnected else {
          print("Socket is not connected by the User")
          return
       }
       self.socket.close()
    }
}


extension SwiftSockets {
    
    /// Send Message to server via sockets
    func emitt() {
        
        guard self.isConnected else {
            print("Socket is not connected by the User")
            return
        }
        
        var messageNum = 0

        let sendVar : ()->() = {
            messageNum += 1
            let msg = "\(messageNum): \(NSDate().description)"
            print("send: \(msg)")
            self.socket.send(msg)
        }
        
         sendVar()
    }
}
