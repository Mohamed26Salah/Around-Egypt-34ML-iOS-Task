//
//  ResposneObject.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation

// MARK: - RecommenedExperiences
struct ResponseObject<T: Codable>: Codable {
    var meta: Meta
    var data: T?
    var pagination: Pagination

    enum CodingKeys: String, CodingKey {
        case meta = "meta"
        case data = "data"
        case pagination = "pagination"
    }
}
