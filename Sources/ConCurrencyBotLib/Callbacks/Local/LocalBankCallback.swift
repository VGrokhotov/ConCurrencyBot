//
//  LocalBankCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 11.06.2021.
//

import Foundation
import Telegrammer
import SwiftSoup

///Callback for Command handler, which send CB currensy
public func localBanks(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message, let user = message.from  else { return }
    
    Storage.shared.userChosenCommand[user.id] = .local
    
    let markup = chooseCurrencyMenu()
    
    let params = Bot.SendMessageParams(
        chatId: .chat(message.chat.id),
        text: "Choose the currency you want to exchange",
        replyMarkup: .inlineKeyboardMarkup(markup)
    )
    let _ = try? Storage.shared.bot.sendMessage(params: params)
}
