//
//  LocalBankBestCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 11.06.2021.
//

import Foundation
import Telegrammer
import SwiftSoup

///Callback for Command handler, which send CB currensy
func localBanksBest(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message else { return }
    
    LocalBanksNetworkService.shared.getCurrency(currency: "usd", location: "sankt-peterburg", amount: 5) { (data, currency, location) in
        
        let doc = try? SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        
        let offerEllement = try? doc?.select("tr[class='currency-table__bordered-row']").first()
        
        let bankBuy = try? offerEllement?.select("div[class='currency-table__rate__text']")[1].text()
        let bankSell = try? offerEllement?.select("div[class='currency-table__rate__text']")[2].text()
        let buy = try? offerEllement?.select("div[class='currency-table__large-text']")[1].text()
        let sell = try? offerEllement?.select("div[class='currency-table__large-text']")[2].text()
        
        guard
            let bankBuy = bankBuy, let bankSell = bankSell, let buy = buy, let sell = sell
        else {
            let params = Bot.SendMessageParams(
                chatId: .chat(message.chat.id),
                text: "Cannot get best offer now"
            )
            let _ = try? bot.sendMessage(params: params)
            return
        }
        
        var result = "Best offer for exchanging " + currency.uppercased() + " in " + location + ":\n"
        
        result.append("\(bankSell): sale for \(sell) ₽\n\(bankBuy): buy with \(buy) ₽\n")
        
        let params = Bot.SendMessageParams(
            chatId: .chat(message.chat.id),
            text: result
        )
        
        let _ = try? bot.sendMessage(params: params)
    } errCompletion: { error in
        let params = Bot.SendMessageParams(
            chatId: .chat(message.chat.id),
            text: "Cannot get best offer now"
        )
        let _ = try? bot.sendMessage(params: params)
    }

}
