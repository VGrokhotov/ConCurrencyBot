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
        let data = query.data
    else { return }
    
    if let currency = Currency(rawValue: data) {
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
    } else if let switcher = Switcher(rawValue: data) {
        guard let data = Storage.shared.userOffers[query.from.id] else {
            let params = Bot.SendMessageParams(
                chatId: .chat(message.chat.id),
                text: "Cannot show another offers, restart /local command"
            )
            let _ = try? Storage.shared.bot.sendMessage(params: params)
            return
        }
        
        let offers = data.0
        let shown = data.1
        let currency = data.2
        let originalLocation = data.3
        
        var result = ""
        var markup: InlineKeyboardMarkup?
        
        switch switcher {
        case .next:
            let newShown = min(shown + 5, offers.count)
            Storage.shared.userOffers[query.from.id]?.1 = newShown
            result = generateResult(offers: Array(offers[shown..<newShown]), currency: currency, originalLocation: originalLocation)
            markup = nextAndPreviousOffersMenu(shown: newShown, amount: offers.count)
        case .prev:
            var newShown = 0
            if shown%5 == 0 {
                newShown = shown - 5
            } else {
                newShown = offers.count/5 * 5
            }
            Storage.shared.userOffers[query.from.id]?.1 = newShown
            result = generateResult(offers: Array(offers[newShown-5..<newShown]), currency: currency, originalLocation: originalLocation)
            markup = nextAndPreviousOffersMenu(shown: newShown, amount: offers.count)
        }
        try Storage.shared.bot.editMessageText(params:
            Bot.EditMessageTextParams(
                chatId: .chat(message.chat.id),
                messageId: message.messageId,
                text: result,
                replyMarkup: markup
            )
        )
    }
    
    
}
