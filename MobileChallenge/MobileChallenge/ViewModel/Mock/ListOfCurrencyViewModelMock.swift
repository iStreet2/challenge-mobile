//
//  APIViewModel.swift
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 18/11/24.
//

import Foundation

class ListOfCurrencyViewModelMock: ListOfCurrencyViewModelProtocol {
    
    var loading = false
    
    func getListOfCurrency(completion: @escaping (Result<[String : String], APIError>) -> Void) {
        completion(.success(["Helo":"My Friend"]))
    }
}
