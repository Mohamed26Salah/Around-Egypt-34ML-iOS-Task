//
//  ServiceError.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation

enum ServiceError: Int, Error{
    
    case badRequest = 400 //Bad Request
    case authorizationError = 401 //Unauthorized
    case notActivate = 403
    case notFound = 404 // Not Found
    case connectionError = 408 //Connection Time out
    case failer = 422
    case noResponse = 444 //No Response
    
    case serverError = 500 //Internal Server Error
    case invalidRequest = 502 //Bad Gateway
    case serviceUnavailable = 503 //Service Unavailable
    case serverConnection = 504 //Gateway Timeout
    
    var localizedDescription: String {
        switch self{
        case .connectionError:
            return "Check your Internet connection."
        case .invalidRequest:
            return "Failed to connect to the server."
        case .authorizationError:
            return "Session Has Expired."
        case .serverConnection:
            return "Problem connecting to server, Check your Internet connection and try again."
        default:
            return ""
        }
    }
}

struct AppError {
    var message: String
    
    init(message: String) {
        self.message = message
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? { return message }
    var localizedDescription:String? {return message}
}
