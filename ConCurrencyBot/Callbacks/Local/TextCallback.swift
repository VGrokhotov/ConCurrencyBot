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
    guard
        let message = update.message,
        let user = message.from
    else { return }
    
    if let _ = userTextMode[user.id] {
        guard
            let command = userChosenCommand[user.id]
        else {
            let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Something bad has happend")
            try bot.sendMessage(params: params)
            return
        }
        
        switch command {
        case .local:
            
            guard
                let currency = userChosenCurrency[user.id],
                let originalLocation = message.text
            else {
                let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Something bad has happend")
                try bot.sendMessage(params: params)
                return
            }
            
            let locationForSite = transliterate(nonLatin: originalLocation)
            
            LocalBanksNetworkService().getCurrency(currency: currency.rawValue, location: locationForSite) { data in
        
                if let result = localParse(data: data, currency: currency, originalLocation: originalLocation) {
                    
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: result
                    )
                    
                    deleteAllCaches(user.id)
            
                    let _ = try? bot.sendMessage(params: params)
                } else {
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: "No offers for \(currency.rawValue.uppercased()) in \(originalLocation)"
                    )
                    deleteAllCaches(user.id)
                    let _ = try? bot.sendMessage(params: params)
                }
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get offers now. Try again or write /stop command"
                )
                let _ = try? bot.sendMessage(params: params)
            }
            
        case .localBest:
            
            guard
                let currency = userChosenCurrency[user.id],
                let originalLocation = message.text
            else {
                let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Something bad has happend")
                try bot.sendMessage(params: params)
                return
            }
            
            let locationForSite = transliterate(nonLatin: originalLocation)
            
            LocalBanksNetworkService().getCurrency(currency: currency.rawValue, location: locationForSite) { data in
                
                if let result = localBestParse(data: data, currency: currency, originalLocation: originalLocation) {
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: result
                    )
                    
                    userTextMode.removeValue(forKey: user.id)
                    userChosenCommand.removeValue(forKey: user.id)
                    userChosenCurrency.removeValue(forKey: user.id)
                    
                    let _ = try? bot.sendMessage(params: params)
                    
                } else {
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: "No offers for \(currency.rawValue.uppercased()) in \(originalLocation)"
                    )
                    let _ = try? bot.sendMessage(params: params)
                }
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get best offer now. Try again or write /stop command"
                )
                let _ = try? bot.sendMessage(params: params)
            }
            
        case .cbDate:
            
            guard
                let date = message.text,
                let regex = try? NSRegularExpression(pattern: "^[0-9]{2}/[0-9]{2}/[0-9]{4}$"),
                let _ = regex.firstMatch(in: date, options: [], range: NSRange(location: 0, length: date.count))
            else {
                let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Wrong date, try another one or write /stop command")
                try bot.sendMessage(params: params)
                return
            }
            
            CBNetworkService().getCurrency(date: date) { data in
                
                if let result = cbDateParce(date: date, data: data) {
                    userTextMode.removeValue(forKey: user.id)
                    userChosenCommand.removeValue(forKey: user.id)
                    
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: result
                    )
                    let _ = try? bot.sendMessage(params: params)
                } else {
                    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Cannot get currencies for this date. Try another one or write /stop command")
                    let _ = try? bot.sendMessage(params: params)
                }
                
                
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get currencies now. Try again or write /stop command"
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
