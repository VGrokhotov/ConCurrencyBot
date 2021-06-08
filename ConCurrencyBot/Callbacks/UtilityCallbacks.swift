//
//  UtilityCallbacks.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 07.06.2021.
//

import Foundation
import Telegrammer

///Callback for handler, that sends Hello message for new chat member
func newMember(_ update: Update) throws {
    
    guard
        let message = update.message,
        let newUsers = message.newChatMembers
    else { return }
    
    for user in newUsers {
        guard !user.isBot else { continue }
        
        var name = user.firstName
        if let username = user.username {
            name = "@\(username)"
        }
        
        let params = Bot.SendMessageParams(
            chatId: .chat(message.chat.id),
            text: """
            🎊🎉👋😃
            Hey \(name)!
            I'm ConCurrencyBot 😎, made by VGrokhotov
            """)
        try bot.sendMessage(params: params)
    }
}
