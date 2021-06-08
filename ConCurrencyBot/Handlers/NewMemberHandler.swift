//
//  NewMemberHandler.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 07.06.2021.
//

import Foundation
import Telegrammer

class NewMemberHandler: Handler {
    
    typealias NewMemberCallback = (_ update: Update) throws -> Void
    
    var name: String
    let filters = StatusUpdateFilters.newChatMembers
    var callback: NewMemberCallback
    
    init(callback: @escaping NewMemberCallback, name: String = String(describing: NewMemberHandler.self)) {
        self.callback = callback
        self.name = name
    }
    
    func check(update: Update) -> Bool {
        guard
            let message = update.message,
            filters.check(message)
        else { return false }
        return true
    }
    
    func handle(update: Update, dispatcher: Dispatcher) {
        do {
            try callback(update)
        } catch {
            print(error.localizedDescription)
        }
    }
}
