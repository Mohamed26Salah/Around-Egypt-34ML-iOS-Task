//
//  BaseRepositry.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import RxSwift
import RxRelay
class BaseRepository{
    var disposeBag: DisposeBag = .init()
    let networkClient:NetworkClientProtocol!

    init(networkClient:NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
}

