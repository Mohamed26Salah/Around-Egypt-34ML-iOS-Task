//
//  NetworkClient.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa
import RxRelay


func Logging<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("\(fileName):(\(lineNum))-\(message)")
    #endif
}

struct DataAll : Decodable {
   
    var success :  Bool?
    var message :String?
    private enum CodingKeys:String,CodingKey{
        case message = "message"
        case success = "success"
    }
   
}
class NetworkClient {
    
    func performRequest<T: Decodable>(_ object: T.Type, router: APIRouter) -> Single<ResponseObject<T>> where T : Decodable {
        return Single.create { (observer) -> Disposable in
            Logging("=====\(String(describing: router.urlRequest))")
            AF.request(router)
                .responseDecodable(of: ResponseObject<T>.self) { (response) in
                    switch response.result {
                    case .success(let responseObject):
                        PrintHelper.logNetwork("""
                            ✅ Response: \(response.request?.httpMethod?.uppercased() ?? "") '\(String(describing: router.urlRequest))':
                            🧾 Status Code: \(response.response?.statusCode ?? 0), 💾 \(response.data ?? Data()), ⏳ time: \(Date().timeIntervalSince(Date()))
                            ⬇️ Response headers = \(response.response?.allHeaderFields.json ?? "No Headers")
                            ⬇️ Response Body = \(String(data: response.data ?? Data(), encoding: String.Encoding.utf8) ?? "")
                            """ )
                        observer(.success(responseObject))
                    case .failure(let error):
                        print(error)
                        Logging(error.localizedDescription)
                        if let statusCode = response.response?.statusCode {
                            switch ServiceError.init(rawValue: statusCode) {
                            case .badRequest:
                                do {
                                    let failerResponseModel = try JSONDecoder().decode(ServerErrorResponse.self, from: response.data ?? Data())
                                    guard let errors = failerResponseModel.errors, !errors.name.isEmpty else {
                                        observer(.failure(AppError(message: "")))
                                        return
                                    }
                                    observer(.failure(AppError(message: errors.name[0])))
                                } catch let error {
                                    observer(.failure(error))
                                }
                            default:
                                if let reason = ServiceError(rawValue: statusCode) {
                                    observer(.failure(reason))
                                }
                            }
                        }
                        print("No InterNet Connetion Network Client")
                    }
                }.resume()
            return Disposables.create()
        }
    }

    func performRequestMultiPart<T:Decodable>(with decoded:T.Type, router: APIRouter,fileName:String,fileData:Data?) -> Single<ResponseObject<T>> where T : Decodable {
        return Single.create { (observer) -> Disposable in
            let urlRequest = router.urlRequest!
            AF.upload(
                multipartFormData: { multipartFormData in
                    multipartFormData.append(fileData ?? .init(), withName: "Image", fileName: fileName, mimeType: "image")
                    for (key,value) in router.parameters ?? [:] {
                        multipartFormData.append((value as AnyObject).description.data(using: String.Encoding.utf8)!, withName: key)
                    }
                },
                with: urlRequest).responseDecodable(of: ResponseObject<T>.self) { response in
                    switch response.result {
                    case .success(let responseObject):
                        PrintHelper.logNetwork("""
                            ✅ Response: \(response.request?.httpMethod?.uppercased() ?? "") '\(String(describing: router.urlRequest))':
                            🧾 Status Code: \(response.response?.statusCode ?? 0), 💾 \(response.data ?? Data()), ⏳ time: \(Date().timeIntervalSince(Date()))
                            ⬇️ Response headers = \(response.response?.allHeaderFields.json ?? "No Headers")
                            ⬇️ Response Body = \(String(data: response.data ?? Data(), encoding: String.Encoding.utf8) ?? "")
                            """ )
                        observer(.success(responseObject))
                    case .failure(let error):
                        Logging(error.localizedDescription)
                        if let statusCode = response.response?.statusCode {
                            switch ServiceError.init(rawValue: statusCode) {
                            case .badRequest:
                                do {
                                    let failerResponseModel = try JSONDecoder().decode(ServerErrorResponse.self, from: response.data ?? Data())
                                    guard let errors = failerResponseModel.errors, !errors.name.isEmpty else {
                                        observer(.failure(AppError(message: "")))
                                        return
                                    }
                                    observer(.failure(AppError(message: errors.name[0])))
                                } catch let error {
                                    observer(.failure(error))
                                }
                            default:
                                if let reason = ServiceError(rawValue: statusCode) {
                                    observer(.failure(reason))
                                }
                            }
                        }
                        print("No InterNet Connetion Network Client")
                    }
                }
            return Disposables.create()
        }
    }

    func handleResponse<T:Decodable>(urlPath:String,response:DataResponse<T,AFError>,returnWithData:@escaping(T?)->(),returnError:@escaping(Error?)->())
        {
            print("\(urlPath):Response:\(String(describing: response.value))")
            switch response.result{
            case .success( _ ):
                guard let data = response.value else
                {
                    returnError( response.error ?? NSError(domain: "Api Failure", code: 1,userInfo: ["message":"could`t decode json data"])); return
                }
                returnWithData(data)
            case .failure(let error):
                print("sss=\(error.localizedDescription)")
                returnError(NSError(domain: "Api Failure", code: 1,userInfo: ["message":"\(error.localizedDescription)"]))
            }
        }
}

class PrintHelper {
    static func logNetwork<T>(_ items: T, separator: String = " ", terminator: String = "\n") {
        print("""
            \n===================== 📟 ⏳ 📡 =========================
            \(items)
            ======================= 🚀 ⌛️ 📡 =========================
            """, separator: separator, terminator: terminator)
    }
}
extension Dictionary {
    var json: String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(bytes: jsonData, encoding: String.Encoding.utf8) ?? "Not a valid JSON"
        } catch {
            return "Not a valid JSON"
        }
    }
}
