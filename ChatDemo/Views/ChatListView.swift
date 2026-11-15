//
//  ChatListView.swift
//  ChatDemo
//
//  Aura Chat — pantalla principal: lista de conversaciones.
//  Traducida del código HTML de referencia (aura_chat_mensajes).
//

import SwiftUI

// MARK: - Model

struct Chat: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let preview: String
    let time: String
    let avatarURL: String
    let unreadCount: Int
    let isRead: Bool
    let isGroup: Bool
    let hasAudio: Bool
    let hasPhoto: Bool
    let verified: Bool
}

struct Story: Identifiable {
    let id = UUID()
    let name: String
    let avatarURL: String
    let isOwn: Bool
    let isActive: Bool
}

// MARK: - View

struct ChatListView: View {
    @State private var searchText = ""
    @State private var selectedFilter: Filter = .all
    @State private var path = NavigationPath()
    @State private var selectedTab = 0

    enum Filter: String, CaseIterable, Identifiable {
        case all = "Todos"
        case unread = "No leídos"
        case groups = "Grupos"
        case work = "Trabajo"

        var id: String { rawValue }
    }

    // Datos de ejemplo coherentes con el diseño de referencia
    private let stories: [Story] = [
        Story(name: "Tu historia", avatarURL: "", isOwn: true, isActive: false),
        Story(name: "Sofía", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCu2pv__qunYlm9v4DkxRLN1mrT3rWhgaUuhg4ecb-BS_NAMFyH9BiY_C--V949uALGgMSGoS0Kk3AI7qPmaKDj2ahIzAwqvtQiZe-eck9iTP7ubMHsb8NJO1YIW1-2W0KvLTD4LxKOY3qhrNOUswYqOZ9KBLKeequLFhat-0NICjDFQlCsFH7oDbnVUGdSYoCBYiPRczp7ysvVE3GGDujcYzTXdCMejU5yl5ge3Q/", isOwn: false, isActive: true),
        Story(name: "Mateo", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuAexFAdFJSgsK9tSu9B1veSM0d9IOtoNBgNpbfaqDGlq_7DI_BUZ_fAAy9_l3jwSCwM4B71hu7lfRauvRmwOUCqjVnBW-Yguj_PFfMZzmi1dpcd0gX5x-1mdQH6veBn2IwOPrcwNgn-UGORN-Rwzk25GHvFU4uhDuckcecuaEYyrquWaSIpdNuc4KjWwweFvtvdEU_o1jqDyJBIG74PLtaQcjLPk1tJTELu5TP0lw/", isOwn: false, isActive: true),
        Story(name: "Camila", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuChD8JhZzOg54RzfV9r2z6LhPU6ZeYfDyU2hLKX4iCaRWdeaRi39Bs3HynbKHZCwkj1qe776FLJj_IPVWoLP4WRcmb5-vyleKt23IQ0_TvU5s9m-oHg47vdlMZB9ICzi4kXZPzfuI6ZVGpOZXqudeM5p11IR76LHQIs0LxQjXWG3lVQLpaQ9r54CZoAw4kS8VJi0_sseeaO4cVGFCQbcn_fICsE2tMGSYji3N3dYg/", isOwn: false, isActive: true),
        Story(name: "Lucas", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCCMCdJouCVPZwQStdZ4Anx53O7h2VgpDrYI0EU72Fo8_-X6FpL6HEks2kWXCQz9BNO-_oJKT4riXz0n18Vr4HXQzMIhnFJ_3qsEM7HZFSOBgTcrhmajkTscZIOBfRhtOfuyk8Vv6QGqKvpJKxBTkBMagc5ADEi0FMb7ooLZbJlXDfyVUk93WTO-1ej9QahhgWiUGCrnMaE6W9UG2UR1EkBr4zZr-4avjlRYjGh9w/", isOwn: false, isActive: false),
        Story(name: "Elena", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuBpNPCvUuC7p4821z9rnPiKGlm5AMMrZZTxkFX6T3nwzmdyxTi3n9kAFeGr_ihKCSzKI57e6d3LV_zRFNaGAvIXblsx-1kYSDMjAApWQYd5awSko5rE0dcxcZXdE7dkgRd1cXNWffR4auqKsnt-3sH3M5WgUV88z137OlWVdQ5oSUUJJAvmI_4EV8P6KJlk7CHmNj0KRUyTF3x1LgzsmAZc-fKetT79DeAD9kj1Dg/", isOwn: false, isActive: false),
    ]

    private let chats: [Chat] = [
        Chat(name: "Sofía Valdés", preview: "¡Quedó increíble la propuesta de diseño! 🚀", time: "hace 2m", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuBNi8WG3_CxO2qcgGltfRK1zypr5YtOBHThZo_yRQNjs4dAjmICx_IhtVa2Oufn6XiXXhLIHWDoaTLqY5-S9nPQ0vW_ZqvN-Hu6FNDkK9YryqER79mFj65Fj9bohrB_8Ly0DfGOUoX68cAFvGEoLdGHuTHeDDYc2XO51tBK1TQTbVn_pKJDk82fa2gQW57sNoYzOWGrt8zVfTYL6XcTFx4OqYY7ScrxZTR1Lpv9dQ/", unreadCount: 2, isRead: true, isGroup: false, hasAudio: false, hasPhoto: false, verified: false),
        Chat(name: "Mateo Morales", preview: "Nos vemos en el café a las 5pm", time: "hace 15m", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCGOjHR39WgzN8lW5GCfTsqDiOBKZ8NG7iFlrN4ePOgKW2OJ8iATKEhYH20vKEROpvg7YCeeINUUI_kE33JaDbyEw8cwvVPgTEzGLtV43dlyhQlQYQcjePwzRwmo8jrPnK6eNlireHF8orDhV3ujhMDHq-i5nT3BZQ9Pv7OOcyDmqNylb-zcZPpCVBSUO4Yvik4xDHkedlqNFByKqZJdw_nwvim5-6rF_uJ8YUW2Q/", unreadCount: 0, isRead: true, isGroup: false, hasAudio: false, hasPhoto: false, verified: false),
        Chat(name: "Equipo Creativo Aura", preview: "Ya subí los assets actualizados", time: "hace 1h", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuBFyG0wSTBV5YsKEtmIVh_tx7_-pIZdrlVWoCJp1yW_Ih-YsW8xAlABytGgO1UeJJJwmN0_7Wfsrf56CzD3vmfYt7Wr_r6a9y09JJ4ErEovm-2nWyWa_9a7P3HqjtBABE1yTwEX79xog0mrjM_kISSGzsr5OGq0fwIz5FlnQvaAzesbNjxnQm_FWyyVWNR07mpVYVId49fTISfL8PBcMXU4jb3nsqMvrEwXrjj_FQ/", unreadCount: 0, isRead: true, isGroup: true, hasAudio: false, hasPhoto: false, verified: true),
        Chat(name: "Camila Ríos", preview: "Audio (0:24) 🎙️", time: "hace 3h", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCkzFCictmfB9KRRTJ0dqJer-94n91ZOB4smrLNd1UwzSlywyw3rjkfadF2CQfaLJTiaSr-Cwr9bmgd99BpkaNnJGrTN_KmcO5Pba5SQGuXjf_zST5iUvJQQOYEljT9W4521jSdl6Yy0oLqRxyduR5QLMfVN1HZAXI0AttT3XbNwrTFP1zRmMu9owxwOJ6ExK9Z4ZSLXBLRfJbzh2LdE6inClVglbsR_Ng-QgF79w/", unreadCount: 0, isRead: true, isGroup: false, hasAudio: true, hasPhoto: false, verified: false),
        Chat(name: "Lucas Gómez", preview: "Foto adjunta 📸", time: "ayer", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuDvhKE08OicquVxQEeg94QjJlqLU91VLZ2bbSGq4cqvD48NiA4ifJuOInikEjaIoBgcX7DXqNqURF1oo70P-1blT-4SaVxxDg5r7QXd0l7I9Yvh-ct5fDbrArb1TZWPgEWbVrdF_sxQeZUoMEbSZfKlx054sX5Rv5ROkbws0yNcEaFNYyVL_6HBMcaQSQFeXMDMx17T7rYqh8m1lFFjssHq-wt1dHFV8LvFt0669A/", unreadCount: 0, isRead: true, isGroup: false, hasAudio: false, hasPhoto: true, verified: false),
    ]

    var body: some View {
        Group {
            if selectedTab == 0 {
                // Chats
                NavigationStack(path: $path) {
                    ZStack {
                        Color.auraBackground.ignoresSafeArea()

                        ScrollView {
                            VStack(spacing: 0) {
                                // Header fijo (simulado dentro del scroll; en producción sería .safeAreaInset)
                                headerView
                                    .padding(.horizontal, .auraGutter)
                                    .padding(.top, 8)
                                    .padding(.vertical, 5)

                                // Buscador
                                searchField
                                    .padding(.horizontal, .auraGutter)
                                    .padding(.vertical, 5)

                                // Píldoras de filtro
                                filterPills
                                    .padding(.horizontal, .auraGutter)
                                    .padding(.vertical, 5)

                                // Historias activas
                                storiesSection
                                    .padding(.horizontal, .auraGutter)
                                    .padding(.vertical, 5)

                                // Conversaciones
                                conversationsSection
                                    .padding(.horizontal, .auraGutter)

                                // Pie de cifrado
                                encryptionFooter
                                    .padding(.bottom, 100) // espacio para el FAB y tab bar
                            }
                        }

                        // FAB flotante (nueva conversación)
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                composeFAB
                                    .padding(.trailing, 20)
                                    .padding(.bottom, 90)
                            }
                        }
                    }
                    .navigationDestination(for: Chat.self) { chat in
                        ChatConversationView(contact: chat.name, onGoToProfile: {
                            path.append(chat.name)
                        })
                    }
                    .navigationDestination(for: String.self) { name in
                        ProfileView(contact: name)
                    }
                }
            } else if selectedTab == 1 {
                // Contacts (placeholder)
                ContactsView()
            } else {
                // Settings
                SettingsView()
            }
        }
        .overlay(alignment: .bottom) {
            TabBarView(selectedTab: $selectedTab)
        }
        .tint(.auraPrimary)
    }

    // MARK: - Subviews

    private var headerView: some View {
        HStack(spacing: .auraSpaceMD) {
            // Logo + título
            HStack(spacing: .auraSpaceSM) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundStyle(.white)
                    .frame(width: 42, height: 42)
                    .background(Color.auraPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

                VStack(alignment: .leading, spacing: 2) {
                    Text("Aura Chat")
                        .font(.auraLabelLG)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraPrimary)
                        .tracking(0.5)
                        .textCase(.uppercase)
                    Text("Chats")
                        .font(.auraHeadlineMD)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraOnSurface)
                        .lineLimit(1)
                }
            }

            Spacer()

            // Acciones header
            HStack(spacing: .auraSpaceSM) {
                Button(action: {}) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 22, weight: .regular))
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                        .frame(width: 44, height: 44)
                        .background(Color.auraSurfaceContainerHigh)
                        .clipShape(Circle())
                }

                // Avatar del usuario logueado
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.auraSurfaceContainerHigh)
                        .frame(width: 40, height: 40)
                        .overlay {
                            Text("J")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(Color.auraOnSurfaceVariant)
                        }
                    Circle()
                        .fill(Color.auraTertiary)
                        .frame(width: 12, height: 12)
                        .overlay(Circle().stroke(Color.auraSurfaceContainerLowest, lineWidth: 2))
                        .offset(x: 3, y: 3)
                }
            }
        }
    }

    private var searchField: some View {
        HStack(spacing: .auraSpaceSM) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 20))
                .foregroundStyle(Color.auraOutline)
            TextField("Buscar mensajes o personas", text: $searchText)
                .font(.auraBodyMD)
                .foregroundStyle(Color.auraOnSurface)
                .frame(maxWidth: .infinity, alignment: .leading)
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundStyle(Color.auraOutline)
                }
            }
            Button(action: {}) {
                Image(systemName: "mic.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.auraPrimary)
                    .frame(width: 32, height: 32)
                    .background(Color.auraSurfaceContainer)
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color.auraSurfaceContainerLow)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
        )
        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 2)
    }

    private var filterPills: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: .auraSpaceXS) {
                ForEach(Filter.allCases) { filter in
                    FilterPill(
                        title: filter.rawValue,
                        isSelected: selectedFilter == filter,
                        badge: filter == .all ? 5 : nil
                    ) {
                        selectedFilter = filter
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }

    private var storiesSection: some View {
        VStack(alignment: .leading, spacing: .auraSpaceSM) {
            HStack {
                Text("Estados Activos")
                    .font(.auraLabelMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOutline)
                    .tracking(0.5)
                    .textCase(.uppercase)
                Spacer()
                HStack(spacing: .auraSpaceXS) {
                    Circle()
                        .fill(Color.auraTertiary)
                        .frame(width: 8, height: 8)
                        .shadow(color: Color.auraTertiary.opacity(0.5), radius: 4)
                    Text("En directo")
                        .font(.auraLabelSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraPrimary)
                }
            }

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(stories) { story in
                        StoryPill(story: story)
                    }
                }
                .padding(.horizontal, 4)
            }
        }
    }

    private var conversationsSection: some View {
        VStack(alignment: .leading, spacing: .auraSpaceSM) {
            HStack {
                Text("Mensajes Recientes")
                    .font(.auraLabelMD)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOutline)
                    .tracking(0.5)
                    .textCase(.uppercase)
                Spacer()
                Button(action: {}) {
                    Text("Editar")
                        .font(.auraLabelSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraPrimary)
                }
            }

            LazyVStack(spacing: 0) {
                ForEach(chats) { chat in
                    ChatRow(chat: chat)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            path.append(chat)
                        }
                    if chat.id != chats.last?.id {
                        Divider()
                            .padding(.leading, 76)
                    }
                }
            }
        }
    }

    private var encryptionFooter: some View {
        HStack(spacing: .auraSpaceXS) {
            Image(systemName: "lock.fill")
                .font(.system(size: 16))
                .foregroundStyle(Color.auraOutline)
            Text("Cifrado de extremo a extremo de Aura")
                .font(.auraLabelSM)
                .foregroundStyle(Color.auraOutline)
        }
    }

    private var composeFAB: some View {
        Button(action: {}) {
            Image(systemName: "square.and.pencil")
                .font(.system(size: 26, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 56, height: 56)
                .background(Color.auraPrimary)
                .clipShape(Circle())
                .shadow(color: Color.auraPrimary.opacity(0.45), radius: 16, x: 0, y: 8)
                .scaleEffect(1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: true)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Componentes auxiliares

struct FilterPill: View {
    let title: String
    let isSelected: Bool
    let badge: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(title)
                if let badge {
                    Text("\(badge)")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            .font(.auraLabelMD)
            .fontWeight(.medium)
            .foregroundStyle(isSelected ? .white : .auraOnSurfaceVariant)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(isSelected ? Color.auraPrimary : Color.auraSurfaceContainerLow)
            .clipShape(Capsule())
            .shadow(color: isSelected ? Color.black.opacity(0.12) : .clear, radius: 4, x: 0, y: 2)
            .scaleEffect(isSelected ? 1.0 : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
        }
        .buttonStyle(.plain)
    }
}

struct StoryPill: View {
    let story: Story

    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 66, height: 66)
                    .shadow(color: .black.opacity(0.08), radius: 8)

                if story.isOwn {
                    Circle()
                        .stroke(LinearGradient(colors: [.auraPrimary, .auraSecondary], startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                        .frame(width: 66, height: 66)
                }

                Circle()
                    .fill(Color.white)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Group {
                            if story.avatarURL.isEmpty {
                                avatarPlaceholder(for: story.name)
                            } else {
                                AsyncImage(url: URL(string: story.avatarURL)) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    avatarPlaceholder(for: story.name)
                                }
                            }
                        }
                        .clipShape(Circle())
                    }

                // Indicador de activo
                if story.isActive {
                    Circle()
                        .fill(Color.auraTertiary)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: 12, y: 12)
                }

                if story.isOwn {
                    Circle()
                        .fill(Color.auraPrimary)
                        .frame(width: 20, height: 20)
                        .overlay(Image(systemName: "plus").font(.system(size: 12, weight: .bold)).foregroundStyle(.white))
                        .offset(x: 14, y: 14)
                        .shadow(color: Color.black.opacity(0.2), radius: 4)
                }
            }

            Text(story.name)
                .font(.auraLabelSM)
                .fontWeight(.medium)
                .foregroundStyle(story.isActive ? Color.auraOnSurface : Color.auraOnSurfaceVariant)
                .lineLimit(1)
                .frame(width: 66)
                .truncationMode(.middle)
        }
    }

    private func avatarPlaceholder(for name: String) -> some View {
        let initials = name.split(separator: " ").prefix(2).map { String($0.prefix(1)) }.joined().uppercased()
        return ZStack {
            Circle().fill(Color.auraSurfaceContainerHigh)
            Text(initials)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.auraOnSurfaceVariant)
        }
    }
}

struct ChatRow: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: .auraSpaceMD) {
            // Avatar
            ZStack(alignment: .bottomTrailing) {
                if chat.isGroup {
                    // Stacked avatars para grupos
                    ZStack {
                        // Back avatar
                        Circle()
                            .fill(Color.auraSurfaceContainerHigh)
                            .frame(width: 56, height: 56)
                            .shadow(color: .black.opacity(0.08), radius: 4)
                            .overlay {
                                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuDR8zMnwZI0zHrzZXTfeeZydYI2iNSsU7sF9TgRX6sppfXkF2y9AYAZ-rseTkWOKoMG06xH8aQCZHpLf2xCuasX51wWEb87tmuRd9a0XdUT_Coh1m8V4bsfkaPBumBp7IqLDxtUKiAxu2yE9q28Qa0lUCaB-soYz1gIMhEsRoSQed7nqqEeiLSCuetubjIkezIH0FIUWPE1WKJXEFB0T-qmlpcUbMa5zYea456iCA/")) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    avatarPlaceholder(for: "Grupo")
                                }
                            }
                            .clipShape(Circle())
                        // Front avatar
                        Circle()
                            .fill(Color.auraSurfaceContainerHigh)
                            .frame(width: 36, height: 36)
                            .shadow(color: .black.opacity(0.12), radius: 6)
                            .overlay {
                                AsyncImage(url: URL(string: "https://lh3.googleusercontent.com/aida-public/AB6AXuBFyG0wSTBV5YsKEtmIVh_tx7_-pIZdrlVWoCJp1yW_Ih-YsW8xAlABytGgO1UeJJJwmN0_7Wfsrf56CzD3vmfYt7Wr_r6a9y09JJ4ErEovm-2nWyWa_9a7P3HqjtBABE1yTwEX79xog0mrjM_kISSGzsr5OGq0fwIz5FlnQvaAzesbNjxnQm_FWyyVWNR07mpVYVId49fTISfL8PBcMXU4jb3nsqMvrEwXrjj_FQ/")) { image in
                                    image.resizable().aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    avatarPlaceholder(for: "Grupo")
                                }
                            }
                            .clipShape(Circle())
                            .offset(x: 14, y: 14)
                        // Badge verificado
                        if chat.verified {
                            Circle()
                                .fill(Color.auraPrimary)
                                .frame(width: 20, height: 20)
                                .overlay(Image(systemName: "checkmark.seal.fill").font(.system(size: 12, weight: .bold)).foregroundStyle(.white))
                                .offset(x: 14, y: -14)
                        } else {
                            // Badge grupo
                            Circle()
                                .fill(Color.auraSecondary)
                                .frame(width: 18, height: 18)
                                .overlay(Image(systemName: "person.2.fill").font(.system(size: 10, weight: .bold)).foregroundStyle(.white))
                                .offset(x: 14, y: -14)
                        }
                    }
                } else {
                    // Avatar individual
                    Group {
                        if chat.avatarURL.isEmpty {
                            avatarPlaceholder(for: chat.name)
                        } else {
                            AsyncImage(url: URL(string: chat.avatarURL)) { image in
                                image.resizable().aspectRatio(contentMode: .fill)
                            } placeholder: {
                                avatarPlaceholder(for: chat.name)
                            }
                        }
                    }
                    .frame(width: 56, height: 56)
                    .clipShape(Circle())

                    // Estado activo
                    Circle()
                        .fill(Color.auraTertiary)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color.auraSurfaceContainerLowest, lineWidth: 2))
                        .offset(x: 10, y: 10)
                }
            }

            VStack(alignment: .leading, spacing: 2) {
                // Nombre + hora
                HStack(spacing: 6) {
                    Group {
                        if chat.isGroup {
                            HStack(spacing: 4) {
                                Text(chat.name)
                                Image(systemName: "checkmark.seal.fill")
                                    .font(.system(size: 13, weight: .bold))
                            }
                        } else {
                            Text(chat.name)
                        }
                    }
                    .font(.auraHeadlineSM)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
                    .lineLimit(1)

                    Spacer(minLength: 8)

                    Text(chat.time)
                        .font(.auraLabelSM)
                        .fontWeight(.semibold)
                        .foregroundStyle(chat.isRead ? Color.auraOutline : Color.auraPrimary)
                }

                // Preview
                HStack(spacing: 6) {
                    if chat.hasAudio {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 14))
                            .foregroundStyle(Color.auraPrimary)
                        Text("Audio (0:24)")
                            .font(.auraBodyMD)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.auraOnSurface)
                        Spacer(minLength: 4)
                        // Waveform visual
                        HStack(spacing: 2) {
                            ForEach(0..<5) { i in
                                RoundedRectangle(cornerRadius: 1)
                                    .fill(Color.auraPrimary.opacity(0.5 + Double(i) * 0.15))
                                    .frame(width: 2, height: CGFloat(4 + i * 3))
                            }
                        }
                        .frame(height: 12)
                    } else if chat.hasPhoto {
                        Image(systemName: "photo")
                            .font(.system(size: 16))
                            .foregroundStyle(Color.auraOnSurfaceVariant)
                        Text(chat.preview)
                            .font(.auraBodyMD)
                            .foregroundStyle(Color.auraOnSurfaceVariant)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    } else if chat.isGroup {
                        Text(chat.preview)
                            .font(.auraBodyMD)
                            .fontWeight(.medium)
                            .foregroundStyle(Color.auraOnSurface)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color.auraPrimary)
                            Text(chat.preview)
                                .font(.auraBodyMD)
                                .foregroundStyle(Color.auraOnSurface)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }

                    // Estado de lectura o badge no leídos
                    if chat.unreadCount > 0 {
                        Text("\(chat.unreadCount)")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 5)
                            .padding(.vertical, 2)
                            .background(Color.auraPrimary)
                            .clipShape(Capsule())
                            .shadow(color: Color.auraPrimary.opacity(0.35), radius: 4, x: 0, y: 2)
                    } else if chat.isRead && !chat.hasAudio && !chat.hasPhoto {
                        Text("Leído")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.auraOutline)
                    }
                }
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 2)
        .background(Color.auraSurfaceContainerLowest.opacity(0.9))
        .contentShape(Rectangle())
    }

    private func avatarPlaceholder(for name: String) -> some View {
        let initials = name.split(separator: " ").prefix(2).map { String($0.prefix(1)) }.joined().uppercased()
        return ZStack {
            Circle().fill(Color.auraSurfaceContainerHigh)
            Text(initials)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(Color.auraOnSurfaceVariant)
        }
    }
}

// MARK: - Tab Bar inferior

private struct TabBarView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack(spacing: 0) {
            TabBarItem(
                icon: "message.fill",
                title: "Chats",
                isSelected: selectedTab == 0,
                badge: 3
            ) {
                selectedTab = 0
            }

            TabBarItem(
                icon: "person.2.fill",
                title: "Contacts",
                isSelected: selectedTab == 1,
                badge: nil
            ) {
                selectedTab = 1
            }

            TabBarItem(
                icon: "gearshape.fill",
                title: "Settings",
                isSelected: selectedTab == 2,
                badge: nil
            ) {
                selectedTab = 2
            }
        }
        .frame(height: 56)
        .background(Color.auraSurfaceContainerLowest)
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(Color.black.opacity(0.04)),
            alignment: .top
        )
        .safeAreaPadding(.bottom)
    }
}

private struct TabBarItem: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let badge: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(isSelected ? Color.auraPrimary : Color.auraOnSurfaceVariant)
                Text(title)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundStyle(isSelected ? Color.auraPrimary : Color.auraOnSurfaceVariant)
            }
            .frame(maxWidth: .infinity)
            .overlay(
                Group {
                    if let badge {
                        Text("\(badge)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 4)
                            .padding(.vertical, 2)
                            .background(Color.auraPrimary)
                            .clipShape(Capsule())
                            .offset(x: -50, y: -9.5)
                    }
                },
                alignment: .topTrailing
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Contacts (placeholder)

struct ContactsView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Color.auraBackground.ignoresSafeArea()

                VStack(spacing: .auraSpaceLG) {
                    Image(systemName: "person.2.fill")
                        .font(.system(size: 64, weight: .light))
                        .foregroundStyle(Color.auraOnSurfaceVariant.opacity(0.3))

                    Text("Contactos")
                        .font(.auraHeadlineMD)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.auraOnSurface)

                    Text("Tus contactos aparecerán aquí.")
                        .font(.auraBodyMD)
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                        .multilineTextAlignment(.center)
                }
            }
            .navigationTitle("Contacts")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tint(.auraPrimary)
    }
}

#Preview {
    ChatListView()
}
