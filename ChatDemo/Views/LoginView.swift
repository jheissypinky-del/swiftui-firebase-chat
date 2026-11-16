//
//  LoginView.swift
//  ChatDemo
//
//  Aura Chat — pantalla "Iniciar sesión".
//  Traducida del código HTML de referencia (aura_chat_iniciar_sesion).
//  Ahora usa Firebase Authentication para email/password.
//

import SwiftUI
import LocalAuthentication
import FirebaseAuth

// MARK: - View

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel

    @State private var authMode: AuthMode = .email
    @State private var email = ""
    @State private var password = ""
    @State private var isSignUpMode = false
    @State private var showingToast = false
    @State private var toastMessage = ""
    @State private var toastType: ToastType = .success

    enum AuthMode: String, CaseIterable, Identifiable {
        case email = "Correo"
        case phone = "Teléfono"

        var id: String { rawValue }
    }

    enum ToastType {
        case success, info, error
    }

    var body: some View {
        ZStack {
            // Fondo base
            Color.auraBackground.ignoresSafeArea()

            // Glows ambientales decorativos
            ambientGlows

            VStack(spacing: 0) {
                // Top bar: acciones micro
                topBar

                // Hero: identidad de marca
                heroSection
                    .frame(maxWidth: .infinity, alignment: .center)

                // Tarjeta principal de autenticación (glassmorfica)
                mainCard
                    .padding(.horizontal, .auraGutter)

                // Divider biometría
                biometricsDivider
                    .frame(maxWidth: .infinity, alignment: .center)
                Spacer()

                // Acciones rápidas (Apple ID / Face ID)
                quickActions

                // Footer legal
                footer

                // Espacio inferior (home indicator)
                Spacer(minLength: 30)
            }
            .padding(.top, 8)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .animation(.spring(response: 0.3, dampingFraction: 0.85), value: authMode)
        .overlay(alignment: .bottom) {
            // Toast flotante
            if showingToast {
                ToastView(message: toastMessage, type: toastType)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .padding(.bottom, 30)
                    .padding(.horizontal, 20)
            }
        }
        .tint(.auraPrimary)
        // Mostrar errores de autenticación como toast
        .onChange(of: authViewModel.authError) { _, newError in
            if let error = newError {
                showToast(error, type: .error)
                authViewModel.clearError()
            }
        }
        .onChange(of: authViewModel.isAuthenticated) { _, isAuthenticated in
            if isAuthenticated {
                showToast("Sesión iniciada correctamente", type: .success)
            }
        }
    }

    // MARK: - Subviews

    private var ambientGlows: some View {
        ZStack {
            Circle()
                .fill(Color.auraPrimary.opacity(0.25))
                .frame(width: 320, height: 320)
                .blur(radius: 60)
                .offset(x: 0, y: -220)
            Circle()
                .fill(Color.auraSecondary.opacity(0.20))
                .frame(width: 256, height: 256)
                .blur(radius: 50)
                .offset(x: 140, y: 180)
        }
        .ignoresSafeArea()
    }

    private var topBar: some View {
        HStack {
            // Píldora "Red segura"
            HStack(spacing: .auraSpaceXS) {
                Circle()
                    .fill(Color.auraTertiary)
                    .frame(width: 8, height: 8)
                    .shadow(color: Color.auraTertiary.opacity(0.5), radius: 4)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: true)
                Text("Red segura")
                    .font(.auraLabelSM)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .tracking(0.5)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.auraSurfaceContainerLow)
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)

            Spacer()

            // Botón Ayuda
            Button(action: {}) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 19))
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .frame(width: 36, height: 36)
                    .background(Color.auraSurfaceContainerLow)
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, .auraGutter)
    }

    private var heroSection: some View {
        VStack(spacing: .auraSpaceSM) {
            // Logo con glow
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.auraPrimaryContainer.opacity(0.2))
                    .blur(radius: 20)
                    .frame(width: 100, height: 100)
                Circle()
                    .fill(Color.white)
                    .frame(width: 96, height: 96)
                    .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)
                    .overlay {
                        VStack(spacing: 2) {
                            Text("Aura Chat")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(Color.auraOnSurface)
                            Text("App")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundStyle(Color.auraOnSurfaceVariant)
                        }
                    }
                // Badge rayo abajo-derecha
                Circle()
                    .fill(Color.auraPrimary)
                    .frame(width: 24, height: 24)
                    .overlay(Image(systemName: "bolt.fill").font(.system(size: 14, weight: .bold)).foregroundStyle(.white))
                    .shadow(color: Color.auraPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                    .offset(x: 10, y: 10)
            }
            .scaleEffect(1.0)
            .animation(.spring(response: 0.4, dampingFraction: 0.7), value: true)

            // Texto hero - permite crecer en vertical sin límites
            VStack(alignment: .center, spacing: .auraSpaceXS) {
                Text("Conéctate sin límites")
                    .font(.auraHeadlineXL)
                    .fontWeight(.bold)
                    .foregroundStyle(Color.auraOnSurface)
                    .multilineTextAlignment(.center)
                    .tracking(-0.01)
                Text("Mensajería privada ultrarrápida, cifrado nativo y fluidez sensorial diseñada para iOS.")
                    .font(.auraBodyMD)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 40)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 20)
    }

    private var mainCard: some View {
        VStack(spacing: .auraSpaceLG) {
            // Segment switcher Correo / Teléfono
            HStack(spacing: 2) {
                ForEach(AuthMode.allCases) { mode in
                    Button(action: { authMode = mode }) {
                        Text(mode.rawValue)
                            .font(.auraLabelLG)
                            .fontWeight(.semibold)
                            .foregroundStyle(authMode == mode ? Color.white : Color.auraOnSurfaceVariant)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 8)
                            .background(
                                authMode == mode
                                ? Color.auraPrimary
                                : Color.clear
                            )
                            .clipShape(Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(2)
            .background(Color.auraSurfaceContainerLow)
            .clipShape(Capsule())

            // Área de inputs
            VStack(spacing: .auraSpaceSM) {
                if authMode == .email {
                    emailInputGroup
                } else {
                    phoneInputGroup
                }

                // Hint dinámico
                HStack(spacing: .auraSpaceXS) {
                    Image(systemName: "text.badge.checkmark")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.auraPrimary)
                    Text(authMode == .email
                         ? "Inicia sesión con tu correo y contraseña"
                         : "Verificación instantánea por código seguro")
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
            }

            // Botón primario
            Button(action: submit) {
                HStack(spacing: 8) {
                    Text(isSignUpMode ? "Crear cuenta" : "Iniciar sesión")
                        .font(.auraHeadlineSM)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.forward")
                        .font(.system(size: 20, weight: .regular))
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.auraPrimaryContainer)
                .clipShape(Capsule())
                .shadow(color: Color.auraPrimary.opacity(0.3), radius: 12, x: 0, y: 6)
                .scaleEffect(authViewModel.isAuthenticating ? 0.98 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: authViewModel.isAuthenticating)
            }
            .buttonStyle(.plain)
            .disabled(authViewModel.isAuthenticating)

            // Toggle entre Iniciar sesión / Crear cuenta (solo email)
            if authMode == .email {
                Button(action: { isSignUpMode.toggle() }) {
                    HStack(spacing: 4) {
                        Text(isSignUpMode ? "¿Ya tienes cuenta?" : "¿No tienes cuenta?")
                            .font(.auraLabelSM)
                            .foregroundStyle(Color.auraOnSurfaceVariant)
                        Text(isSignUpMode ? "Inicia sesión" : "Regístrate")
                            .font(.auraLabelSM)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.auraPrimary)
                    }
                }
                .buttonStyle(.plain)
                .padding(.top, .auraSpaceXS)
            }
        }
        .padding(.auraSpaceLG)
        .background(Color.auraSurfaceContainerLowest.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous))
        .shadow(color: Color.black.opacity(0.10), radius: 20, x: 0, y: 8)
        .overlay(
            RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
        )
    }

    private var phoneInputGroup: some View {
        HStack(spacing: 8) {
            // Selector de país (píldora)
            Button(action: {}) {
                HStack(spacing: 4) {
                    Text("🇲🇽")
                        .font(.system(size: 18))
                    Text("+52")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color.auraOnSurface)
                    Image(systemName: "chevron.down")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                }
                .padding(.horizontal, 10)
                .frame(height: 56)
                .background(Color.auraSurfaceContainerLow)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)

            // Campo de teléfono
            HStack(spacing: 8) {
                Image(systemName: "phone.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                TextField("55 1234 5678", text: .constant(""))
                    .font(.auraBodyLG)
                    .foregroundStyle(Color.auraOnSurface.opacity(0.5))
                    .disabled(true)
                Text("Firebase Auth tel. requiere APNs + reCAPTCHA")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.auraError)
                    .padding(.leading, 4)
            }
            .padding(.horizontal, 12)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(Color.auraSurfaceContainerLow.opacity(0.6))
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.auraError.opacity(0.3), lineWidth: 0.5)
            )
        }
    }

    private var emailInputGroup: some View {
        VStack(spacing: .auraSpaceSM) {
            HStack(spacing: 8) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                TextField("tu@aura.chat", text: $email)
                    .font(.auraBodyLG)
                    .foregroundStyle(Color.auraOnSurface)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                if !email.isEmpty {
                    Button(action: { email = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.auraOutline)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(email.isEmpty ? Color.auraSurfaceContainerLow : Color.auraSurfaceContainerLowest)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black.opacity(email.isEmpty ? 0.06 : 0.10), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(email.isEmpty ? 0.04 : 0.08), radius: 6, x: 0, y: 2)

            // Campo de contraseña
            HStack(spacing: 8) {
                Image(systemName: "lock.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                SecureField("Contraseña", text: $password)
                    .font(.auraBodyLG)
                    .foregroundStyle(Color.auraOnSurface)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                if !password.isEmpty {
                    Button(action: { password = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.auraOutline)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 56)
            .frame(maxWidth: .infinity)
            .background(password.isEmpty ? Color.auraSurfaceContainerLow : Color.auraSurfaceContainerLowest)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.black.opacity(password.isEmpty ? 0.06 : 0.10), lineWidth: 0.5)
            )
            .shadow(color: Color.black.opacity(password.isEmpty ? 0.04 : 0.08), radius: 6, x: 0, y: 2)
        }
    }

    private var biometricsDivider: some View {
        HStack(spacing: 12) {
            Rectangle()
                .fill(Color.auraOutlineVariant)
                .frame(height: 1)
            Text("Acceso con biometría")
                .font(.auraLabelSM)
                .fontWeight(.semibold)
                .foregroundStyle(Color.auraOutline)
                .textCase(.uppercase)
                .tracking(0.5)
            Rectangle()
                .fill(Color.auraOutlineVariant)
                .frame(height: 1)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, .auraGutter)
        .padding(.vertical, 10)
    }

    private var quickActions: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10),
        ], spacing: 10) {
            // Apple ID
            Button(action: { simulateAuth(provider: "Apple ID") }) {
                HStack(spacing: 6) {
                    Image(systemName: "apple.logo")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundStyle(Color.auraOnSurface)
                    Text("Apple")
                        .font(.auraHeadlineSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraOnSurface)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.auraSurfaceContainerLowest)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                .overlay(
                    Capsule().stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                )
            }
            .buttonStyle(.plain)

            // Face ID
            Button(action: { authenticateWithFaceID() }) {
                HStack(spacing: 6) {
                    Image(systemName: "faceid")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.auraPrimary)
                    Text("Face ID")
                        .font(.auraHeadlineSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraOnSurface)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(Color.auraSurfaceContainerLowest)
                .clipShape(Capsule())
                .shadow(color: .black.opacity(0.08), radius: 6, x: 0, y: 2)
                .overlay(
                    Capsule().stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, .auraGutter)
        .padding(.vertical, 10)
    }

    private var footer: some View {
        VStack(spacing: .auraSpaceXS) {
            Text("Al continuar, confirmas que aceptas nuestros Términos de servicio y nuestra Política de privacidad. Tus llaves de cifrado nunca abandonan este dispositivo.")
                .font(.auraLabelSM)
                .foregroundStyle(Color.auraOnSurfaceVariant.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
    }

    // MARK: - Acciones

    private func submit() {
        guard !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showToast("Por favor ingresa correo y contraseña", type: .info)
            return
        }

        Task {
            if isSignUpMode {
                await authViewModel.signUp(email: email, password: password)
            } else {
                await authViewModel.signIn(email: email, password: password)
            }
        }
    }

    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            showToast("Biometría no disponible", type: .error)
            return
        }
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Autenticación para Aura Chat") { success, _ in
            Task { @MainActor in
                if success {
                    showToast("Face ID verificado. Usa correo/contraseña para acceder.", type: .success)
                } else {
                    showToast("Autenticación fallida", type: .error)
                }
            }
        }
    }

    private func simulateAuth(provider: String) {
        showToast("\(provider) requiere configuración adicional en Firebase Console", type: .info)
    }

    private func showToast(_ message: String, type: ToastType) {
        toastMessage = message
        toastType = type
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showingToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.8) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showingToast = false
            }
        }
    }
}

// MARK: - Toast

private struct ToastView: View {
    let message: String
    let type: LoginView.ToastType

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: type == .success ? "checkmark.circle.fill" : (type == .error ? "xmark.circle.fill" : "info.circle.fill"))
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(type == .success ? Color.auraTertiary : (type == .error ? Color.auraError : Color.auraPrimary))
            Text(message)
                .font(.auraLabelMD)
                .fontWeight(.medium)
                .foregroundStyle(.white)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.auraInverseSurface)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.25), radius: 16, x: 0, y: 6)
    }
}

#Preview {
    LoginView()
        .environmentObject(AuthenticationViewModel())
}