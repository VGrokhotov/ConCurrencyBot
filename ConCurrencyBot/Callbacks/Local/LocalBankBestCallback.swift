//
//  LocalBankBestCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 11.06.2021.
//

import Foundation
import Telegrammer

///Callback for Command handler, which send CB currensy
func localBanksBest(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message, let user = message.from  else { return }
    
    userChosenCommand[user.id] = .localBest
    
    let markup = chooseCurrencyMenu()
    
    let params = Bot.SendMessageParams(
        chatId: .chat(message.chat.id),
        text: "Choose the currency you want to exchange",
        replyMarkup: .inlineKeyboardMarkup(markup)
    )
    let _ = try? bot.sendMessage(params: params)
}
