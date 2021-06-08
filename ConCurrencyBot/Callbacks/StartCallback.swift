//
//  StartCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 08.06.2021.
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
