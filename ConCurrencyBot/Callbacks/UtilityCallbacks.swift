//
//  UtilityCallbacks.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 07.06.2021.
//

import Foundation
import Telegrammer

///Callback for Command handler, which send start message
func start(_ update: Update, _ context: BotContext?) throws {
    guard
        let message = update.message,
        let user = message.from
    else { return }
    
    var name = user.firstName
    if let username = user.username {
        name = "@\(username)"
    }
    
    let params = Bot.SendMessageParams(
        chatId: .chat(message.chat.id),
        text:
            """
            Hey \(name)!
            I'm ConCurrencyBot 😎, made by VGrokhotov!
            To see my abilities send /help to me.
            """
    )
    try bot.sendMessage(params: params)
}

///Callback for Command handler, which send help message
func help(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message else { return }
    
    let params = Bot.SendMessageParams(
        chatId: .chat(message.chat.id),
        text:
            """
            Sorry, nothing here yet 😣😣😣
            """
    )
    try bot.sendMessage(params: params)
}

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
