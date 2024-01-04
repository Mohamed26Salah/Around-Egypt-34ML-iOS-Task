//
//  Router.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//


import Foundation
import Alamofire

enum AuthRouter: APIRouter {
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .RecommendedExperiences:
            return .get
        case .RecentExperiences:
            return .get
        case .SearchExperiences:
            return .get
        case .SingleExperience:
            return .get
        case .LikeAnExperience:
            return .post
        }
    }
    
    var path: String {
            switch self {
            case .RecommendedExperiences:
                return "api/v2/experiences"
            case .RecentExperiences:
                return "api/v2/experiences"
            case .SearchExperiences:
                return "api/v2/experiences"
            case .SingleExperience(let id):
                return "api/v2/experiences/\(id)"
            case .LikeAnExperience(let id):
                return "api/v2/experiences/\(id)/like"
            }
        }
    
    var parameters: Alamofire.Parameters?{
        switch self {
        case .RecommendedExperiences:
            return ["filter[recommended]": "true"]
        case .SearchExperiences(let searchText):
            return ["filter[title]": searchText]
        default:
            return nil
        }
    }
    
    var encoding: Alamofire.ParameterEncoding{
        switch self {
        case .RecommendedExperiences, .RecentExperiences, .SearchExperiences:
            return URLEncoding.queryString
        default:
            return URLEncoding.default
        }
    }
    
    
    case RecommendedExperiences
    case RecentExperiences
    case SearchExperiences(searchText: String)
    case SingleExperience(id: String)
    case LikeAnExperience(id: String)
    
}
