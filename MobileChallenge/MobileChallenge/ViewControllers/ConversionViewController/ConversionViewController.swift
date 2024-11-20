//
//  ConversionViewController.swiftlist.bullet
//  MobileChallenge
//
//  Created by Gabriel Vicentin Negro on 18/11/24.
//

import UIKit

class ConversionViewController: UIViewController, CurrencyListingDelegateProtocol {
   
    //MARK: ViewModels
    let listOfCurrencyViewModel: ListOfCurrencyViewModelProtocol
    let liveValueViewModel: LiveValueViewModelProtocol
    
    //MARK: Delegates
    let textFieldDelegate = TextFieldDelegate()
    
    //MARK: Variables
    var selectedFromCurrency: String = "USD"
    var selectedToCurrency = "BRL"
    var liveValuesList: [String:Double] = [:]
    
    
    //MARK: UIComponents
    private var listButton: UIBarButtonItem = {
        let button = UIBarButtonItem()
        button.image = UIImage(systemName: "list.bullet")
        return button
    }()
    
    private let invertButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left.arrow.right"), for: .normal)
        return button
    }()
    
    private let currencyFromButton: UIButton = {
        let button = UIButton()
        button.setTitle("USD", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "chevron.up.chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let currencyToButton: UIButton = {
        let button = UIButton()
        button.setTitle("BRL", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setImage(UIImage(systemName: "chevron.up.chevron.down"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let numberTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "0.00"
        textField.keyboardType = .decimalPad
        return textField
    }()
    
    private let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "0.00"
        return label
    }()
    
    //MARK: Inits
    init(listOfCurrencyViewModel: ListOfCurrencyViewModelProtocol, liveValueViewModel: LiveValueViewModelProtocol) {
        self.listOfCurrencyViewModel = listOfCurrencyViewModel
        self.liveValueViewModel = liveValueViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        self.currencyFromButton.setTitle(selectedFromCurrency, for: .normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.overrideUserInterfaceStyle = .light
        
        self.numberTextField.delegate = textFieldDelegate
        self.loadUI()
    }
    
    
    //MARK: UIAddingFunctions
    func loadUI() {
        initToolBar()
        addCurrencyFromButton()
        addCurrencyToButton()
        addNumberTextField()
        addNumberTextView()
//        addInvertButton()
        addDoneButtonToKeyboard()
        setUpGestureToDismissKeyboard()
    }
    
    func initToolBar() {
        self.title = "Conversão"
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
        
    func addCurrencyFromButton() {
        self.view.addSubview(currencyFromButton)
        NSLayoutConstraint.activate([
            currencyFromButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            currencyFromButton.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 60)
        ])
        self.currencyFromButton.addTarget(self, action: #selector(navigateFromCurrencyToList), for: .touchUpInside)
    }
    
    func addCurrencyToButton() {
        self.view.addSubview(currencyToButton)
        NSLayoutConstraint.activate([
            currencyToButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            currencyToButton.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -60)
        ])
        self.currencyToButton.addTarget(self, action: #selector(navigateToCurrencyToList), for: .touchUpInside)
    }
    
    func addNumberTextField() {
        self.view.addSubview(numberTextField)
        NSLayoutConstraint.activate([
            numberTextField.centerXAnchor.constraint(equalTo: self.currencyFromButton.centerXAnchor),
            numberTextField.topAnchor.constraint(equalTo: self.currencyFromButton.bottomAnchor, constant: 20),
        ])
    }
    
    func addNumberTextView() {
        self.view.addSubview(numberLabel)
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: self.currencyToButton.centerXAnchor),
            numberLabel.topAnchor.constraint(equalTo: self.currencyToButton.bottomAnchor, constant: 20)
        ])
    }
    
    func addInvertButton() {
        self.view.addSubview(invertButton)
        NSLayoutConstraint.activate([
            invertButton.topAnchor.constraint(equalTo: self.numberTextField.topAnchor, constant: -10),
            invertButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
    }
    
    func addDoneButtonToKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(calculateAndDismissKeyboard))
        toolbar.items = [doneButton]
        
        numberTextField.inputAccessoryView = toolbar
    }
    
    func setUpGestureToDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(calculateAndDismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    //MARK: Logic Functions
    @objc
    func navigateFromCurrencyToList() {
        let sheetViewController = CurrencyListingViewController(listOfCurrencyViewModel: listOfCurrencyViewModel, liveValueViewModel: liveValueViewModel, selectedFromCurrency: selectedFromCurrency)
        sheetViewController.fromOrTo = .from
        sheetViewController.delegate = self
        present(sheetViewController, animated: true, completion: nil)
    }
    
    @objc
    func navigateToCurrencyToList() {
        let sheetViewController = CurrencyListingViewController(listOfCurrencyViewModel: listOfCurrencyViewModel, liveValueViewModel: liveValueViewModel, selectedFromCurrency: selectedFromCurrency)
        sheetViewController.fromOrTo = .to
        sheetViewController.delegate = self
        present(sheetViewController, animated: true, completion: nil)
    }
    
    @objc
    func calculateAndDismissKeyboard() {
        //MARK: Fazer a função de calcular seu bobao!
        view.endEditing(true)
        
        getApiData { success in
            if success {
                DispatchQueue.main.async {
                    guard let originalValueString = self.numberTextField.text, let originalValue = Double(originalValueString) else { return } 
                    let fromToUSD = self.selectedFromCurrency == "USD" ? 1.0 : (self.liveValuesList["USD\(self.selectedFromCurrency)"] ?? 0)
                    let usdToTo = self.selectedToCurrency == "USD" ? 1.0 : (self.liveValuesList["USD\(self.selectedToCurrency)"] ?? 0)
                    let valueInUSD = originalValue / fromToUSD
                    let resultNumber = self.liveValueViewModel.calculate(originalValue: valueInUSD, multiplier: usdToTo)
                    self.numberLabel.text = resultNumber
                }
            }
        }
    }
    
    func updateSelectedCurrencyFrom(selectedFromCurrency: String) {
        self.selectedFromCurrency = selectedFromCurrency
        self.currencyFromButton.setTitle(selectedFromCurrency, for: .normal)
    }
    
    func updateSelectedCurrencyTo(selectedToCurrency: String) {
        self.selectedToCurrency = selectedToCurrency
        self.currencyToButton.setTitle(selectedToCurrency, for: .normal)
    }
    
    func getApiData(completion: @escaping(Bool) -> Void) {
        liveValueViewModel.getLiveValues { [weak self] result in
            guard let self = self else {return}
            DispatchQueue.main.async {
                switch result {
                case .success(let liveValuesList):
                    self.liveValuesList = liveValuesList
                    completion(true)
                case .failure(let error):
                    print(error.localizedDescription)
                    completion(false)
                }
            }
        }
    }
}

enum FromOrTo {
    case from
    case to
}

#Preview {
    return ConversionViewController(listOfCurrencyViewModel: ListOfCurrencyViewModelMock(), liveValueViewModel: LiveValueViewModel())
}
