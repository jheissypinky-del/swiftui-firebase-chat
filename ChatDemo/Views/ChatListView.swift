//
//  ChatListView.swift
//  ChatDemo
//
//  Aura Chat — pantalla principal: lista de conversaciones.
//  Traducida del código HTML de referencia (aura_chat_mensajes).
//

import SwiftUI
import FirebaseAuth

// MARK: - View

struct ChatListView: View {
    @EnvironmentObject private var authViewModel: AuthenticationViewModel
    @EnvironmentObject private var chatViewModel: ChatViewModel
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


    var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack(path: $path) {
                ZStack {
                    Color.auraBackground.ignoresSafeArea()

                    ScrollView {
                        VStack(spacing: 0) {
                            headerView
                                .padding(.horizontal, .auraGutter)
                                .padding(.top, 8)
                                .padding(.vertical, 5)

                            searchField
                                .padding(.horizontal, .auraGutter)
                                .padding(.vertical, 5)

                            filterPills
                                .padding(.horizontal, .auraGutter)
                                .padding(.vertical, 5)

                            storiesSection
                                .padding(.horizontal, .auraGutter)
                                .padding(.vertical, 5)

                            conversationsSection
                                .padding(.horizontal, .auraGutter)

                            encryptionFooter
                                .padding(.bottom, 100)
                        }
                    }

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
                    ChatConversationView(contact: chat.name, path: $path)
                }
                .navigationDestination(for: String.self) { name in
                    ProfileView(contact: name, path: $path)
                }
            }
            .tabItem {
                Image(systemName: "message.fill")
                Text("Chats")
            }
            .badge(3)
            .tag(0)

            ContactsView()
                .tabItem {
                    Image(systemName: "person.2.fill")
                    Text("Contacts")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
                .tag(2)
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
                    if let email = authViewModel.userSession?.email {
                        Text(email)
                            .font(.auraLabelSM)
                            .foregroundStyle(Color.auraOnSurfaceVariant)
                            .lineLimit(1)
                    }
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
                    ForEach(chatViewModel.stories) { story in
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
                ForEach(chatViewModel.chats, id: \.id) { chat in
                    ChatRow(chat: chat)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            path.append(chat)
                        }
                    if chat.id != chatViewModel.chats.last?.id {
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
        .environmentObject(AuthenticationViewModel())
        .environmentObject(ChatViewModel())
}
