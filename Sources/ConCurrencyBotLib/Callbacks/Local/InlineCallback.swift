//
//  InlineCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 11.06.2021.
//

import Foundation
import Telegrammer

public func inline(_ update: Update, _ context: BotContext?) throws {
    guard let query = update.callbackQuery,
        let message = query.message,
        let data = query.data,
        let currency = Currency(rawValue: data)
    else { return }
    
    Storage.shared.userChosenCurrency[query.from.id] = currency
    Storage.shared.userTextMode[query.from.id] = true
    
    try Storage.shared.bot.editMessageText(params:
        Bot.EditMessageTextParams(
            chatId: .chat(message.chat.id),
            messageId: message.messageId,
            text: "Choose the currency you want to exchange\n\nYou have chosen \(currency.rawValue.uppercased())"
        )
    )
    
    let params = Bot.SendMessageParams(
        chatId: .chat(message.chat.id),
        text: "Enter the city you want to check"
    )
    let _ = try? Storage.shared.bot.sendMessage(params: params)
}
