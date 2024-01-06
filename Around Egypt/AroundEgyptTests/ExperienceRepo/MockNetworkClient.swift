//
//  MockNetworkClient.swift
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
import Alamofire

@testable import Around_Egypt

class MockNetworkClient: NetworkClientProtocol {
    
    var fetchGlobalCalled = false
    var fetchGlobalResult: Any?
    var fetchGlobalError: Error?
    
    func performRequest<T: Decodable>(_ object: T.Type, router: APIRouter) -> Single<ResponseObject<T>> where T: Decodable {
        return Single.create { single in
            if let response = self.fetchGlobalResult as? ResponseObject<T> {
                single(.success(response)) // Emit a success event with the predefined response
            } else if let error = self.fetchGlobalError {
                single(.failure(error)) // Emit an error event if there's a predefined error
            } else {
                // If there's neither a result nor an error, you can emit an error
                single(.failure(MyError.anotherError))
            }
            
            // Return a disposable for cleanup
            return Disposables.create()
        }
    }

    func performRequestMultiPart<T>(with decoded: T.Type, router: Around_Egypt.APIRouter, fileName: String, fileData: Data?) -> RxSwift.Single<Around_Egypt.ResponseObject<T>> where T : Decodable, T : Encodable {
        fatalError("Not implemented")
    }
    
    func handleResponse<T>(urlPath: String, response: Alamofire.DataResponse<T, Alamofire.AFError>, returnWithData: @escaping (T?) -> (), returnError: @escaping (Error?) -> ()) where T : Decodable {
        fatalError("Not implemented")
    }

}
