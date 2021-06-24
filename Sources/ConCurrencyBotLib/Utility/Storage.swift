//
//  Storage.swift
//  
//
//  Created by Vladislav Grokhotov on 22.06.2021.
//

import Telegrammer
import Foundation

public class Storage {
    public static let shared = Storage()
    
    init() {
        guard let token = Enviroment.get("TOKEN") else {
            print("TOKEN variable wasn't found in enviroment variables")
            exit(1)
        }

        let settings = Bot.Settings(token: token)
        bot = try! Bot(settings: settings)
    }
    
    public var userChosenCurrency: [Int64: Currency] = [:]
    public var userChosenCommand: [Int64: Command] = [:]
    public var userTextMode: [Int64: Bool] = [:]
    public let bot: Bot
}
