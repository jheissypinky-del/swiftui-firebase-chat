//
//  ChatConversationView.swift
//  ChatDemo
//
//  Aura Chat — pantalla de conversación individual.
//  Pantalla "Conversación con Sofía" traducida del diseño de Figma.
//

import SwiftUI

// MARK: - Model

struct Message: Identifiable {
    let id = UUID()
    let text: String
    let isOutgoing: Bool
    let time: String
    let status: MessageStatus  // solo para salientes
    let type: MessageType
    let reaction: String?
    let isGroup: Bool
    let senderName: String?    // solo para grupos
}

enum MessageStatus {
    case sending, sent, read
}

enum MessageType {
    case text, audio, photo
}

// MARK: - View

struct ChatConversationView: View {
    let contact: String
    @Binding var path: NavigationPath

    @State private var messageText = ""
    @State private var scrollPosition = ScrollPosition(edge: .bottom)
    @FocusState private var isInputFocused: Bool

    // Mensajes de ejemplo coherentes con el diseño de referencia
    @State private var messages: [Message] = [
        Message(text: "¡Hola! ¿Listo para la reunión de diseño?", isOutgoing: false, time: "10:12", status: .read, type: .text, reaction: nil, isGroup: false, senderName: nil),
        Message(text: "Sí, ya estoy terminando los assets.", isOutgoing: true, time: "10:13", status: .sent, type: .text, reaction: nil, isGroup: false, senderName: nil),
        Message(text: "Perfecto, te espero en el café a las 5pm ☕", isOutgoing: false, time: "10:14", status: .read, type: .text, reaction: nil, isGroup: false, senderName: nil),
        Message(text: "Audio (0:24) 🎙️", isOutgoing: false, time: "10:16", status: .read, type: .audio, reaction: nil, isGroup: false, senderName: nil),
        Message(text: "Ya subí los assets actualizados", isOutgoing: false, time: "10:20", status: .read, type: .text, reaction: nil, isGroup: true, senderName: "Elena"),
        Message(text: "¡Quedó increíble la propuesta de diseño! 🚀", isOutgoing: true, time: "10:22", status: .read, type: .text, reaction: nil, isGroup: false, senderName: nil),
        Message(text: "Foto adjunta 📸", isOutgoing: false, time: "10:25", status: .read, type: .photo, reaction: nil, isGroup: false, senderName: nil),
    ]

    var body: some View {
        ZStack {
            Color.auraBackground.ignoresSafeArea()

            VStack(spacing: 0) {
                // Header de conversación
                ConversationHeader(
                    contact: contact,
                    onGoBack: { path.removeLast() },
                    onGoToProfile: { path.append(contact) }
                )

                // Lista de mensajes con input dock anclado al área segura inferior
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(messages) { message in
                                MessageBubble(message: message)
                                    .id(message.id)
                            }
                            // Espacio inferior para que el último mensaje no quede detrás del input dock
                            Color.clear.frame(height: 120)
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                    }
                    .scrollPosition($scrollPosition)
                    .onChange(of: messages.count) {
                        withAnimation(.easeOut(duration: 0.25)) {
                            scrollPosition.scrollTo(edge: .bottom)
                        }
                    }
                    .onAppear {
                        withAnimation(.easeOut(duration: 0.25)) {
                            scrollPosition.scrollTo(edge: .bottom)
                        }
                    }
                    // Input dock en el área segura inferior (encima del tab bar)
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        InputDock(
                            text: $messageText,
                            isFocused: $isInputFocused,
                            onSend: { sendMessage() }
                        )
                    }
                }
            }
            .frame(maxHeight: .infinity)
        }
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .navigationBar)
        .tint(.auraPrimary)
    }

    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let outgoing = Message(
            text: messageText.trimmingCharacters(in: .whitespacesAndNewlines),
            isOutgoing: true,
            time: "Ahora",
            status: .sending,
            type: .text,
            reaction: nil,
            isGroup: false,
            senderName: nil
        )
        messages.append(outgoing)
        messageText = ""
    }
}

// MARK: - Header

private struct ConversationHeader: View {
    let contact: String
    let onGoBack: () -> Void
    let onGoToProfile: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onGoBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.auraOnSurface)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }

            Button(action: onGoToProfile) {
                ZStack(alignment: .bottomTrailing) {
                    Circle()
                        .fill(Color.auraSurfaceContainerHigh)
                        .frame(width: 56, height: 56)
                        .overlay {
                            Text(contact.prefix(1).uppercased())
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(Color.auraOnSurfaceVariant)
                        }
                    Circle()
                        .fill(Color.auraTertiary)
                        .frame(width: 14, height: 14)
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        .offset(x: 12, y: 12)
                }
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(contact)
                    .font(.auraHeadlineSM)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.auraOnSurface)
                HStack(spacing: 4) {
                    Circle().fill(Color.auraTertiary).frame(width: 6, height: 6)
                    Text("Activo ahora")
                        .font(.auraLabelSM)
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                }
            }

            Spacer()

            Button(action: {}) {
                Image(systemName: "video")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
            Button(action: {}) {
                Image(systemName: "phone")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.auraOnSurfaceVariant)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.auraGlassBar)
        .overlay(
            Rectangle().frame(height: 0.5).foregroundStyle(Color.black.opacity(0.08)),
            alignment: .bottom
        )
    }
}

// MARK: - Burbuja de mensaje

private struct MessageBubble: View {
    let message: Message

    private var alignment: HorizontalAlignment {
        message.isOutgoing ? .trailing : .leading
    }

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isOutgoing {
                Spacer(minLength: 56)
            } else {
                // Avatar del remitente (entrante)
                Circle()
                    .fill(Color.auraSurfaceContainerHigh)
                    .frame(width: 32, height: 32)
                    .overlay {
                        Text(message.senderName?.prefix(1).uppercased() ?? "?")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundStyle(Color.auraOnSurfaceVariant)
                    }
                Spacer(minLength: 8)
            }

            VStack(alignment: alignment, spacing: 4) {
                if message.isGroup, let senderName = message.senderName, !message.isOutgoing {
                    Text(senderName)
                        .font(.auraLabelSM)
                        .foregroundStyle(Color.auraPrimary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }

                HStack(spacing: 4) {
                    bubbleContent
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(bubbleBackground)
                .clipShape(bubbleShape)
                .shadow(color: message.isOutgoing ? Color.auraPrimary.opacity(0.2) : .black.opacity(0.04), radius: message.isOutgoing ? 10 : 4, x: 0, y: message.isOutgoing ? 4 : 1)

                // Estado / hora
                HStack(spacing: 4) {
                    if message.isOutgoing {
                        statusIcon
                        Text(message.time)
                    } else {
                        Text(message.time)
                    }
                }
                .font(.auraLabelSM)
                .foregroundStyle(Color.auraOnSurfaceVariant)
                .frame(maxWidth: .infinity, alignment: message.isOutgoing ? .trailing : .leading)
            }
            .frame(maxWidth: .infinity, alignment: alignment == .trailing ? .trailing : .leading)

            if message.isOutgoing {
                Spacer(minLength: 8)
            } else {
                Spacer(minLength: 56)
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
    }

    @ViewBuilder
    private var bubbleContent: some View {
        switch message.type {
        case .text:
            Text(message.text)
                .font(.auraBodyLG)
                .foregroundStyle(message.isOutgoing ? Color.white : Color.auraOnSurface)
                .fixedSize(horizontal: false, vertical: true)
        case .audio:
            HStack(spacing: 8) {
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(message.isOutgoing ? Color.white.opacity(0.25) : Color.auraSurfaceContainerHigh)
                    .frame(width: 36, height: 36)
                    .overlay(Image(systemName: "mic.fill").font(.system(size: 14)).foregroundStyle(message.isOutgoing ? .white : Color.auraPrimary))
                VStack(alignment: .leading, spacing: 2) {
                    Text("Audio (0:24)")
                        .font(.auraBodyMD)
                        .foregroundStyle(message.isOutgoing ? Color.white : Color.auraOnSurface)
                        .bold()
                    ProgressView().scaleEffect(0.7)
                }
                Spacer(minLength: 8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        case .photo:
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.auraSurfaceContainerHigh)
                .frame(width: 120, height: 120)
                .overlay(Image(systemName: "photo").font(.system(size: 32)).foregroundStyle(Color.auraOutline))
        }
    }

    private var bubbleBackground: some View {
        if message.isOutgoing {
            return AnyView(Color.auraPrimary)
        } else {
            return AnyView(
                ZStack {
                    Color.auraIncomingBubble
                    RoundedRectangle(cornerRadius: message.type == .photo ? 12 : .auraRadiusBubble, style: .continuous)
                        .stroke(Color.black.opacity(0.03), lineWidth: 0.5)
                }
            )
        }
    }

    private var bubbleShape: some Shape {
        // Píldora con el borde contiguo colapsado para mensajes consecutivos del mismo remitente
        RoundedRectangle(cornerRadius: message.type == .photo ? 12 : .auraRadiusBubble, style: .continuous)
    }

    @ViewBuilder
    private var statusIcon: some View {
        switch message.status {
        case .sending:
            Image(systemName: "clock").font(.system(size: 11, weight: .bold))
        case .sent:
            Image(systemName: "checkmark").font(.system(size: 11, weight: .bold))
        case .read:
            Image(systemName: "checkmark.circle.fill").font(.system(size: 12, weight: .bold)).foregroundStyle(Color.auraPrimary)
        }
    }
}

// MARK: - Dock de entrada

private struct InputDock: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    var onSend: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            // Separador superior del dock
            Rectangle()
                .frame(height: 0.5)
                .foregroundStyle(Color.black.opacity(0.08))
                .frame(maxWidth: .infinity)

            HStack(spacing: 10) {
                // Adjuntos
                Button(action: {}) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundStyle(Color.auraOnSurfaceVariant)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }

                // Campo de texto (píldora interior)
                ZStack(alignment: .trailing) {
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.auraSurfaceContainerLow)
                        .overlay(
                            RoundedRectangle(cornerRadius: 22, style: .continuous)
                                .stroke(Color.black.opacity(0.06), lineWidth: 0.5)
                        )
                    TextField("Escribe un mensaje…", text: $text)
                        .font(.auraBodyLG)
                        .foregroundStyle(Color.auraOnSurface)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .focused(isFocused)
                }
                .frame(minHeight: 44, maxHeight: 50)

                // Enviar / voz
                if text.isEmpty {
                    Button(action: {}) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 19, weight: .medium))
                            .foregroundStyle(Color.auraPrimary)
                            .frame(width: 44, height: 44)
                            .contentShape(Rectangle())
                    }
                } else {
                    Button(action: onSend) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.white)
                            .frame(width: 44, height: 44)
                            .background(Color.auraPrimary)
                            .clipShape(Circle())
                            .shadow(color: Color.auraPrimary.opacity(0.4), radius: 8, x: 0, y: 4)
                            .scaleEffect(1.0)
                            .animation(.spring(response: 0.25, dampingFraction: 0.75), value: !text.isEmpty)
                    }
                    .buttonStyle(.plain)
                    .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(Color.auraGlassBar)
        }
    }
}

#Preview {
    ChatConversationView(contact: "Sofía Valdés", path: .constant(NavigationPath()))
}
