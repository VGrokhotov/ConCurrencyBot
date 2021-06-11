//
//  CBNetworkService.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 09.06.2021.
//

import Foundation

class CBNetworkService: NetworkService {
    
    let dailyURL = URL(string: "https://www.cbr-xml-daily.ru/daily_json.js")!
    let latestURL = URL(string: "https://www.cbr-xml-daily.ru/latest.js")!
    
    func getCurrency(completion: @escaping (CBCurrency) -> (), errCompletion: @escaping (String) -> ()) {
        let task = URLSession.shared.dataTask(with: URLRequest(url: latestURL)) { (data, response, error) in
            if let error = error {
                self.failed(message: error.localizedDescription, errCompletion: errCompletion)
            } else if let httpResponse = response as? HTTPURLResponse {
                self.completionHandler(httpResponse.statusCode, data, completion, errCompletion)
            }
        }
        task.resume()
    }
    
}
