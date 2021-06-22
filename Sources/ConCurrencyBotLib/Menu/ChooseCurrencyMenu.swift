//
//  ChooseCurrencyMenu.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 11.06.2021.
//

import Foundation
import Telegrammer

func chooseCurrencyMenu() -> InlineKeyboardMarkup {
    let buttons = [[
        InlineKeyboardButton(text: "USD", callbackData: "usd"),
        InlineKeyboardButton(text: "EUR", callbackData: "eur"),
        InlineKeyboardButton(text: "GBP", callbackData: "gbp"),
        InlineKeyboardButton(text: "JPY", callbackData: "jpy"),
        InlineKeyboardButton(text: "CNY", callbackData: "cny"),
    ]]
    return InlineKeyboardMarkup(inlineKeyboard: buttons)
}
