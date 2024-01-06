//
//  HomeProUIViewUITests.swift
//  Around EgyptUITests
//
//  Created by Mohamed Salah on 06/01/2024.
//

import XCTest
import SwiftUI
import RealmSwift
import SDWebImageSwiftUI
import RxSwift
import RxCocoa
import RxRelay
@testable import Around_Egypt

final class HomeProUIViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    func testSearchBarFunctionality() throws {
        let searchBar = app.searchFields["homeProUISearchBar"]
        XCTAssertTrue(searchBar.exists)

        // Type text into the search bar
        searchBar.tap()
        searchBar.typeText("Your search query")

        // Validate that the text entered in the search bar is correct
        XCTAssertEqual(searchBar.value as? String, "Your search query")

        // Tap the search button on the keyboard
        app.keyboards.buttons["Search"].tap()

    }

    // Test tapping on navigate icon
 
    override func tearDownWithError() throws {
        app = nil
    }
}
