//
//  BankOffer.swift
//  
//
//  Created by Vladislav Grokhotov on 24.06.2021.
//

import Foundation

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
