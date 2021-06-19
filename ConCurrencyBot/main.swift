//
//  main.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 07.06.2021.
//

import Foundation
import Telegrammer

guard let token = Enviroment.get("TOKEN") else {
    print("TOKEN variable wasn't found in enviroment variables")
    exit(1)
}

var settings = Bot.Settings(token: token)
let bot = try! Bot(settings: settings)

var userChosenCurrency: [Int64: Currency] = [:]
var userChosenCommand: [Int64: Command] = [:]
var userTextMode: [Int64: Bool] = [:]

do {
    ///Dispatcher - handle all incoming messages
    let dispatcher = Dispatcher(bot: bot)
    
    ///Creating and adding handlers for commands, text, etc
    let startCommandHandler = CommandHandler(commands: ["/start", "/start@VGCurrencyBot"], callback: start)
    let helpCommandHandler = CommandHandler(commands: ["/help", "/help@VGCurrencyBot"], callback: help)
    let cbAllCommandHandler = CommandHandler(commands: ["/cb", "/cb@VGCurrencyBot"], callback: cbAll)
    let dateRateHandler = CommandHandler(commands: ["/cbdate", "/cbdate@VGCurrencyBot"], callback: dateRate)
    let localBanksCommandHandler = CommandHandler(commands: ["/local", "/local@VGCurrencyBot"], callback: localBanks)
    let localBanksBestCommandHandler = CommandHandler(commands: ["/localbest", "/localbest@VGCurrencyBot"], callback: localBanksBest)
    let echoHandler = MessageHandler(filters: Filters.text, callback: echoResponse)
    let newMemberHandler = NewMemberHandler(callback: newMember)
    let inlineHandler = CallbackQueryHandler(pattern: "\\w+", callback: inline)
    dispatcher.add(handler: startCommandHandler)
    dispatcher.add(handler: helpCommandHandler)
    dispatcher.add(handler: cbAllCommandHandler)
    dispatcher.add(handler: dateRateHandler)
    dispatcher.add(handler: localBanksCommandHandler)
    dispatcher.add(handler: localBanksBestCommandHandler)
    dispatcher.add(handler: echoHandler)
    dispatcher.add(handler: newMemberHandler)
    dispatcher.add(handler: inlineHandler)
    
    ///Longpolling updates
    _ = try Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()

} catch {
    print(error.localizedDescription)
}
