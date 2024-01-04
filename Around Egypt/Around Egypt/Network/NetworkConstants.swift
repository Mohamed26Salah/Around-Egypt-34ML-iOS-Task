//
//  NetworkConstants.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
enum BaseURLS: String{
    case Test = "https://aroundegypt.34ml.com/"
    case Live = ""
}

class NetworkConstant{
    static let baseURL: String = BaseURLS.Test.rawValue // Test or Live
    static let apiURL:String = NetworkConstant.baseURL
}
