//
//  CurrencyListingViewController.swift
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 18/11/24.
//

import UIKit

class CurrencyListingViewController: UIViewController {
    
    //MARK: ViewModels
    var listOfCurrencyViewModel: ListOfCurrencyViewModelProtocol
    var liveValueViewModel: LiveValueViewModelProtocol
    
    //MARK: Variables
    var listOfCurrency: [String:String] = [:]
    var listOfCurrencyNames: [String] = []
    var listOfCurrencyCodes: [String] = []
    var selectedFromCurrency: String
    var selectedToCurrency: String = ""
    var fromOrTo: FromOrTo = .from
    var filteredListOfCurrency: [String:String] = [:]
    weak var delegate: CurrencyListingDelegateProtocol?
    
    var tableViewCurrencyDataSource: TableViewCurrencyDataSource?
    var tableViewCurrencyDelegate: TableViewCurrencyDelegate?
    var searchBarDelegate: SearchBarDelegate?
    
    //MARK: UIComponents
    private let tableViewCurrency: UITableView = UITableView()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Carregando"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        return label
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.placeholder = "Search Currency"
        searchBar.searchTextField.backgroundColor = .white
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let filterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        return button
    }()
    
    init(listOfCurrencyViewModel: ListOfCurrencyViewModelProtocol, liveValueViewModel: LiveValueViewModelProtocol, selectedFromCurrency: String) {
        self.listOfCurrencyViewModel = listOfCurrencyViewModel
        self.liveValueViewModel = liveValueViewModel
        self.selectedFromCurrency = selectedFromCurrency
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        loadUIWithoutData()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        getAPIData() { success in
            if success {
                DispatchQueue.main.async {
                    self.loadUIWithData()
                }
            } else {
                //Mostrar alerta de erro na api?
            }
        }
    }
    
    func loadUIWithoutData() {
        self.view.addSubview(loadingLabel)
        NSLayoutConstraint.activate([
            loadingLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            loadingLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    func removeLoadingText() {
        self.loadingLabel.removeFromSuperview()
    }
    
    func loadUIWithData() {
        createDataSourceAndDelegate()
//        addFilterButton()
        addSearchBar()
        addTableViewCurrency()
        removeLoadingText()
        addDoneButtonToKeyboard()
        addGestureToDismissKeyboard()
    }
    
    func createDataSourceAndDelegate() {
        let sortedListOfCurrency = listOfCurrency.sorted { $0.key < $1.key }
        self.listOfCurrencyNames = sortedListOfCurrency.map { $0.value }
        self.listOfCurrencyCodes = sortedListOfCurrency.map { $0.key }
        
        self.tableViewCurrencyDataSource = TableViewCurrencyDataSource(listOfCurrencyNames: listOfCurrencyNames, listOfCurrencyCodes: listOfCurrencyCodes)
        self.tableViewCurrencyDelegate = TableViewCurrencyDelegate(viewController: self)
        tableViewCurrencyDelegate?.delegate = delegate
        self.searchBarDelegate = SearchBarDelegate(viewController: self)
        
        self.tableViewCurrency.dataSource = self.tableViewCurrencyDataSource
        self.tableViewCurrency.delegate = self.tableViewCurrencyDelegate
        self.searchBar.delegate = self.searchBarDelegate
    }
    
    func addFilterButton() {
        self.view.addSubview(filterButton)
        NSLayoutConstraint.activate([
            filterButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -30),
            filterButton.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10)
        ])
    }
    
    
    func addSearchBar() {
        self.view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -10),
            searchBar.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 5)
        ])
    }
    
    func addTableViewCurrency() {
        self.tableViewCurrency.register(TableViewCurrencyCell.self, forCellReuseIdentifier: TableViewCurrencyCell.identifier)
        self.view.addSubview(tableViewCurrency)
        self.tableViewCurrency.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableViewCurrency.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            tableViewCurrency.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            tableViewCurrency.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor, constant: 20),
            tableViewCurrency.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10)
        ])
    }
    
    func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))
        toolbar.items = [doneButton]
        
        searchBar.inputAccessoryView = toolbar
    }
    
    func addGestureToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    func updateCurrencyTableView() {
        self.listOfCurrencyNames = filteredListOfCurrency.map { $0.value }
        self.listOfCurrencyCodes = filteredListOfCurrency.map { $0.key }
        
        self.tableViewCurrencyDataSource?.listOfCurrencyNames = listOfCurrencyNames
        self.tableViewCurrencyDataSource?.listOfCurrencyCodes = listOfCurrencyCodes
        
        self.tableViewCurrency.reloadData()
    }
    
    func getAPIData(completion: @escaping(Bool) -> Void) {
        listOfCurrencyViewModel.getListOfCurrency { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let listOfCurrency):
                    self.listOfCurrency = listOfCurrency
                    completion(true)
                    
                case.failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
    
    @objc
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
