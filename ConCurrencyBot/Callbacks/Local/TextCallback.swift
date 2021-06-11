//
//  TextCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 08.06.2021.
//

import Foundation
import Telegrammer
import SwiftSoup

///Callback for Message handler, which send echo message to user
func echoResponse(_ update: Update, _ context: BotContext?) throws {
    guard
        let message = update.message,
        let user = message.from
    else { return }
    
    if let _ = userTextMode[user.id] {
        guard
            let currency = userChosenCurrency[user.id],
            let originalLocation = message.text,
            let command = userChosenCommand[user.id]
        else {
            let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Something has happend")
            try bot.sendMessage(params: params)
            return
        }
        
        let locationForSite = transliterate(nonLatin: originalLocation)
        
        switch command {
        case .local:
            LocalBanksNetworkService().getCurrency(currency: currency.rawValue, location: locationForSite) { data in
        
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
        
                var result = "Offers for exchanging " + currency.rawValue.uppercased() + " in " + originalLocation + ":\n"
        
                offers.forEach { offer in
                    result.append("\(offer.bank):\nsale for \(offer.sell)\nbuy with \(offer.buy)\n\n")
                }
        
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: result
                )
                
                userTextMode.removeValue(forKey: user.id)
                userChosenCommand.removeValue(forKey: user.id)
                userChosenCurrency.removeValue(forKey: user.id)
        
                let _ = try? bot.sendMessage(params: params)
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get offers now"
                )
                let _ = try? bot.sendMessage(params: params)
            }
        case .localBest:
            LocalBanksNetworkService().getCurrency(currency: currency.rawValue, location: locationForSite) { data in
                
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
                
                var result = "Best offer for exchanging " + currency.rawValue.uppercased() + " in " + originalLocation + ":\n"
                
                result.append("\(bankSell): sale for \(sell) ₽\n\(bankBuy): buy with \(buy) ₽\n")
                
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: result
                )
                
                userTextMode.removeValue(forKey: user.id)
                userChosenCommand.removeValue(forKey: user.id)
                userChosenCurrency.removeValue(forKey: user.id)
                
                let _ = try? bot.sendMessage(params: params)
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get best offer now"
                )
                let _ = try? bot.sendMessage(params: params)
            }
        }
        
        
    } else {
        if message.chat.type == .private {
            let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "No matching commands")
            try bot.sendMessage(params: params)
        }
    }
}

func transliterate(nonLatin: String) -> String {
    return nonLatin
        .applyingTransform(.toLatin, reverse: false)?
        .applyingTransform(.stripDiacritics, reverse: false)?
        .lowercased()
        .replacingOccurrences(of: " ", with: "-") ?? nonLatin
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