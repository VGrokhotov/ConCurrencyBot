//
//  HelpCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 08.06.2021.
//

import Foundation
import Telegrammer

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
