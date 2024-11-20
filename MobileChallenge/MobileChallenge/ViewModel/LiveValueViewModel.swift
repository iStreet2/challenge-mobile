//
//  LiveValueViewModel.swift
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 18/11/24.
//

import Foundation

class LiveValueViewModel: LiveValueViewModelProtocol {
    
    var loading: Bool = false
    
    func getLiveValues(completion: @escaping (Result<[String:Double], APIError>) -> Void) {
        guard let url = URL(string: "https://raw.githubusercontent.com/Banking-iOS/mock-interview/main/api/live.json") else {
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
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            if let data = data {
                do {
                    var listOfLiveValues: [String: Double] = [:]
                    let decodedResult = try JSONDecoder().decode(LiveValue.self, from: data)
                    for quote in decodedResult.quotes {
                        listOfLiveValues[quote.key] = quote.value
                    }
                    completion(.success(listOfLiveValues))
                } catch {
                    print("Error decoding: \(error.localizedDescription)")
                    completion(.failure(.invalidData))
                }
            } else {
                completion(.failure(.invalidData))
                return
            }
        }.resume()
    }
    
    func calculate(originalValue: Double, multiplier: Double) -> String {
        return String(format: "%.2f", ceil((originalValue)*(multiplier)*100)/100)
    }
    
}
