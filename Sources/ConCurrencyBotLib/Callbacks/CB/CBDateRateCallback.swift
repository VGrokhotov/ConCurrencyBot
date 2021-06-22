//
//  CBDateRateCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 12.06.2021.
//

import Foundation
import Telegrammer

///Callback for Command handler, which send CB currensy
public func dateRate(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message, let user = message.from  else { return }
    
    Storage.shared.userChosenCommand[user.id] = .cbDate
    Storage.shared.userTextMode[user.id] = true
    
    let params = Bot.SendMessageParams(
        chatId: .chat(message.chat.id),
        text: "Write the date you want to check in \"dd/mm/yyyy\" format"
    )
    let _ = try? Storage.shared.bot.sendMessage(params: params)
}
