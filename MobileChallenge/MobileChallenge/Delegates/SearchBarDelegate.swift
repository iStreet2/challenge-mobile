//
//  SearchBarDelegate.swift
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 20/11/24.
//

import Foundation
import UIKit

class SearchBarDelegate: NSObject, UISearchBarDelegate {
    weak var viewController: CurrencyListingViewController?
    
    init(viewController: CurrencyListingViewController) {
        self.viewController = viewController
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let viewController = viewController else { return }
        if !searchText.isEmpty {
            viewController.filteredListOfCurrency = viewController.listOfCurrency.filter({ $0.key.lowercased().contains(searchText.lowercased()) || $0.value.lowercased().contains(searchText.lowercased()) })
            
        }
        viewController.updateCurrencyTableView()
    }
}
