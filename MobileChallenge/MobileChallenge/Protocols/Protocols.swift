//
//  Protocols.swift
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 18/11/24.
//

import Foundation

protocol ListOfCurrencyViewModelProtocol: AnyObject {
    var loading: Bool { get set }
    func getListOfCurrency(completion: @escaping (Result<[String:String], APIError>) -> Void)
}

protocol LiveValueViewModelProtocol: AnyObject {
    var loading: Bool { get set }
    func getLiveValues(completion: @escaping (Result<[String:Double], APIError>) -> Void)
    func calculate(originalValue: Double, multiplier: Double) -> String
}

protocol CurrencyListingDelegateProtocol: AnyObject {
    func updateSelectedCurrencyFrom(selectedFromCurrency: String)
    func updateSelectedCurrencyTo(selectedToCurrency: String)
}
