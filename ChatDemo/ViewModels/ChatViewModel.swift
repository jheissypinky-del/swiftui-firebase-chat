//
//  ChatViewModel.swift
//  ChatDemo
//
//  ViewModel compartido que gestiona chats y mensajes entre
//  ChatListView y ChatConversationView. Simula la recepción de
//  mensajes entrantes tras enviar uno saliente.
//

import Foundation
import SwiftUI

@MainActor
class ChatViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var messagesByContact: [String: [Message]] = [:]

    init() {
        setupInitialData()
    }

    // MARK: - Setup inicial

    private func setupInitialData() {
        chats = [
            Chat(
                name: "Sofía Valdés",
                preview: "¡Quedó increíble la propuesta de diseño! 🚀",
                time: "hace 2m",
                avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuBNi8WG3_CxO2qcgGltfRK1zypr5YtOBHThZo_yRQNjs4dAjmICx_IhtVa2Oufn6XiXXhLIHWDoaTLqY5-S9nPQ0vW_ZqvN-Hu6FNDkK9YryqER79mFj65Fj9bohrB_8Ly0DfGOUoX68cAFvGEoLdGHuTHeDDYc2XO51tBK1TQTbVn_pKJDk82fa2gQW57sNoYzOWGrt8zVfTYL6XcTFx4OqYY7ScrxZTR1Lpv9dQ/",
                unreadCount: 2, isRead: true, isGroup: false, hasAudio: false, hasPhoto: false, verified: false
            ),
            Chat(
                name: "Mateo Morales",
                preview: "Nos vemos en el café a las 5pm",
                time: "hace 15m",
                avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCGOjHR39WgzN8lW5GCfTsqDiOBKZ8NG7iFlrN4ePOgKW2OJ8iATKEhYH20vKEROpvg7YCeeINUUI_kE33JaDbyEw8cwvVPgTEzGLtV43dlyhQlQYQcjePwzRwmo8jrPnK6eNlireHF8orDhV3ujhMDHq-i5nT3BZQ9Pv7OOcyDmqNylb-zcZPpCVBSUO4Yvik4xDHkedlqNFByKqZJdw_nwvim5-6rF_uJ8YUW2Q/",
                unreadCount: 0, isRead: true, isGroup: false, hasAudio: false, hasPhoto: false, verified: false
            ),
            Chat(
                name: "Equipo Creativo Aura",
                preview: "Ya subí los assets actualizados",
                time: "hace 1h",
                avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuBFyG0wSTBV5YsKEtmIVh_tx7_-pIZdrlVWoCJp1yW_Ih-YsW8xAlABytGgO1UeJJJwmN0_7Wfsrf56CzD3vmfYt7Wr_r6a9y09JJ4ErEovm-2nWyWa_9a7P3HqjtBABE1yTwEX79xog0mrjM_kISSGzsr5OGq0fwIz5FlnQvaAzesbNjxnQm_FWyyVWNR07mpVYVId49fTISfL8PBcMXU4jb3nsqMvrEwXrjj_FQ/",
                unreadCount: 0, isRead: true, isGroup: true, hasAudio: false, hasPhoto: false, verified: true
            ),
            Chat(
                name: "Camila Ríos",
                preview: "Audio (0:24) 🎙️",
                time: "hace 3h",
                avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCkzFCictmfB9KRRTJ0dqJer-94n91ZOB4smrLNd1UwzSlywyw3rjkfadF2CQfaLJTiaSr-Cwr9bmgd99BpkaNnJGrTN_KmcO5Pba5SQGuXjf_zST5iUvJQQOYEljT9W4521jSdl6Yy0oLqRxyduR5QLMfVN1HZAXI0AttT3XbNwrTFP1zRmMu9owxwOJ6ExK9Z4ZSLXBLRfJbzh2LdE6inClVglbsR_Ng-QgF79w/",
                unreadCount: 0, isRead: true, isGroup: false, hasAudio: true, hasPhoto: false, verified: false
            ),
            Chat(
                name: "Lucas Gómez",
                preview: "Foto adjunta 📸",
                time: "ayer",
                avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuDvhKE08OicquVxQEeg94QjJlqLU91VLZ2bbSGq4cqvD48NiA4ifJuOInikEjaIoBgcX7DXqNqURF1oo70P-1blT-4SaVxxDg5r7QXd0l7I9Yvh-ct5fDbrArb1TZWPgEWbVrdF_sxQeZUoMEbSZfKlx054sX5Rv5ROkbws0yNcEaFNYyVL_6HBMcaQSQFeXMDMx17T7rYqh8m1lFFjssHq-wt1dHFV8LvFt0669A/",
                unreadCount: 0, isRead: true, isGroup: false, hasAudio: false, hasPhoto: true, verified: false
            ),
        ]

        messagesByContact = [
            "Sofía Valdés": [
                Message(text: "¡Hola! ¿Listo para la reunión de diseño?", isOutgoing: false, time: "10:12", status: .read, type: .text, reaction: nil, isGroup: false, senderName: nil),
                Message(text: "Sí, ya estoy terminando los assets.", isOutgoing: true, time: "10:13", status: .sent, type: .text, reaction: nil, isGroup: false, senderName: nil),
                Message(text: "Perfecto, te espero en el café a las 5pm ☕", isOutgoing: false, time: "10:14", status: .read, type: .text, reaction: nil, isGroup: false, senderName: nil),
                Message(text: "Audio (0:24) 🎙️", isOutgoing: false, time: "10:16", status: .read, type: .audio, reaction: nil, isGroup: false, senderName: nil),
                Message(text: "Ya subí los assets actualizados", isOutgoing: false, time: "10:20", status: .read, type: .text, reaction: nil, isGroup: true, senderName: "Elena"),
                Message(text: "¡Quedó increíble la propuesta de diseño! 🚀", isOutgoing: true, time: "10:22", status: .read, type: .text, reaction: nil, isGroup: false, senderName: nil),
                Message(text: "Foto adjunta 📸", isOutgoing: false, time: "10:25", status: .read, type: .photo, reaction: nil, isGroup: false, senderName: nil),
            ],
        ]
    }

    // MARK: - Mensajes

    func messages(for contact: String) -> [Message] {
        messagesByContact[contact] ?? []
    }

    /// Envía un mensaje saliente y simula una respuesta entrante tras un breve retraso.
    func sendMessage(to contact: String, text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // 1. Mensaje saliente
        let outgoing = Message(
            text: trimmed,
            isOutgoing: true,
            time: "Ahora",
            status: .sending,
            type: .text,
            reaction: nil,
            isGroup: false,
            senderName: nil
        )

        var messages = messages(for: contact)
        messages.append(outgoing)
        messagesByContact[contact] = messages

        // 2. Actualizar el chat en la lista (preview + hora)
        updateChatPreview(contact: contact, preview: trimmed, time: "Ahora")

        // 3. Marcar mensaje saliente como enviado tras un instante
        Task {
            try? await Task.sleep(nanoseconds: 800_000_000) // 0.8 s
            if var last = messagesByContact[contact]?.last,
               last.id == outgoing.id {
                var updated = messagesByContact[contact] ?? []
                if let idx = updated.firstIndex(where: { $0.id == outgoing.id }) {
                    updated[idx] = Message(
                        text: outgoing.text,
                        isOutgoing: true,
                        time: outgoing.time,
                        status: .sent,
                        type: .text,
                        reaction: nil,
                        isGroup: false,
                        senderName: nil
                    )
                    messagesByContact[contact] = updated
                }
            }

            // 4. Simular mensaje entrante de la otra persona
            try? await Task.sleep(nanoseconds: 1_200_000_000) // 1.2 s más
            let incoming = Message(
                text: "Recibido: \(trimmed)",
                isOutgoing: false,
                time: "Ahora",
                status: .read,
                type: .text,
                reaction: nil,
                isGroup: false,
                senderName: contact
            )
            var incomingMessages = messagesByContact[contact] ?? []
            incomingMessages.append(incoming)
            messagesByContact[contact] = incomingMessages

            // Actualizar preview con la respuesta entrante
            updateChatPreview(contact: contact, preview: incoming.text, time: "Ahora")
        }
    }

    private func updateChatPreview(contact: String, preview: String, time: String) {
        guard let index = chats.firstIndex(where: { $0.name == contact }) else { return }
        var chat = chats[index]
        chat.preview = preview
        chat.time = time
        chat.isRead = true
        chat.unreadCount = 0
        chats[index] = chat
    }

    // MARK: - Stories

    var stories: [Story] {
        [
            Story(name: "Tu historia", avatarURL: "", isOwn: true, isActive: false),
            Story(name: "Sofía", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCu2pv__qunYlm9v4DkxRLN1mrT3rWhgaUuhg4ecb-BS_NAMFyH9BiY_C--V949uALGgMSGoS0Kk3AI7qPmaKDj2ahIzAwqvtQiZe-eck9iTP7ubMHsb8NJO1YIW1-2W0KvLTD4LxKOY3qhrNOUswYqOZ9KBLKeequLFhat-0NICjDFQlCsFH7oDbnVUGdSYoCBYiPRczp7ysvVE3GGDujcYzTXdCMejU5yl5ge3Q/", isOwn: false, isActive: true),
            Story(name: "Mateo", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuAexFAdFJSgsK9tSu9B1veSM0d9IOtoNBgNpbfaqDGlq_7DI_BUZ_fAAy9_l3jwSCwM4B71hu7lfRauvRmwOUCqjVnBW-Yguj_PFfMZzmi1dpcd0gX5x-1mdQH6veBn2IwOPrcwNgn-UGORN-Rwzk25GHvFU4uhDuckcecuaEYyrquWaSIpdNuc4KjWwweFvtvdEU_o1jqDyJBIG74PLtaQcjLPk1tJTELu5TP0lw/", isOwn: false, isActive: true),
            Story(name: "Camila", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuChD8JhZzOg54RzfV9r2z6LhPU6ZeYfDyU2hLKX4iCaRWdeaRi39Bs3HynbKHZCwkj1qe776FLJj_IPVWoLP4WRcmb5-vyleKt23IQ0_TvU5s9m-oHg47vdlMZB9ICzi4kXZPzfuI6ZVGpOZXqudeM5p11IR76LHQIs0LxQjXWG3lVQLpaQ9r54CZoAw4kS8VJi0_sseeaO4cVGFCQbcn_fICsE2tMGSYji3N3dYg/", isOwn: false, isActive: false),
            Story(name: "Lucas", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuCCMCdJouCVPZwQStdZ4Anx53O7h2VgpDrYI0EU72Fo8_-X6FpL6HEks2kWXCQz9BNO-_oJKT4riXz0n18Vr4HXQzMIhnFJ_3qsEM7HZFSOBgTcrhmajkTscZIOBfRhtOfuyk8Vv6QGqKvpJKxBTkBMagc5ADEi0FMb7ooLZbJlXDfyVUk93WTO-1ej9QahhgWiUGCrnMaE6W9UG2UR1EkBr4zZr-4avjlRYjGh9w/", isOwn: false, isActive: false),
            Story(name: "Elena", avatarURL: "https://lh3.googleusercontent.com/aida-public/AB6AXuBpNPCvUuC7p4821z9rnPiKGlm5AMMrZZTxkFX6T3nwzmdyxTi3n9kAFeGr_ihKCSzKI57e6d3LV_zRFNaGAvIXblsx-1kYSDMjAApWQYd5awSko5rE0dcxcZXdE7dkgRd1cXNWffR4auqKsnt-3sH3M5WgUV88z137OlWVdQ5oSUUJJAvmI_4EV8P6KJlk7CHmNj0KRUyTF3x1LgzsmAZc-fKetT79DeAD9kj1Dg/", isOwn: false, isActive: false),
        ]
    }
}
