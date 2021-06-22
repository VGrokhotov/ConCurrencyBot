@testable import ConCurrencyBotLib
import XCTest
import class Foundation.Bundle

final class ConCurrencyBotTests: XCTestCase {
    func testCB() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        let expectation = XCTestExpectation()
        
        CBNetworkService().getCurrency { cbCurrency in
            expectation.fulfill()
        } errCompletion: { error in
            XCTAssert(false, error)
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCBDate() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        
        let date = "01/01/2000"
        let expectation = XCTestExpectation()
        
        CBNetworkService().getCurrency(date: date) { data in
            if let _ = cbDateParce(date: date, data: data) {
                expectation.fulfill()
            } else {
                XCTAssert(false)
            }
        } errCompletion: { error in
            XCTAssert(false, error)
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testCBDateWithBadDate() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        
        let date = "01/01/1000"
        let expectation = XCTestExpectation()
        
        CBNetworkService().getCurrency(date: date) { data in
            if let _ = cbDateParce(date: date, data: data) {
                XCTAssert(false)
            } else {
                expectation.fulfill()
            }
        } errCompletion: { error in
            XCTAssert(false, error)
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLocal() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        
        let expectation = XCTestExpectation()
        
        LocalBanksNetworkService().getCurrency(currency: "usd", location: "sankt-peterburg") { data in
            if let _ = localParse(data: data, currency: Currency.usd, originalLocation: "Санкт-Петербург") {
                expectation.fulfill()
            } else {
                XCTAssert(false)
            }
        } errCompletion: { error in
            XCTAssert(false, error)
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLocalWithBadCurrency() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        
        let expectation = XCTestExpectation()
        
        LocalBanksNetworkService().getCurrency(currency: "badone", location: "sankt-peterburg") { data in
            XCTAssert(false)
        } errCompletion: { error in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testLocalWithBadLocation() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        
        let expectation = XCTestExpectation()
        
        LocalBanksNetworkService().getCurrency(currency: "usd", location: "badone") { data in
            XCTAssert(false)
        } errCompletion: { error in
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testBestLocal() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        
        let expectation = XCTestExpectation()
        
        LocalBanksNetworkService().getCurrency(currency: "usd", location: "sankt-peterburg") { data in
            if let _ = localBestParse(data: data, currency: Currency.usd, originalLocation: "Санкт-Петербург") {
                expectation.fulfill()
            } else {
                XCTAssert(false)
            }
        } errCompletion: { error in
            XCTAssert(false, error)
        }

        wait(for: [expectation], timeout: 5.0)
    }
    
    func testBestLocalWithNoOffers() throws {
        guard #available(macOS 10.14, *) else {
            return
        }
        
        let expectation = XCTestExpectation()
        
        LocalBanksNetworkService().getCurrency(currency: "cny", location: "smolensk") { data in
            if let _ = localBestParse(data: data, currency: Currency.usd, originalLocation: "Смоленск") {
                XCTAssert(false)
            } else {
                expectation.fulfill()
            }
        } errCompletion: { error in
            XCTAssert(false, error)
        }

        wait(for: [expectation], timeout: 5.0)
    }
}
