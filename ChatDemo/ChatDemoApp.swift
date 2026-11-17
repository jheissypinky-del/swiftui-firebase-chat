//
//  ChatDemoApp.swift
//  ChatDemo
//
//  Created by Jorgito on 13/11/26.
//

import SwiftUI
import FirebaseCore

@main
struct ChatDemoApp: App {
    // Inicializar Firebase al lanzar la app
    init() {
        FirebaseApp.configure()
    }

    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var chatViewModel = ChatViewModel()

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    ChatListView()
                        .environmentObject(authViewModel)
                        .environmentObject(chatViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                        .environmentObject(chatViewModel)
                }
            }
        }
    }
}
