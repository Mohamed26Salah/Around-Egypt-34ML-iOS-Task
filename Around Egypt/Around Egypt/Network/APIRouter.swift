//
//  APIRouter.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import Alamofire

protocol APIRouter: URLRequestConvertible{
    var method: HTTPMethod { get }
    var path: String  { get }
    var parameters: Parameters?  { get }
    var encoding: ParameterEncoding { get }
    var headers: HTTPHeaders? {get}
}

extension APIRouter {
//    var queryItem: [URLQueryItem]!{
//        let language = LocalizationManager.shared.getLanguage() ?? .English
//        return [URLQueryItem(name: "language", value: language.rawValue), ]
//    }
//    var headers: HTTPHeaders? {
//            let headers: HTTPHeaders = [.authorization(bearerToken: "token")]
//            return headers
//    }
    
    var headers: Alamofire.HTTPHeaders? {
        return nil
    }
    func asURLRequest() throws -> URLRequest {
        guard var url: URL = URL(string: NetworkConstant.apiURL) else {
            throw ApiError.URLNotValid
        }
        url.appendPathComponent(path)
//        queryItem.forEach{
//            url.appendQueryItem(name: $0.name, value: $0.value)}
        var request = try URLRequest(url: url, method: method, headers: nil)
//        if let headers = headers {
//            headers.forEach{
//                request.setValue($0.value, forHTTPHeaderField: $0.name)
//                request.setValue("currentLanguage", forHTTPHeaderField: "Accept-Language")
//            }
//        }
        return try encoding.encode(request, with: parameters)
    }
   
   
}
enum ApiError: Error {
    case URLNotValid
}
