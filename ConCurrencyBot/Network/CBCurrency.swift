//
//  CBCurrency.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 09.06.2021.
//

import Foundation

struct CBCurrency: Decodable {
    
    let values: Currencys
    
    enum CodingKeys: String, CodingKey {
        case values = "rates"
    }
}

struct Currencys: Decodable {
    
    let dollar: Double
    let euro: Double
    let pound: Double
    let yen: Double
    let yuan: Double
    
    enum CodingKeys: String, CodingKey {
        case dollar = "USD"
        case euro = "EUR"
        case pound = "GBP"
        case yen = "JPY"
        case yuan = "CNY"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let rubleToDollar = try container.decode(Double.self, forKey: .dollar)
        let rubleToEuro = try container.decode(Double.self, forKey: .euro)
        let rubleToPound = try container.decode(Double.self, forKey: .pound)
        let rubleToYen = try container.decode(Double.self, forKey: .yen)
        let rubleToYuan = try container.decode(Double.self, forKey: .yuan)
        
        dollar = 1 / rubleToDollar
        euro = 1 / rubleToEuro
        pound = 1 / rubleToPound
        yen = 1 / rubleToYen
        yuan = 1 / rubleToYuan
    }
}
