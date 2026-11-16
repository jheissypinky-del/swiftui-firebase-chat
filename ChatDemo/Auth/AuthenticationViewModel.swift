//
//  AuthenticationViewModel.swift
//  ChatDemo
//
//  ViewModel que gestiona la autenticación con Firebase Authentication.
//

import Foundation
import Combine
import FirebaseAuth

@MainActor
class AuthenticationViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var isAuthenticating = false
    @Published var authError: String?
    @Published var isAuthenticated: Bool = false

    private var cancellables = Set<AnyCancellable>()

    init() {
        // Escuchar cambios en el estado de autenticación de Firebase
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.userSession = user
                self?.isAuthenticated = user != nil
            }
        }
    }

    // MARK: - Sign in con email y contraseña
    func signIn(email: String, password: String) async {
        isAuthenticating = true
        authError = nil

        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            self.isAuthenticated = true
        } catch {
            self.authError = error.localizedDescription
        }

        isAuthenticating = false
    }

    // MARK: - Crear cuenta (sign up)
    func signUp(email: String, password: String) async {
        isAuthenticating = true
        authError = nil

        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            self.isAuthenticated = true
        } catch {
            self.authError = error.localizedDescription
        }

        isAuthenticating = false
    }

    // MARK: - Sign out
    func signOut() async {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.isAuthenticated = false
        } catch {
            self.authError = error.localizedDescription
        }
    }

    // MARK: - Limpiar error
    func clearError() {
        authError = nil
    }
}
