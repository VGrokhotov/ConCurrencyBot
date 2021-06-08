//
//  TextCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 08.06.2021.
//

import Foundation
import Telegrammer

///Callback for Message handler, which send echo message to user
func echoResponse(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message else { return }
    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "I cannot understand text for a while")
    try bot.sendMessage(params: params)
}
