//
//  NewMemberHandler.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 07.06.2021.
//

import Foundation
import Telegrammer

public class NewMemberHandler: Handler {
    
    public typealias NewMemberCallback = (_ update: Update) throws -> Void
    
    public var name: String
    let filters = StatusUpdateFilters.newChatMembers
    var callback: NewMemberCallback
    
    public init(callback: @escaping NewMemberCallback, name: String = String(describing: NewMemberHandler.self)) {
        self.callback = callback
        self.name = name
    }
    
    public func check(update: Update) -> Bool {
        guard
            let message = update.message,
            filters.check(message)
        else { return false }
        return true
    }
    
    public func handle(update: Update, dispatcher: Dispatcher) {
        do {
            try callback(update)
        } catch {
            print(error.localizedDescription)
        }
    }
}
