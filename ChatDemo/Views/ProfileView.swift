//
//  ProfileView.swift
//  ChatDemo
//
//  Aura Chat — pantalla "Perfil de usuario".
//  Traducida del código HTML de referencia (aura_chat_perfil_de_usuario).
//

import SwiftUI
import UIKit

// MARK: - View

struct ProfileView: View {
    let contact: String
    @Binding var path: NavigationPath

    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var notificationsOn = true
    @State private var expiry: Expiry = .sevenDays
    @State private var showingToast = false
    @State private var toastMessage = ""
    @State private var showingSettings = false

    enum Expiry: String, CaseIterable, Identifiable {
        case sevenDays = "7 días"
        case twentyFourHours = "24 horas"
        case ninetyDays = "90 días"

        var id: String { rawValue }
    }

    var body: some View {
        ZStack {
            Color.auraBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header: back + título + avatar pequeño
                header

                ScrollView {
                    VStack(spacing: .auraSpaceLG) {
                        // Spotlight: avatar grande + identidad + acciones rápidas
                        spotlightCard

                        // Sección: Información
                        groupedSection(title: "Información") {
                            infoRow(icon: "smartphone", title: "Teléfono móvil", subtitle: "+34 682 914 205", trailing: .none)
                            Divider().padding(.leading, 76)
                            infoRow(icon: "alternate_email", title: "Usuario Aura", subtitle: "@sofia.design", trailing: .verified)
                            Divider().padding(.leading, 76)
                            bioRow
                        }

                        // Sección: Archivos y Multimedia
                        mediaSection

                        // Sección: Seguridad & Privacidad
                        groupedSection(title: "Seguridad & Privacidad") {
                            toggleRow(icon: "notifications.active", iconColor: .auraSecondary, title: "Notificaciones personalizadas", subtitle: "Tono \"Cristal\" y vibración háptica", isOn: $notificationsOn)
                            Divider().padding(.leading, 76)
                            expiryRow
                            Divider().padding(.leading, 76)
                            e2eRow
                        }

                        // Sección: acciones finales
                        actionSection

                        Spacer(minLength: 30)
                    }
                    .padding(.top, 8)
                }

                // Toast flotante
                if showingToast {
                    ToastView(message: toastMessage)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 30)
                        .padding(.horizontal, 20)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .tint(.auraPrimary)
        .sheet(isPresented: $showingSettings) {
            SettingsView()
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: .auraSpaceXS) {
            Button(action: { path.removeLast() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 26, weight: .regular))
                    .foregroundStyle(Color.auraPrimary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(Color.auraPrimary)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))

            Text("Contact Profile")
                .font(.auraHeadlineSM)
                .fontWeight(.semibold)
                .foregroundStyle(Color.auraOnSurface)
                .lineLimit(1)

            Spacer()

            // Avatar pequeño (dueño del perfil)
            Circle()
                .fill(Color.auraSurfaceContainerHigh)
                .frame(width: 32, height: 32)
                .overlay {
                    Text(contact.prefix(1).uppercased())
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                }
        }
        .padding(.horizontal, .auraGutter)
        .padding(.vertical, 10)
        .background(Color.auraGlassBar)
        .overlay(
            Rectangle().frame(height: 0.5).foregroundStyle(Color.black.opacity(0.08)),
            alignment: .bottom
        )
    }

    // MARK: - Spotlight card

    private var spotlightCard: some View {
        VStack(spacing: .auraSpaceMD) {
            // Glows decorativos
            ZStack {
                Circle()
                    .fill(Color.auraPrimary.opacity(0.18))
                    .frame(width: 176, height: 176)
                    .blur(radius: 40)
                    .offset(x: 90, y: -110)
                Circle()
                    .fill(Color.auraSecondary.opacity(0.14))
                    .frame(width: 192, height: 192)
                    .blur(radius: 40)
                    .offset(x: -80, y: 130)
            }

            // Avatar grande con badge verificado
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.auraSurfaceContainerLowest)
                    .frame(width: 112, height: 112)
                    .shadow(color: .black.opacity(0.12), radius: 16, x: 0, y: 6)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 44, weight: .light))
                            .foregroundStyle(Color.auraOnSurfaceVariant)
                    }
                Circle()
                    .fill(Color.auraPrimary)
                    .frame(width: 28, height: 28)
                    .overlay(Image(systemName: "checkmark.seal.fill").font(.system(size: 17, weight: .bold)).foregroundStyle(.white))
                    .offset(x: 16, y: 16)
                    .shadow(color: .black.opacity(0.2), radius: 6)
            }

            Text(contact)
                .font(.auraHeadlineLG)
                .fontWeight(.semibold)
                .foregroundStyle(Color.auraOnSurface)

            Text("@sofia.design")
                .font(.auraLabelMD)
                .fontWeight(.semibold)
                .foregroundStyle(Color.auraPrimary)

            // Status / vibe pill
            HStack(spacing: .auraSpaceXS) {
                Circle()
                    .fill(Color.auraSurfaceContainerHighest.opacity(0.6))
                    .frame(width: 8, height: 8)
                    .shadow(color: Color.auraTertiary.opacity(0.5), radius: 4)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: true)
                Text("Creando experiencias digitales ✨")
                    .font(.auraBodySM)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Color.auraSurfaceContainerHighest.opacity(0.6))
            .clipShape(Capsule())

            // Barra de acciones rápidas (4 píldoras)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: .auraSpaceXS), count: 4), spacing: .auraSpaceXS) {
                QuickActionPill(icon: "chat.bubble.fill", iconColor: .white, bg: .auraPrimaryContainer, label: "Mensaje", textColor: .white, weight: .semibold)
                QuickActionPill(icon: "phone.fill", iconColor: .auraPrimary, bg: .clear, label: "Llamar", textColor: .auraOnSurface, weight: .medium)
                QuickActionPill(icon: "video.fill", iconColor: .auraPrimary, bg: .clear, label: "Video", textColor: .auraOnSurface, weight: .medium)
                QuickActionPill(icon: "bell.slash.fill", iconColor: .auraOnSurfaceVariant, bg: .clear, label: "Silenciar", textColor: .auraOnSurfaceVariant, weight: .medium)
            }
        }
        .padding(.auraSpaceLG)
        .frame(maxWidth: .infinity)
        .background(Color.auraSurfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
        )
        .padding(.horizontal, .auraGutter)
    }

    // MARK: - Sección Información

    private var bioRow: some View {
        HStack(alignment: .top, spacing: .auraSpaceMD) {
            Circle()
                .fill(Color.auraSurfaceContainer)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: "format.quote").font(.system(size: 19)).foregroundStyle(Color.auraPrimary))
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text("Biografía")
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                Text("Lead Product & Interaction Designer. Obsesionada con la tipografía suiza, la micro-animación háptica y el café de especialidad.")
                    .font(.auraBodyMD)
                    .foregroundStyle(Color.auraOnSurface)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, .auraSpaceLG)
    }

    // MARK: - Sección Archivos y Multimedia

    private var mediaSection: some View {
        VStack(alignment: .leading, spacing: .auraSpaceSM) {
            HStack {
                Text("Archivos y Multimedia")
                    .font(.auraLabelMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOutline)
                    .textCase(.uppercase)
                    .tracking(0.5)
                Spacer()
                Button(action: {}) {
                    Text("Ver todos (148)")
                        .font(.auraLabelSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraPrimary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, .auraGutter)

            // Filtros
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: .auraSpaceXS) {
                    MediaPill(title: "Todo", isSelected: true)
                    MediaPill(title: "Fotos", isSelected: false)
                    MediaPill(title: "Enlaces", isSelected: false)
                    MediaPill(title: "Documentos", isSelected: false)
                }
                .padding(.horizontal, .auraGutter)
            }

            // Mosaico + destacados
            VStack(spacing: .auraSpaceMD) {
                // Mosaico 3 columnas (solo placeholder de fotos)
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 3), spacing: 8) {
                    ForEach(0..<3) { _ in
                        MediaTile()
                    }
                }
                .padding(.horizontal, .auraSpaceLG)

                // Link destacado
                mediaHighlightRow(icon: "link", iconColor: .auraPrimary, bg: Color.auraPrimaryContainer, title: "sofiavaldes.studio/tokens", subtitle: "Sistema de diseño dinámico v2.4 • Figma", chevron: "arrow.up.right")

                // Documento destacado
                mediaHighlightRow(icon: "doc", iconColor: .auraSecondary, bg: .auraSurfaceContainerHighest, title: "Propuesta_Identidad_Aura.pdf", subtitle: "4.8 MB • Ayer, 18:24", chevron: "arrow.down")
            }
            .padding(.horizontal, .auraGutter)
            .padding(.bottom, 8)
        }
    }

    private func mediaHighlightRow(icon: String, iconColor: Color, bg: Color, title: String, subtitle: String, chevron: String) -> some View {
        HStack(spacing: .auraSpaceMD) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundStyle(iconColor)
                .frame(width: 40, height: 40)
                .background(bg)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.auraLabelLG)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.auraBodySM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
            Image(systemName: chevron)
                .font(.system(size: 18))
                .foregroundStyle(Color.auraOutlineVariant)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
        .background(Color.auraSurfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }

    // MARK: - Sección Seguridad & Privacidad

    private var expiryRow: some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(Color.auraSurfaceContainerHighest)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: "hourglass.bottom").font(.system(size: 19)).foregroundStyle(Color.auraPrimary))

            VStack(alignment: .leading, spacing: 2) {
                Text("Mensajes temporales")
                    .font(.auraBodyMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
                Text("Desaparecen tras su lectura")
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
            }
            Spacer(minLength: 0)

            HStack(spacing: 4) {
                Text(expiry.rawValue)
                    .font(.auraLabelMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.auraPrimaryContainer)
                    .clipShape(Capsule())
                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.auraOutlineVariant)
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, .auraSpaceLG)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.spring(response: 0.25, dampingFraction: 0.85)) {
                cycleExpiry()
            }
            showToast("Mensajes temporales cambiados a \(expiry.rawValue)")
        }
    }

    private var e2eRow: some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(Color.auraPrimaryContainer)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: "lock.fill").font(.system(size: 20)).foregroundStyle(Color.auraPrimary))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 4) {
                    Text("Cifrado de extremo a extremo")
                        .font(.auraBodyMD)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraOnSurface)
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.auraPrimary)
                }
                Text("Los mensajes, audios y llamadas están asegurados con clave criptográfica privada. Toca para verificar el código de seguridad.")
                    .font(.auraBodySM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .lineLimit(2)
            }
            Spacer(minLength: 0)

            Button(action: {}) {
                HStack(spacing: 4) {
                    Text("Verificar clave única")
                        .font(.auraLabelSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraPrimary)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.auraPrimary)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, .auraSpaceLG)
    }

    // MARK: - Sección acciones finales

    private var actionSection: some View {
        VStack(spacing: 0) {
            actionRow(icon: "ios.share", iconColor: .auraPrimary, title: "Compartir contacto", subtitle: nil, destructive: false)
            Divider().padding(.leading, 76)
            actionRow(icon: "archivebox", iconColor: .auraOnSurfaceVariant, title: "Exportar historial de chat", subtitle: nil, destructive: false)
            Divider().padding(.leading, 76)
            actionRow(icon: "hand.raised.fill", iconColor: .auraError, title: "Bloquear a \(contact)", subtitle: "No podrá enviarte mensajes ni llamarte", destructive: true)
            Divider().padding(.leading, 76)
            settingsAppRow
            Divider().padding(.leading, 76)
            Button(action: {
                Task {
                    await authViewModel.signOut()
                }
            }) {
                HStack(spacing: .auraSpaceMD) {
                    Circle()
                        .fill(Color.auraError.opacity(0.15))
                        .frame(width: 36, height: 36)
                        .overlay(Image(systemName: "arrow.right.to.circle.fill").font(.system(size: 19)).foregroundStyle(Color.auraError))

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Cerrar sesión")
                            .font(.auraBodyMD)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.auraError)
                        Text("Salir de tu cuenta de Aura Chat")
                            .font(.auraLabelSM)
                            .foregroundStyle(Color.auraOutline)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.auraOutlineVariant)
                }
                .padding(.vertical, 18)
                .padding(.horizontal, .auraSpaceLG)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .background(Color.auraSurfaceContainerLowest)
        .clipShape(RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
        .overlay(
            RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous)
                .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
        )
        .padding(.horizontal, .auraGutter)
    }

    // MARK: - Helpers

    @ViewBuilder
    private func groupedSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: .auraSpaceXS) {
            Text(title)
                .font(.auraLabelMD)
                .fontWeight(.semibold)
                .foregroundStyle(Color.auraOutline)
                .textCase(.uppercase)
                .tracking(0.5)
                .padding(.horizontal, .auraGutter)
            content()
                .background(Color.auraSurfaceContainerLowest)
                .clipShape(RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous))
                .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
                .overlay(
                    RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous)
                        .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
                )
                .padding(.horizontal, .auraGutter)
        }
    }

    @ViewBuilder
    private func infoRow(icon: String, title: String, subtitle: String, trailing: Trailing) -> some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(Color.auraSurfaceContainer)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: icon).font(.system(size: 19)).foregroundStyle(Color.auraPrimary))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                Text(subtitle)
                    .font(.auraBodyMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            switch trailing {
            case .verified:
                Text("Verificado")
                    .font(.auraLabelSM)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnTertiaryContainer)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.auraOnTertiaryContainer)
                    .clipShape(Capsule())
            case .none:
                Button(action: {
                    UIPasteboard.general.string = subtitle
                    showToast("\(title) copiado")
                }) {
                    Image(systemName: "content.copy")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.auraPrimary)
                        .frame(width: 32, height: 32)
                        .background(Color.auraSurfaceContainerLow)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, .auraSpaceLG)
        .contentShape(Rectangle())
    }

    private enum Trailing { case none, verified }

    @ViewBuilder
    private func toggleRow(icon: String, iconColor: Color, title: String, subtitle: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(iconColor.opacity(0.15))
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: icon).font(.system(size: 19)).foregroundStyle(iconColor))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.auraBodyMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
                Text(subtitle)
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
            }
            Spacer(minLength: 0)
            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .labelsHidden()
        }
        .padding(.vertical, 18)
        .padding(.horizontal, .auraSpaceLG)
    }

    @ViewBuilder
    private func actionRow(icon: String, iconColor: Color, title: String, subtitle: String?, destructive: Bool) -> some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(destructive ? Color.auraError.opacity(0.12) : Color.auraSurfaceContainer)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: icon).font(.system(size: 19)).foregroundStyle(destructive ? Color.auraError : iconColor))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.auraBodyMD)
                    .fontWeight(destructive ? .semibold : .regular)
                    .foregroundStyle(destructive ? Color.auraError : Color.auraOnSurface)
                if let subtitle {
                    Text(subtitle)
                        .font(.auraLabelSM)
                        .foregroundStyle(Color.auraOutline)
                }
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.system(size: 18))
                .foregroundStyle(destructive ? Color.auraError : Color.auraOutlineVariant)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, .auraSpaceLG)
        .contentShape(Rectangle())
    }

    private var settingsAppRow: some View {
        Button(action: { showingSettings = true }) {
            HStack(spacing: .auraSpaceMD) {
                Circle()
                    .fill(Color.auraSurfaceContainer)
                    .frame(width: 36, height: 36)
                    .overlay(Image(systemName: "gear").font(.system(size: 19)).foregroundStyle(Color.auraOnSurfaceVariant))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Configuración de la app")
                        .font(.auraBodyMD)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraOnSurface)
                    Text("Tema, privacidad, caché y más")
                        .font(.auraLabelSM)
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                }
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.auraOutlineVariant)
            }
            .padding(.vertical, 18)
            .padding(.horizontal, .auraSpaceLG)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Acciones

    private func cycleExpiry() {
        switch expiry {
        case .sevenDays: expiry = .twentyFourHours
        case .twentyFourHours: expiry = .ninetyDays
        case .ninetyDays: expiry = .sevenDays
        }
    }

    private func showToast(_ message: String) {
        toastMessage = message
        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
            showingToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                showingToast = false
            }
        }
    }
}

// MARK: - Componentes auxiliares

private struct QuickActionPill: View {
    let icon: String
    let iconColor: Color
    let bg: Color
    let label: String
    let textColor: Color
    let weight: Font.Weight

    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .regular))
                .foregroundStyle(iconColor)
                .frame(width: 40, height: 40)
                .background(bg)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
            Text(label)
                .font(.auraLabelSM)
                .fontWeight(weight)
                .foregroundStyle(textColor)
                .lineLimit(1)
        }
    }
}

private struct MediaPill: View {
    let title: String
    let isSelected: Bool

    var body: some View {
        Text(title)
            .font(.auraLabelSM)
            .fontWeight(isSelected ? .semibold : .medium)
            .foregroundStyle(isSelected ? .white : .auraOnSurfaceVariant)
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(isSelected ? Color.auraPrimaryContainer : Color.auraSurfaceContainer)
            .clipShape(Capsule())
    }
}

private struct MediaTile: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.auraSurfaceContainer)
                .aspectRatio(1, contentMode: .fill)
                .overlay(Image(systemName: "photo").font(.system(size: 24)).foregroundStyle(Color.auraOutlineVariant))
            Text("0:14")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.7))
                .clipShape(Capsule())
                .offset(x: -4, y: -4)
        }
    }
}

private struct ToastView: View {
    let message: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.auraTertiary)
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

// MARK: - Preview

#Preview {
    ProfileView(contact: "Sofía Valdés", path: .constant(NavigationPath()))
        .environmentObject(AuthenticationViewModel())
}
