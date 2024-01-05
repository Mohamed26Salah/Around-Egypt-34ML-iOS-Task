//
//  ExperienceDetailsUITest.swift
//  Around EgyptUITests
//
//  Created by Mohamed Salah on 05/01/2024.
//

import XCTest
import SwiftUI
import RealmSwift
import SDWebImageSwiftUI
@testable import Around_Egypt

final class ExperienceDetailsUITest: XCTestCase {
    var app: XCUIApplication!
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
    }
    
    func testExperienceDetailsView() {
        // Navigate to the ExperienceDetails view
        // Replace "ExperienceDetailsViewIdentifier" with the accessibility identifier for your view
        let cell = app.collectionViews.cells["ExperienceCell_7351979e-7951-4aad-876f-49d5027438bf"]
        cell.tap()
        
        let experienceDetailsView = app.otherElements["ExperienceDetailsViewIdentifier"]
        XCTAssertTrue(experienceDetailsView.waitForExistence(timeout: 5))
        
        // Test the title
        // Replace "TitleIdentifier" with the accessibility identifier for the title
        let title = experienceDetailsView.staticTexts["TitleIdentifier"]
        XCTAssertTrue(title.exists)
        
        // Test the address
        // Replace "AddressIdentifier" with the accessibility identifier for the address
        let address = experienceDetailsView.staticTexts["AddressIdentifier"]
        XCTAssertTrue(address.exists)
        
        // Test the description
        // Replace "DescriptionIdentifier" with the accessibility identifier for the description
        let description = experienceDetailsView.staticTexts["DescriptionIdentifier"]
        XCTAssertTrue(description.exists)
        
        // Test the like button
        // Replace "LikeButtonIdentifier" with the accessibility identifier for the like button
        let likeButton = experienceDetailsView.buttons["LikeButtonIdentifier"]
        XCTAssertTrue(likeButton.exists)
        likeButton.tap()
        // Add assertions to verify the like button's state after tapping
        
        // Add more assertions as needed to test other elements in the view
    }
}

