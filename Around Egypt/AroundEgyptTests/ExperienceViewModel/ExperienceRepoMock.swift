//
//  ExperienceRepoMock.swift
//  AroundEgyptTests
//
//  Created by Mohamed Salah on 05/01/2024.
//

import Foundation
import RxTest
import RxSwift
import RxRelay
import RxCocoa
@testable import Around_Egypt


enum MyError: Error {
    case someError
    case anotherError
}
class ExperienceRepoMock: ExperiencesRepoProtocol {

    var fetchGlobalCalled = false
    var fetchGlobalResult: Any?
    var fetchGlobalError: Error?

    func getRecommendedExperiences() -> Single<[Experience]> {
        fetchGlobalCalled = true
        if let error = fetchGlobalError {
            return .error(error)
        }
        if let result = fetchGlobalResult as? [Experience] {
            return .just(result)
        } else {
            return .error(MyError.someError)
        }
    }

    func getRecentExperiences() -> Single<[Experience]> {
        fetchGlobalCalled = true
        if let error = fetchGlobalError {
            return .error(error)
        }
        if let result = fetchGlobalResult as? [Experience] {
            return .just(result)
        } else {
            return .error(MyError.someError)
        }
    }

    func getSearchExperiences(searchText: String) -> Single<[Experience]> {
        let searchResults: [Experience] = [] // Your search results here
        return .just(searchResults)
    }

    func getSingleExperience(id: String) -> Single<Experience> {
        let singleExperience: Experience = Experience.mock
        return .just(singleExperience)
    }

    func likeAnExperience(id: String) -> Single<Int> {
        let updatedLikesCount = 0
        return .just(updatedLikesCount)
    }
}
