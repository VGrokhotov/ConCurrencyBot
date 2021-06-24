//
//  NextAndPreviousOffersMenu.swift
//  
//
//  Created by Vladislav Grokhotov on 24.06.2021.
//

import Foundation
import Telegrammer

func nextAndPreviousOffersMenu(shown: Int, amount: Int) -> InlineKeyboardMarkup {
    var buttons = [InlineKeyboardButton]()
    if shown > 5 {
        buttons.append(InlineKeyboardButton(text: "<", callbackData: "prev"))
    }
    if shown < amount {
        buttons.append(InlineKeyboardButton(text: ">", callbackData: "next"))
    }
    return InlineKeyboardMarkup(inlineKeyboard: [buttons])
}
