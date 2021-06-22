//
//  NetworkService.swift
//  ConCurrencyBot
//
//  Created by Vladislav Grokhotov on 09.06.2021.
//

import Foundation

class NetworkService {
    
    internal let badMessage = "Something has happend"
    
    func badURL(_ errCompletion: @escaping (String) -> ()) {
        print("Wrong URL")
        errCompletion(self.badMessage)
    }
    
    func failed(message: String, errCompletion: @escaping (String) -> ()) {
        errCompletion(message)
    }
    
    func success<T: Decodable>(with data: Data?, status: Int, completion: @escaping (T) -> ()) {
        if let data = data {
            let object = try? JSONDecoder().decode(T.self, from: data)
            if let object = object {
                completion(object)
            } else {
                completion(status as! T)
            }
        }
    }
    
    func badCode(data: Data?, errCompletion: @escaping (String) -> ()) {
        if let data = data {
            let message = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            print(message?["reason"] ?? "cannot read JSON")
            failed(message: message?["reason"] as? String ?? self.badMessage , errCompletion: errCompletion)
        }
    }
    
    func completionHandler<T: Decodable>(
        _ status: Int,
        _ data: Data?,
        _ completion: @escaping ((T) -> ()),
        _ errCompletion: @escaping (String) -> ()
    ) {
        print(status)
        switch status {
        case 200...226:
            self.success(with: data, status: status, completion: completion)
        default:
            self.badCode(data: data, errCompletion: errCompletion)
        }
    }
}
