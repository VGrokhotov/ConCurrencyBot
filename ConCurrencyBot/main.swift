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

do {
    ///Dispatcher - handle all incoming messages
    let dispatcher = Dispatcher(bot: bot)
    
    ///Creating and adding handlers for commands, text, etc
    let startCommandHandler = CommandHandler(commands: ["/start"], callback: start)
    let helpCommandHandler = CommandHandler(commands: ["/help"], callback: help)
    let cbAllCommandHandler = CommandHandler(commands: ["/cb"], callback: cbAll)
    let localBanksCommandHandler = CommandHandler(commands: ["/local"], callback: localBanks)
    let echoHandler = MessageHandler(filters: Filters.text, callback: echoResponse)
    let newMemberHandler = NewMemberHandler(callback: newMember)
    dispatcher.add(handler: startCommandHandler)
    dispatcher.add(handler: helpCommandHandler)
    dispatcher.add(handler: cbAllCommandHandler)
    dispatcher.add(handler: localBanksCommandHandler)
    dispatcher.add(handler: echoHandler)
    dispatcher.add(handler: newMemberHandler)
    
    ///Longpolling updates
    _ = try Updater(bot: bot, dispatcher: dispatcher).startLongpolling().wait()

} catch {
    print(error.localizedDescription)
}
