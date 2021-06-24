//
//  TextCallback.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 08.06.2021.
//

import Foundation
import Telegrammer


///Callback for Message handler, which send echo message to user
public func echoResponse(_ update: Update, _ context: BotContext?) throws {
    guard
        let message = update.message,
        let user = message.from
    else { return }
    
    if let _ = Storage.shared.userTextMode[user.id] {
        guard
            let command = Storage.shared.userChosenCommand[user.id]
        else {
            let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Something bad has happend")
            try Storage.shared.bot.sendMessage(params: params)
            return
        }
        
        switch command {
        case .local:
            
            guard
                let currency = Storage.shared.userChosenCurrency[user.id],
                let originalLocation = message.text
            else {
                let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Something bad has happend")
                try Storage.shared.bot.sendMessage(params: params)
                return
            }
            
            let locationForSite = transliterate(nonLatin: originalLocation)
            
            LocalBanksNetworkService().getCurrency(currency: currency.rawValue, location: locationForSite) { data in
        
                if let offers = localParse(data: data, currency: currency, originalLocation: originalLocation) {
                    
                    var result = ""
                    var markup: ReplyMarkup?
                    
                    if offers.count > 5 {
                        Storage.shared.userOffers[user.id] = (offers, 5, currency, originalLocation)
                        let cutOffers = Array(offers[0..<5])
                        result = generateResult(offers: cutOffers, currency: currency, originalLocation: originalLocation)
                        markup = .inlineKeyboardMarkup(nextAndPreviousOffersMenu(shown: 5, amount: offers.count))
                    } else {
                        result = generateResult(offers: offers, currency: currency, originalLocation: originalLocation)
                    }
                    
                    
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: result,
                        replyMarkup: markup
                    )
                    
                    deleteAllCaches(user.id)
            
                    let _ = try? Storage.shared.bot.sendMessage(params: params)
                } else {
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: "No offers for \(currency.rawValue.uppercased()) in \(originalLocation)"
                    )
                    deleteAllCaches(user.id)
                    let _ = try? Storage.shared.bot.sendMessage(params: params)
                }
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get offers now. Try again or write /stop command"
                )
                let _ = try? Storage.shared.bot.sendMessage(params: params)
            }
            
        case .localBest:
            
            guard
                let currency = Storage.shared.userChosenCurrency[user.id],
                let originalLocation = message.text
            else {
                let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Something bad has happend")
                try Storage.shared.bot.sendMessage(params: params)
                return
            }
            
            let locationForSite = transliterate(nonLatin: originalLocation)
            
            LocalBanksNetworkService().getCurrency(currency: currency.rawValue, location: locationForSite) { data in
                
                if let result = localBestParse(data: data, currency: currency, originalLocation: originalLocation) {
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: result
                    )
                    
                    deleteAllCaches(user.id)
                    
                    let _ = try? Storage.shared.bot.sendMessage(params: params)
                    
                } else {
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: "No offers for \(currency.rawValue.uppercased()) in \(originalLocation)"
                    )
                    let _ = try? Storage.shared.bot.sendMessage(params: params)
                }
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get best offer now. Try again or write /stop command"
                )
                let _ = try? Storage.shared.bot.sendMessage(params: params)
            }
            
        case .cbDate:
            
            guard
                let date = message.text,
                let regex = try? NSRegularExpression(pattern: "^[0-9]{2}/[0-9]{2}/[0-9]{4}$"),
                let _ = regex.firstMatch(in: date, options: [], range: NSRange(location: 0, length: date.count))
            else {
                let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Wrong date, try another one or write /stop command")
                try Storage.shared.bot.sendMessage(params: params)
                return
            }
            
            CBNetworkService().getCurrency(date: date) { data in
                
                if let result = cbDateParce(date: date, data: data) {
                    Storage.shared.userTextMode.removeValue(forKey: user.id)
                    Storage.shared.userChosenCommand.removeValue(forKey: user.id)
                    
                    let params = Bot.SendMessageParams(
                        chatId: .chat(message.chat.id),
                        text: result
                    )
                    let _ = try? Storage.shared.bot.sendMessage(params: params)
                } else {
                    let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "Cannot get currencies for this date. Try another one or write /stop command")
                    let _ = try? Storage.shared.bot.sendMessage(params: params)
                }
                
                
            } errCompletion: { error in
                let params = Bot.SendMessageParams(
                    chatId: .chat(message.chat.id),
                    text: "Cannot get currencies now. Try again or write /stop command"
                )
                let _ = try? Storage.shared.bot.sendMessage(params: params)
            }
        }
    } else {
        if message.chat.type == .private {
            let params = Bot.SendMessageParams(chatId: .chat(message.chat.id), text: "No matching commands")
            try Storage.shared.bot.sendMessage(params: params)
        }
    }
}

func transliterate(nonLatin: String) -> String {
    
    let dictionary: [String.Element: String] = [
        "-": "-",
        " ": "-",
        "а": "a",
        "б": "b",
        "в": "v",
        "г": "g",
        "д": "d",
        "е": "e",
        "ё": "",
        "ж": "zh",
        "з": "a",
        "и": "i",
        "й": "y",
        "к": "k",
        "л": "l",
        "м": "m",
        "н": "n",
        "о": "o",
        "п": "p",
        "р": "r",
        "с": "s",
        "т": "t",
        "у": "u",
        "ф": "f",
        "х": "h",
        "ц": "tss",
        "ч": "ch",
        "ш": "ssh",
        "щ": "sch",
        "ъ": "",
        "ы": "yi",
        "ь": "~",
        "э": "je",
        "ю": "yu",
        "я": "ya"
    ]
    
    var result = ""
    
    for char in nonLatin.lowercased() {
        result.append(dictionary[char] ?? String(char))
    }
    
    return result
}

func generateResult(offers: [BankOffer], currency: Currency, originalLocation: String) -> String {
        var result = "Offers for exchanging " + currency.rawValue.uppercased() + " in " + originalLocation + ":\n"
    
        offers.forEach { offer in
            result.append("\(offer.bank):\nsale for \(offer.sell)\nbuy with \(offer.buy)\n\n")
        }
    
        return result
}
