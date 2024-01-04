//
//  FailureResponse.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
struct FailureResponse:Codable{
    let errors:FailureError?
}
struct FailureError:Codable{
    let Name:[String]
}


struct ServerErrorResponse: Codable {
    let type: String?
    let title: String?
    let status: Int?
    let traceID: String?
    let errors: Errors?

    enum CodingKeys: String, CodingKey {
        case type, title, status
        case traceID = "traceId"
        case errors
    }
}

// MARK: - Errors
struct Errors: Codable {
    let name: [String]

    enum CodingKeys: String, CodingKey {
        case name = "Name"
    }
}
