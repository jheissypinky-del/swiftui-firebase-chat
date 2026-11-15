//
//  ChatDemoApp.swift
//  ChatDemo
//
//  Created by Jorgito on 13/11/26.
//

import SwiftUI

@main
struct ChatDemoApp: App {
    @State private var isAuthenticated = false

    var body: some Scene {
        WindowGroup {
            Group {
                if isAuthenticated {
                    ChatListView()
                } else {
                    LoginView(onAuthenticated: {
                        isAuthenticated = true
                    })
                }
            }
        }
    }
}
