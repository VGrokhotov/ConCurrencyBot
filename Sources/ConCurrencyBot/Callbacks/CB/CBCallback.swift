//
//  CBCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 09.06.2021.
//

import Foundation
import Telegrammer

///Callback for Command handler, which send CB currensy
func cbAll(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message else { return }
    
    CBNetworkService().getCurrency { cbCurrency in
        let params = Bot.SendMessageParams(
            chatId: .chat(message.chat.id),
            text:
                """
                Central Bank Ruble exchange rate:
                Dollar - \(round(cbCurrency.values.dollar * 100) / 100) ₽
                Euro   - \(round(cbCurrency.values.euro * 100) / 100) ₽
                Pound  - \(round(cbCurrency.values.pound * 100) / 100) ₽
                Yen    - \(round(cbCurrency.values.yen * 100) / 100) ₽
                Yuan   - \(round(cbCurrency.values.yuan * 100) / 100) ₽
                """
        )
        let _ = try? bot.sendMessage(params: params)
    } errCompletion: { error in
        let params = Bot.SendMessageParams(
            chatId: .chat(message.chat.id),
            text: "Cannot get CB exchange rate now"
        )
        let _ = try? bot.sendMessage(params: params)
    }
}
