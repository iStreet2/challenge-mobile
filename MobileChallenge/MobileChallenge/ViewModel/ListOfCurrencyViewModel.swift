//
//  APIViewModel.swift
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 18/11/24.
//

import Foundation

class ListOfCurrencyViewModel: ListOfCurrencyViewModelProtocol {
    
    var loading = false
    
    func getListOfCurrency(completion: @escaping (Result<[String:String], APIError>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Banking-iOS/mock-interview/main/api/list.json") else {
            completion(.failure(.invalidURL))
            return
        }
        
        self.loading = true
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(.failure(.requestError))
                return
            }
            guard let httpResponde = response as? HTTPURLResponse, httpResponde.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            if let data = data {
                do {
                    var listOfCurrency: [String: String] = [:]
                    let decodedResult = try JSONDecoder().decode(Currency.self, from: data)
                    for currency in decodedResult.currencies {
                        listOfCurrency[currency.key] = currency.value
                    }
                    print("pegou os dados certinho mano!")
                    completion(.success(listOfCurrency))
                } catch {
                    print("Error decoding: \(error.localizedDescription)")
                    completion(.failure(.invalidData))
                }
            }
        }.resume()
    }
    
}


enum APIError: Error {
    case requestError
    case invalidURL
    case invalidResponse
    case invalidData
}
