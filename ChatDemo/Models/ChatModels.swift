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

enum MessageStatus {
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
    let status: MessageStatus  // solo para salientes
    let type: MessageType
    let reaction: String?
    let isGroup: Bool
    let senderName: String?    // solo para grupos

    static func == (lhs: Message, rhs: Message) -> Bool {
        lhs.id == rhs.id
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

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Chat, rhs: Chat) -> Bool {
        lhs.id == rhs.id
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
