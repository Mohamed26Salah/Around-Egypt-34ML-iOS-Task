//
//  ExperienceRepoTest.swift
//  AroundEgyptTests
//
//  Created by Mohamed Salah on 05/01/2024.
//

import XCTest
import Foundation
//import RxTest
import RxSwift
import RxRelay
import RxCocoa
@testable import Around_Egypt

final class ExperienceRepoTest: XCTestCase {
    
    var disposeBag: DisposeBag!
    var sut: ExperienceRepo!
    var mockNetworkClient: MockNetworkClient!
   
    override func setUpWithError() throws {
        disposeBag = DisposeBag()
        mockNetworkClient = MockNetworkClient()
        sut = ExperienceRepo(networkClient: mockNetworkClient)
    }
    
    override func tearDownWithError() throws {
        disposeBag = nil
        mockNetworkClient = nil
        sut = nil
    }
    
    func testGetRecommendedExperiencesSuccess() {        
        mockNetworkClient.fetchGlobalResult = ResponseObject(meta: Meta(code: 0, errors: []), data: [Experience.mock, Experience.mock], pagination: Pagination())
        
        var receivedExperiences: [Experience] = []
        
        sut.getRecommendedExperiences()
            .subscribe(onSuccess: { experiences in
                receivedExperiences = experiences
            })
            .disposed(by: disposeBag)
        
        XCTAssertEqual(receivedExperiences.count, 2)
    }
    func testGetRecommendedExperiencesError() {
        let errorMessage = "Failed to fetch recommended experiences"
        
        mockNetworkClient.fetchGlobalError = NSError(domain: "MockErrorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        
        var receivedError: Error?
        
        let expectation = XCTestExpectation(description: "Fetch recommended experiences failed")
        
        sut.getRecommendedExperiences()
            .subscribe(onFailure: { error in
                receivedError = error
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as NSError?)?.localizedDescription, errorMessage)
    }

    func testGetRecentExperiencesSuccess() {
        mockNetworkClient.fetchGlobalResult = ResponseObject(meta: Meta(code: 0, errors: []), data: [Experience.mock, Experience.mock], pagination: Pagination())
        
        var receivedExperiences: [Experience] = []
        
        sut.getRecentExperiences()
            .subscribe(onSuccess: { experiences in
                receivedExperiences = experiences
            })
            .disposed(by: disposeBag)
        
        XCTAssertEqual(receivedExperiences.count, 2)
    }
    func testGetRecentExperiencesError() {
        let errorMessage = "Failed to fetch recommended experiences"
        
        mockNetworkClient.fetchGlobalError = NSError(domain: "MockErrorDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: errorMessage])
        
        var receivedError: Error?
        
        let expectation = XCTestExpectation(description: "Fetch recommended experiences failed")
        
        sut.getRecentExperiences()
            .subscribe(onFailure: { error in
                receivedError = error
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as NSError?)?.localizedDescription, errorMessage)
    }
    func testSearchExperiencesSuccess() {
        let expectation = XCTestExpectation(description: "Search experiences successful")
        
        mockNetworkClient.fetchGlobalResult = ResponseObject(meta: Meta(code: 0, errors: []), data: [Experience.mock, Experience.mock], pagination: Pagination())
        
        var receivedExperiences: [Experience] = []
        
        sut.getSearchExperiences(searchText: "")
            .subscribe(onSuccess: { experiences in
                receivedExperiences = experiences
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 5.0)
        
        XCTAssertEqual(receivedExperiences.count, 2)
    }
    
    

    func testGetSingleExperienceSendAndReceive() {
        let experienceID = ""
        
        let expectedResponse = ResponseObject(meta: Meta(code: 0, errors: []), data: Experience.mock, pagination: Pagination())
        
        mockNetworkClient.fetchGlobalResult = expectedResponse
        
        var receivedExperience: Experience?
        
        sut.getSingleExperience(id: experienceID)
            .subscribe(onSuccess: { experience in
                receivedExperience = experience
            })
            .disposed(by: disposeBag)
        
        XCTAssertEqual(receivedExperience?.id, experienceID)
    }
    
    func testLikeAnExperience() {
        let experienceID = "123"
        mockNetworkClient.fetchGlobalResult = 10
        
        var receivedLikeCount = -1
        
        sut.likeAnExperience(id: experienceID)
            .subscribe(onSuccess: { likeCount in
                receivedLikeCount = likeCount
            })
            .disposed(by: disposeBag)
        
        XCTAssertNotEqual(receivedLikeCount, 10)
    }

}
