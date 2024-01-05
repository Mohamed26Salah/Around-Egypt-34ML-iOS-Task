//
//  ExperienceViewModelTest.swift
//  AroundEgyptTests
//
//  Created by Mohamed Salah on 05/01/2024.
//

import XCTest
import Foundation
import RxTest
import RxSwift
import RxRelay
import RxCocoa
@testable import Around_Egypt

final class ExperienceViewModelTest: XCTestCase {

    var disposeBag: DisposeBag!
    var sut: ExperienceViewModel!
    var experienceRepoMock: ExperienceRepoMock!
    
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        experienceRepoMock = ExperienceRepoMock()
        sut = ExperienceViewModel(experienceRepo: experienceRepoMock)
    }

    override func tearDownWithError() throws {
        disposeBag = nil
        experienceRepoMock = nil
        sut = nil
    }

    func testRecommendedExperiencesBeingCalled() {
        let expectedExperiences = [Experience.mock, Experience.mock]
        experienceRepoMock.fetchGlobalResult = expectedExperiences
        sut.getRecommendedExperiences()
        XCTAssertTrue(experienceRepoMock.fetchGlobalCalled)
    }
    
    func testRecetExperiencesBeingCalled() {
        let expectedExperiences = [Experience.mock, Experience.mock]
        experienceRepoMock.fetchGlobalResult = expectedExperiences
        sut.getMostRecentExperinces()
        XCTAssertTrue(experienceRepoMock.fetchGlobalCalled)
    }
    
    func testSearchExperiencesBeingCalled() {
        let expectedExperiences = [Experience.mock, Experience.mock]
        experienceRepoMock.fetchGlobalResult = expectedExperiences
        sut.getSearchedExperinces(query: "")
        XCTAssertTrue(experienceRepoMock.fetchGlobalCalled)
    }
    
    func testLikeAnExperienceIsBeingCalled() {
        let expectedExperiences = [Experience.mock, Experience.mock]
        experienceRepoMock.fetchGlobalResult = expectedExperiences
        sut.likeAnExperience(experienceID: "1")
        XCTAssertTrue(experienceRepoMock.fetchGlobalCalled)
    }

}


