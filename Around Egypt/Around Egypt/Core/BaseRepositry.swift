//
//  BaseRepositry.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import RxSwift

class BaseRepository{
    var disposeBag: DisposeBag = .init()
    let networkClient:NetworkClient!
    
    init(networkClient:NetworkClient) {
        self.networkClient = networkClient
    }
}
