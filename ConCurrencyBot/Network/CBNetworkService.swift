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
    let dateURL = "http://www.cbr.ru/scripts/XML_daily.asp?date_req="
    
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
    
    func getCurrency(date: String, completion: @escaping (Data) -> (), errCompletion: @escaping (String) -> ()) {
        
        guard
            let url = URL(string: dateURL + date)
        else {
            errCompletion("Wrong date, try another one")
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
