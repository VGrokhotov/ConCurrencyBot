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
func localBanks(_ update: Update, _ context: BotContext?) throws {
    guard let message = update.message else { return }
    
    LocalBanksNetworkService.shared.getCurrency(currency: "usd", location: "sankt-peterburg", amount: 5) { (data, currency, location) in
        
        let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        
        let offers =
            try! doc.select("div[class='exchange-calculator-rates table-flex__row-group']")
            .compactMap({ element -> BankOffer? in
                let bank = try element.select("a[class='font-bold']").first()?.text()
                var buy = try element.select("i[class='icon-font icon-calculator-16 icon-font--size_small calculator-hover-icon']")[0].parent()?.text()
                if let buyStr = buy {
                    let index = buyStr.index(buyStr.startIndex, offsetBy: 7)
                    buy = String(buyStr.prefix(upTo: index))
                }
                let sell = try element.select("i[class='icon-font icon-calculator-16 icon-font--size_small calculator-hover-icon']")[1].parent()?.text()
                return BankOffer(bank: bank, buy: buy, sell: sell)
            })
        
        var result = "Offers for exchanging " + currency.uppercased() + " in " + location + ":\n"
        
        offers.forEach { offer in
            result.append("\(offer.bank):\nsale for \(offer.sell)\nbuy with \(offer.buy)\n\n")
        }
        
        let params = Bot.SendMessageParams(
            chatId: .chat(message.chat.id),
            text: result
        )
        
        let _ = try? bot.sendMessage(params: params)
    } errCompletion: { error in
        let params = Bot.SendMessageParams(
            chatId: .chat(message.chat.id),
            text: "Something bad has happend"
        )
        let _ = try? bot.sendMessage(params: params)
    }

}

struct BankOffer {
    let bank: String
    let buy: String
    let sell: String
    
    init?(bank: String?, buy: String?, sell: String?) {
        if let bank = bank {
            self.bank = bank
        } else {
            return nil
        }
        if let buy = buy {
            self.buy = buy
        } else {
            return nil
        }
        if let sell = sell {
            self.sell = sell
        } else {
            return nil
        }
    }
}
