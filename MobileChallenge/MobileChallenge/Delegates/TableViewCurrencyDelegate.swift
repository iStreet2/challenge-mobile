//
//  TableViewCurrencyDelegate.swift
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 20/11/24.
//

import Foundation
import UIKit

class TableViewCurrencyDelegate: NSObject, UITableViewDelegate {

    weak var viewController: CurrencyListingViewController?
    weak var delegate: CurrencyListingDelegateProtocol?
    
    init(viewController: CurrencyListingViewController?) {
        self.viewController = viewController
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = viewController else { return }
        if viewController.fromOrTo == .from {
            delegate?.updateSelectedCurrencyFrom(selectedFromCurrency: viewController.listOfCurrencyCodes[indexPath.row])
        }
        else {
            delegate?.updateSelectedCurrencyTo(selectedToCurrency: viewController.listOfCurrencyCodes[indexPath.row])
        }
        viewController.dismiss(animated: true)
    }
}
