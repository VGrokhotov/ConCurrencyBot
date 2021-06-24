//
//  Parsers.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 19.06.2021.
//

import Foundation
import SwiftSoup
import SwiftyXMLParser

public func localParse(data: Data, currency: Currency, originalLocation: String) -> [BankOffer]? {
    let doc = try! SwiftSoup.parse(String(data: data, encoding: .utf8)!)

    guard
        let offers = try? doc.select("div[class='exchange-calculator-rates table-flex__row-group']")
            .compactMap({ element -> BankOffer? in
                let bank = try element.select("a[class='font-bold']").first()?.text()
                var buy = try element.select("i[class='icon-font icon-calculator-16 icon-font--size_small calculator-hover-icon']")[0].parent()?.text()
                if let buyStr = buy {
                    let index = buyStr.index(buyStr.startIndex, offsetBy: 7)
                    buy = String(buyStr.prefix(upTo: index))
                }
                let sell = try element.select("i[class='icon-font icon-calculator-16 icon-font--size_small calculator-hover-icon']")[1].parent()?.text()
                return BankOffer(bank: bank, buy: buy, sell: sell)
            }),
        offers.count > 0
    else { return nil }
    
    return offers
}

public func localBestParse(data: Data, currency: Currency, originalLocation: String) -> String? {
    
    do {
        let doc = try SwiftSoup.parse(String(data: data, encoding: .utf8)!)
        
        guard
            let offerEllement = try doc.select("tr[class='currency-table__bordered-row']").first()
        else { return nil }
        
        let firstContainer = try offerEllement.select("div[class='currency-table__rate__text']")
        let secondContainer = try offerEllement.select("div[class='currency-table__large-text']")
        
        guard
            firstContainer.count >= 3,
            secondContainer.count >= 3
        else {
            return nil
        }
        
        let bankBuy = try firstContainer[1].text()
        let bankSell = try firstContainer[2].text()
        let buy = try secondContainer[1].text()
        let sell = try secondContainer[2].text()
        
        var result = "Best offer for exchanging " + currency.rawValue.uppercased() + " in " + originalLocation + ":\n"
        
        result.append("\(bankSell): sale for \(sell) ₽\n\(bankBuy): buy with \(buy) ₽\n")
        
        return result
    } catch {
        return nil
    }
}

public func cbDateParce(date: String, data: Data) -> String? {
    
    var resultArray = [DateCurrency]()
    
    let currencies = ["USD", "EUR", "GBP", "JPY", "CNY"]
    
    let xml = XML.parse(data)
    for element in xml["ValCurs", "Valute"] {
        if let currency = element["CharCode"].text, currencies.contains(currency) {
            guard
                let nominal = element["Nominal"].text,
                let value =  element["Value"].text
            else {
                return nil
            }
            resultArray.append(DateCurrency(currency: currency, nominal: nominal, value: value))
        }
    }
    
    if resultArray.count == 0 {
        return nil
    }
    
    var resultString = "CB currencies rate for \(date):\n"
    
    resultArray.forEach { element in
        resultString += element.nominal + " " + element.currency + " for " + element.value + " ₽\n"
    }
    
    return resultString
}
