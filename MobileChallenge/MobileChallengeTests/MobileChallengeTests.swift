//
//  MobileChallengeTests.swift
//  MobileChallengeTests
//
//  Created by Gabriel Vicentin Negro on 18/11/24.
//

import XCTest
@testable import MobileChallenge

final class MobileChallengeTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testAPICurrencyList() async {
        
        print("Rodou o teste")
        
        let viewModel = ListOfCurrencyViewModel()
        let expectation = XCTestExpectation()
        
        
        viewModel.getListOfCurrency { result in
            switch result {
            case .success(let listOfCurrency):
                print(listOfCurrency)
            case .failure(let error):
                print("Erro na API: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 12.0)
    }
    
    func testAPIRequestLiveValue() async throws {
        print("Rodou o teste")
        let viewModel = LiveValueViewModel()
        let expectation = XCTestExpectation()
        
        viewModel.getLiveValues { result in
            switch result {
            case .success(let listOfLiveValues):
                print(listOfLiveValues)
            case .failure(let error):
                print("Erro na API: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 5.0)
    }
    
    func testCalculation() {
        let viewModel = LiveValueViewModel()
        let originalValue: Double = 5
        
        let result = viewModel.calculate(originalValue: originalValue, multiplier: 5)
        XCTAssertEqual(result, "25.00")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
