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

    var body: some Scene {
        WindowGroup {
            Group {
                if authViewModel.isAuthenticated {
                    ChatListView()
                        .environmentObject(authViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}
