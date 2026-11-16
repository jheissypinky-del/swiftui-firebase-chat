//
//  SettingsView.swift
//  ChatDemo
//
//  Aura Chat — pantalla "Configuración".
//  Traducida del código HTML de referencia (aura_chat_configuraci_n).
//

import SwiftUI

// MARK: - View

struct SettingsView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @State private var showingQRModal = false
    @State private var themeSelected: ThemeMode = .light
    @State private var storageUsed = 28 // porcentaje del anillo

    enum ThemeMode: String, CaseIterable, Identifiable {
        case light = "light"
        case dark = "dark"

        var id: String { rawValue }
    }

    var body: some View {
        ZStack {
            Color.auraBackground.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    // Header: perfil hero + QR + editar
                    heroCard

                    // QR Modal backdrop
                    if showingQRModal {
                        QRModalView(isPresented: $showingQRModal)
                    }

                    // Grupo 1: Seguridad y Red
                    groupedSection(title: "Seguridad y Red") {
                        settingsRow(
                            icon: "shield.fill", iconColor: .auraPrimary, bg: .auraPrimaryContainer,
                            title: "Cuenta y Seguridad",
                            subtitle: "Claves de paso, 2FA, números vinculados",
                            trailing: .none
                        )
                        Divider().padding(.leading, 76)
                        settingsRow(
                            icon: "lock.fill", iconColor: .auraPrimary, bg: .auraPrimaryContainer,
                            title: "Privacidad",
                            subtitle: "Última vez, fotos de perfil, bloqueo biométrico",
                            trailing: .badge("FaceID activo", icon: "fingerprint")
                        )
                        
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
                                    .overlay(Image(systemName: "arrow.right.to.circle.fill").font(.system(size: 19)).foregroundStyle(.auraError))
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text("Cerrar sesión")
                                        .font(.auraBodyMD)
                                        .fontWeight(.semibold)
                                        .foregroundStyle(.auraError)
                                    Text("Salir de tu cuenta de Aura Chat")
                                        .font(.auraLabelSM)
                                        .foregroundStyle(.auraOutline)
                                }
                                Spacer(minLength: 0)
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.auraOutlineVariant)
                            }
                            .padding(.vertical, 18)
                            .padding(.horizontal, .auraSpaceLG)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }

                    // Grupo 2: Preferencias de Chat
                    groupedSection(title: "Preferencias de Chat") {
                        settingsRow(
                            icon: "bubble.left.and.bubble.right", iconColor: .auraSecondary, bg: .auraSurfaceContainerHighest,
                            title: "Chats y Fondos",
                            subtitle: "Copia de seguridad en iCloud, tema por chat",
                            trailing: .none
                        )
                        Divider().padding(.leading, 76)
                        settingsRow(
                            icon: "bell.fill", iconColor: .auraError, bg: .auraError.opacity(0.12),
                            title: "Notificaciones y Sonidos",
                            subtitle: "Avisos hápticos, silenciados, previsualizaciones",
                            trailing: .none
                        )
                        Divider().padding(.leading, 76)
                        storageRow
                    }

                    // Grupo 3: Sistema y Aplicación
                    groupedSection(title: "Sistema y Aplicación") {
                        appearanceRow
                        Divider().padding(.leading, 76)
                        settingsRow(
                            icon: "info.circle.fill", iconColor: .auraOnSurfaceVariant, bg: .auraSurfaceContainerHigh,
                            title: "Ayuda y Acerca de",
                            subtitle: "Preguntas frecuentes, soporte, licencias v2.4",
                            trailing: .badge("Actualizado", icon: "checkmark.circle.fill", badgeColor: .auraSecondary)
                        )
                    }

                    // Tarjeta: Desglose de Caché Multimedia
                    cacheBreakdownCard

                    // Footer de marca
                    footerBrand

                    Spacer(minLength: 30)
                }
                .padding(.top, 8)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .tint(.auraPrimary)
    }

    // MARK: - Hero card

    private var heroCard: some View {
        VStack(spacing: 0) {
            HStack(spacing: .auraSpaceMD) {
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.auraPrimary)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(LinearGradient(colors: [.auraPrimary, .auraPrimaryContainer], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 64, height: 64)
                        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
                        .overlay {
                            Image(systemName: "person.fill")
                                .font(.system(size: 26, weight: .light))
                                .foregroundStyle(.white)
                        }
                    Circle()
                        .fill(Color.auraSurfaceContainerHighest.opacity(0.6))
                        .frame(width: 16, height: 16)
                        .overlay(Circle().fill(Color.auraTertiary).frame(width: 8, height: 8))
                        .overlay(Circle().stroke(Color.auraSurfaceContainerLowest, lineWidth: 2))
                        .offset(x: 12, y: 12)
                }

                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Mateo Silva")
                            .font(.auraHeadlineSM)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.auraOnSurface)
                            .lineLimit(1)
                        Image(systemName: "checkmark.seal.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.auraPrimaryContainer)
                    }
                    Text("En el estudio creando ideas ✨")
                        .font(.auraBodySM)
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                        .lineLimit(1)
                    Text("+34 682 910 442")
                        .font(.auraLabelSM)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.auraPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.auraSurfaceContainerLow)
                        .clipShape(Capsule())
                }

                Spacer(minLength: 0)

                Button(action: { showingQRModal = true }) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 22))
                        .foregroundStyle(Color.auraPrimaryContainer)
                        .frame(width: 44, height: 44)
                        .background(Color.auraSurfaceContainerLow)
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)

                Button(action: {}) {
                    Text("Editar perfil")
                        .font(.auraLabelSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraPrimary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, .auraGutter)
            .padding(.vertical, 14)
            .background(Color.auraSurfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous))
            .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 4)
            .overlay(
                RoundedRectangle(cornerRadius: .auraRadiusCard, style: .continuous)
                    .stroke(Color.black.opacity(0.04), lineWidth: 0.5)
            )
            .padding(.horizontal, .auraGutter)

            // Micro status / sync badge
            HStack(spacing: .auraSpaceXS) {
                Circle()
                    .fill(Color.auraSurfaceContainerHighest.opacity(0.6))
                    .frame(width: 8, height: 8)
                    .shadow(color: Color.auraTertiary.opacity(0.5), radius: 4)
                    .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: true)
                Text("Aura Sync en la nube activo")
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                Spacer(minLength: 0)
            }
            .padding(.horizontal, .auraGutter + 12)
            .padding(.top, 12)
        }
    }

    // MARK: - Settings row

    @ViewBuilder
    private func settingsRow(icon: String, iconColor: Color, bg: Color, title: String, subtitle: String, trailing: SettingsTrailing) -> some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(bg)
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: icon).font(.system(size: 19)).foregroundStyle(iconColor))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.auraHeadlineSM)
                    .foregroundStyle(Color.auraOnSurface)
                    .lineLimit(1)
                Text(subtitle)
                    .font(.auraBodySM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            switch trailing {
            case .none:
                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.auraOutlineVariant)
            case .badge(let text, let icon, let badgeColor):
                HStack(spacing: .auraSpaceXS) {
                    Image(systemName: icon)
                        .font(.system(size: 12))
                        .foregroundStyle(badgeColor)
                    Text(text)
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(badgeColor)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(badgeColor.opacity(0.15))
                .clipShape(Capsule())

                Image(systemName: "chevron.right")
                    .font(.system(size: 18))
                    .foregroundStyle(Color.auraOutlineVariant)
            }
        }
        .padding(.vertical, 14)
        .padding(.horizontal, .auraSpaceLG)
        .contentShape(Rectangle())
    }

    private enum SettingsTrailing {
        case none
        case badge(String, icon: String, badgeColor: Color = .auraTertiary)
    }

    // MARK: - Storage row

    private var storageRow: some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(Color.auraSecondary.opacity(0.2))
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: "piechart.fill").font(.system(size: 19)).foregroundStyle(Color.onSecondaryFixedVariant))

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 6) {
                    Text("Almacenamiento y Datos")
                        .font(.auraHeadlineSM)
                        .foregroundStyle(Color.auraOnSurface)
                    Spacer(minLength: 0)
                }
                Text("4.8 GB de 64 GB usados")
                    .font(.auraBodySM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            // Anillo de almacenamiento (mini)
            ZStack {
                Circle()
                    .stroke(Color.auraSurfaceContainerHigh, lineWidth: 3.5)
                    .frame(width: 32, height: 32)
                Circle()
                    .trim(from: 0, to: CGFloat(storageUsed) / 100.0)
                    .stroke(Color.auraPrimaryContainer, style: StrokeStyle(lineWidth: 3.8, lineCap: .round))
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(-90))
                Text("\(storageUsed)%")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(Color.auraOnSurface)
            }

            Image(systemName: "chevron.right")
                .font(.system(size: 18))
                .foregroundStyle(Color.auraOutlineVariant)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, .auraSpaceLG)
        .contentShape(Rectangle())
    }

    // MARK: - Appearance row

    private var appearanceRow: some View {
        HStack(spacing: .auraSpaceMD) {
            Circle()
                .fill(Color.auraPrimaryContainer.opacity(0.45))
                .frame(width: 36, height: 36)
                .overlay(Image(systemName: "paintbrush.fill").font(.system(size: 19)).foregroundStyle(Color.auraPrimaryContainer))

            VStack(alignment: .leading, spacing: 2) {
                Text("Apariencia")
                    .font(.auraHeadlineSM)
                    .foregroundStyle(Color.auraOnSurface)
                Text(themeSelected == .light ? "Modo Claro Automático" : "Modo Oscuro Forzado")
                    .font(.auraBodySM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

            // Selector Claro / Oscuro
            HStack(spacing: 4) {
                ThemePill(title: "Claro", icon: "sun.max.fill", isSelected: themeSelected == .light) {
                    themeSelected = .light
                }
                ThemePill(title: "Oscuro", icon: "moon.fill", isSelected: themeSelected == .dark) {
                    themeSelected = .dark
                }
            }
            .padding(1)
            .background(Color.auraSurfaceContainerLow)
            .clipShape(Capsule())
            .shadow(color: .black.opacity(0.04), radius: 4, x: 0, y: 1)
        }
        .padding(.vertical, 14)
        .padding(.horizontal, .auraSpaceLG)
        .contentShape(Rectangle())
    }

    private struct ThemePill: View {
        let title: String
        let icon: String
        let isSelected: Bool
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                HStack(spacing: 4) {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                    Text(title)
                        .font(.auraLabelSM)
                        .fontWeight(isSelected ? .semibold : .medium)
                }
                .foregroundStyle(isSelected ? Color.auraPrimary : Color.auraOnSurfaceVariant)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(isSelected ? Color.auraSurfaceContainerLowest : Color.clear)
                .clipShape(Capsule())
            }
            .buttonStyle(.plain)
        }
    }

    // MARK: - Cache breakdown card

    private var cacheBreakdownCard: some View {
        VStack(alignment: .leading, spacing: .auraSpaceMD) {
            HStack {
                Text("Desglose de Caché Multimedia")
                    .font(.auraLabelMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
                Spacer(minLength: 0)
                Button(action: {}) {
                    Text("Liberar 2.1 GB")
                        .font(.auraLabelSM)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.auraPrimary)
                        .underline()
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, .auraSpaceLG)

            // Barra apilada
            GeometryReader { geo in
                let totalWidth = geo.size.width
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.auraPrimaryContainer)
                        .frame(width: totalWidth * 0.45)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.auraSecondary)
                        .frame(width: totalWidth * 0.25)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.auraTertiary)
                        .frame(width: totalWidth * 0.15)
                    RoundedRectangle(cornerRadius: 1)
                        .fill(Color.auraOutlineVariant)
                        .frame(width: totalWidth * 0.15)
                }
            }
            .frame(height: 4)
            .clipShape(RoundedRectangle(cornerRadius: 2, style: .continuous))
            .padding(.horizontal, .auraSpaceLG)

            // Leyenda
            HStack(spacing: 14) {
                CacheLegendItem(color: .auraPrimaryContainer, label: "Videos", value: "2.2 GB")
                CacheLegendItem(color: .auraSecondary, label: "Fotos", value: "1.1 GB")
                CacheLegendItem(color: .auraTertiary, label: "Docs", value: "0.7 GB")
            }
            .padding(.horizontal, .auraSpaceLG)
        }
        .padding(.vertical, 16)
        .background(Color.auraSurfaceContainerLow)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
        .padding(.horizontal, .auraGutter)
        .padding(.top, 8)
    }

    private struct CacheLegendItem: View {
        let color: Color
        let label: String
        let value: String

        var body: some View {
            HStack(spacing: 4) {
                Circle().fill(color).frame(width: 6, height: 6)
                Text(label)
                    .font(.auraLabelSM)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                Text(value)
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOutlineVariant)
            }
        }
    }

    // MARK: - Footer brand

    private var footerBrand: some View {
        VStack(spacing: .auraSpaceSM) {
            Image(systemName: "bolt.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(Color.auraPrimary)
                .clipShape(Circle())
                .shadow(color: Color.auraPrimary.opacity(0.4), radius: 12, x: 0, y: 6)

            HStack(spacing: 6) {
                Image(systemName: "lock.reset.fill")
                    .font(.system(size: 16))
                    .foregroundStyle(Color.auraPrimaryContainer)
                Text("Cifrado de extremo a extremo Aura")
                    .font(.auraLabelLG)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
            }

            Text("Tus mensajes, llamadas de voz y copias sincronizadas están protegidos con el protocolo criptográfico Aura Shield.")
                .font(.auraLabelSM)
                .foregroundStyle(Color.auraOutlineVariant)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            HStack(spacing: 12) {
                Button(action: {}) {
                    Text("Términos de servicio")
                        .font(.auraLabelSM)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.auraPrimary)
                        .underline()
                }
                .buttonStyle(.plain)

                Text("•")
                    .font(.auraLabelSM)
                    .foregroundStyle(Color.auraOutlineVariant)

                Button(action: {}) {
                    Text("Política de privacidad")
                        .font(.auraLabelSM)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.auraPrimary)
                        .underline()
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 20)
    }

    // MARK: - Grouped section

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
}

// MARK: - QR Modal

private struct QRModalView: View {
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation { isPresented = false }
                }

            VStack(spacing: .auraSpaceMD) {
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(Color.auraSurfaceContainerHighest)
                    .frame(width: 48, height: 4)

                ZStack {
                    Circle()
                        .fill(LinearGradient(colors: [.auraPrimaryContainer, .auraSecondaryContainer], startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 80, height: 80)
                        .shadow(color: .black.opacity(0.15), radius: 8)
                    Image(systemName: "person.fill")
                        .font(.system(size: 30, weight: .light))
                        .foregroundStyle(.white)
                }

                Text("Mateo Silva")
                    .font(.auraHeadlineSM)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)

                Text("@mateo.aura")
                    .font(.auraLabelMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraPrimary)
                    .tracking(0.5)

                // SVG QR simplificado
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.auraSurfaceContainerLow)
                        .frame(width: 192, height: 192)
                        .shadow(color: .black.opacity(0.08), radius: 6)
                    QRCodePattern()
                        .frame(width: 150, height: 150)
                    Circle()
                        .fill(Color.auraSurfaceContainerLowest)
                        .frame(width: 32, height: 32)
                        .shadow(color: .black.opacity(0.08), radius: 4)
                        .overlay(Image(systemName: "bolt.fill").font(.system(size: 16, weight: .bold)).foregroundStyle(Color.auraPrimaryContainer))
                }

                Text("Escanea este código con cualquier cámara Aura para iniciar un chat seguro al instante.")
                    .font(.auraBodySM)
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)

                Button(action: { withAnimation { isPresented = false } }) {
                    Text("Cerrar")
                        .font(.auraLabelLG)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraOnSurface)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(Color.auraSurfaceContainerHigh)
                        .clipShape(Capsule())
                }
                .buttonStyle(.plain)
            }
            .padding(.auraSpaceLG)
            .background(Color.auraSurfaceContainerLowest)
            .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 10)
            .padding(.horizontal, 32)
            .transition(.scale.combined(with: .opacity))
        }
    }
}

// MARK: - QR Code pattern (decorative)

private struct QRCodePattern: View {
    var body: some View {
        Canvas { context, size in
            let rect = CGRect(origin: .zero, size: size)
            context.fill(Path(roundedRect: rect, cornerRadius: 8), with: .color(Color.auraSurfaceContainerLow))

            let blocks: [(CGFloat, CGFloat, CGFloat)] = [
                (0, 0, 30), (5, 5, 20), (10, 10, 10),
                (70, 0, 30), (75, 5, 20), (80, 10, 10),
                (0, 70, 30), (5, 75, 20), (10, 80, 10),
                (45, 65, 8), (65, 88, 6), (75, 75, 12),
                (85, 55, 3.5)
            ]
            for (x, y, w) in blocks {
                context.fill(Path(roundedRect: CGRect(x: x / 100 * size.width, y: y / 100 * size.height, width: w / 100 * size.width, height: w / 100 * size.height), cornerRadius: 1), with: .color(Color.black.opacity(0.85)))
            }
            context.fill(Path(ellipseIn: CGRect(x: 40 / 100 * size.width, y: 20 / 100 * size.height, width: 8 / 100 * size.width, height: 8 / 100 * size.height)), with: .color(Color.black.opacity(0.85)))
            context.fill(Path(ellipseIn: CGRect(x: 60 / 100 * size.width, y: 50 / 100 * size.height, width: 8 / 100 * size.width, height: 8 / 100 * size.height)), with: .color(Color.auraPrimary))
            context.fill(Path(ellipseIn: CGRect(x: 55 / 100 * size.width, y: 45 / 100 * size.height, width: 7 / 100 * size.width, height: 7 / 100 * size.height)), with: .color(Color.black.opacity(0.85)))
        }
    }
}

// MARK: - Helper colors not in DesignSystem (kept local to avoid ripple)

extension Color {
    fileprivate static var onSecondaryFixedVariant: Color { Color(hex: 0x00468D) }
    fileprivate static var auraSecondaryContainer: Color { Color(hex: 0x0073E0) }
}

private extension Color {
    init(hex: UInt32, opacity: Double = 1.0) {
        let red = Double((hex >> 16) & 0xFF) / 255.0
        let green = Double((hex >> 8) & 0xFF) / 255.0
        let blue = Double(hex & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
}

#Preview {
    SettingsView()
}
