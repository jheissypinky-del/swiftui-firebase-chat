//
//  ChatModels.swift
//  ChatDemo
//
//  Modelos compartidos de chat (Message, Chat, Story) usados por
//  ChatListView y ChatConversationView a través de ChatViewModel.
//

import Foundation
import SwiftUI

// MARK: - Message

enum MessageStatus: Equatable {
    case sending, sent, read
}

enum MessageType {
    case text, audio, photo
}

struct Message: Identifiable, Equatable {
    let id = UUID()
    let text: String
    let isOutgoing: Bool
    let time: String
    var status: MessageStatus  // solo para salientes (mutable para no recrear el mensaje y cambiar su id)
    let type: MessageType
    let reaction: String?
    let isGroup: Bool
    let senderName: String?    // solo para grupos

    // La igualdad compara también el estado: si solo comparara el id,
    // SwiftUI omitiría el re-render de la burbuja al pasar de .sending a .sent.
    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id && lhs.status == rhs.status
    }
}

// MARK: - Chat

struct Chat: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var preview: String
    var time: String
    var avatarURL: String
    var unreadCount: Int
    var isRead: Bool
    var isGroup: Bool
    var hasAudio: Bool
    var hasPhoto: Bool
    var verified: Bool
    /// Indica si el último mensaje de la conversación lo envió el usuario.
    /// Determina si la fila muestra el check de enviado o el estado entrante.
    var lastMessageIsOutgoing: Bool = true

    // El hash se mantiene en el id para que el chat sea estable dentro del
    // NavigationPath, pero la igualdad compara también el contenido visible:
    // si solo comparara el id, SwiftUI omitiría el re-render de la fila y el
    // preview de la lista nunca se actualizaría al enviar un mensaje.
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
            && lhs.preview == rhs.preview
            && lhs.time == rhs.time
            && lhs.unreadCount == rhs.unreadCount
            && lhs.isRead == rhs.isRead
            && lhs.lastMessageIsOutgoing == rhs.lastMessageIsOutgoing
    }
}

// MARK: - Story

struct Story: Identifiable {
    let id = UUID()
    let name: String
    let avatarURL: String
    let isOwn: Bool
    let isActive: Bool
}
