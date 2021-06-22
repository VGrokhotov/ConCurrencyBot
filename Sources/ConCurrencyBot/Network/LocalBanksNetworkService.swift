//
//  LocalBanksNetworkService.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 09.06.2021.
//

import Foundation

class LocalBanksNetworkService {
    
    let urlBase = "https://www.banki.ru/products/currency/cash/"
    let backslash = "/"
    
    func getCurrency(currency: String, location: String, completion: @escaping (Data) -> (), errCompletion: @escaping (String) -> ()) {
        
        guard let url = URL(string: urlBase + currency + backslash + location + backslash) else {
            errCompletion("Cannot get currency rate")
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { (data, response, error) in
            if let error = error {
                errCompletion(error.localizedDescription)
            } else if let httpResponse = response as? HTTPURLResponse {
                switch httpResponse.statusCode {
                case 200...226:
                    guard let data = data else {
                        errCompletion("Something wrong with API query")
                        return
                    }
                    completion(data)
                default:
                    errCompletion("Something wrong with API query")
                }
            }
        }
        task.resume()
    }
    
}
