//
//  AuthRepo.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import RxSwift

protocol ExperiencesRepoProtocol {
    func getRecommendedExperiences()->Single<([Experience])>
    func getRecentExperiences()->Single<([Experience])>
    func getSearchExperiences(searchText: String)->Single<([Experience])>
    func getSingleExperience(id: String)->Single<(Experience)>
    //Needs to be edited the last one
    func getLikeAnExperience(id: String)->Single<(Int)>


}

class ExperienceRepo: BaseRepository, ExperiencesRepoProtocol{

    func getRecommendedExperiences() -> RxSwift.Single<([Experience])> {
        return Single.create{[weak self] observer -> Disposable in
            guard let self = self else{return Disposables.create()}
            self.networkClient.performRequest([Experience].self
                                              , router: AuthRouter.RecommendedExperiences)
                .subscribe { (response) in
                    if (response.meta.errors.isEmpty) {
                        if let data = response.data{
                            observer(.success(data))
                        }
                    } else {
                        observer(.failure(AppError(message: response.meta.errors.description)))
                    }
                } onFailure: { (error) in
                    observer(.failure(error))
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    func getRecentExperiences() -> RxSwift.Single<([Experience])> {
        return Single.create{[weak self] observer -> Disposable in
            guard let self = self else{return Disposables.create()}
            self.networkClient.performRequest([Experience].self
                                              , router: AuthRouter.RecentExperiences)
                .subscribe { (response) in
                    if (response.meta.errors.isEmpty) {
                        if let data = response.data{
                            observer(.success(data))
                        }
                    } else {
                        observer(.failure(AppError(message: response.meta.errors.description)))
                    }
                } onFailure: { (error) in
                    observer(.failure(error))
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getSearchExperiences(searchText: String) -> RxSwift.Single<([Experience])> {
        return Single.create{[weak self] observer -> Disposable in
            guard let self = self else{return Disposables.create()}
            self.networkClient.performRequest([Experience].self
                                              , router: AuthRouter.SearchExperiences(searchText: searchText))
                .subscribe { (response) in
                    if (response.meta.errors.isEmpty) {
                        if let data = response.data{
                            observer(.success(data))
                        }
                    } else {
                        observer(.failure(AppError(message: response.meta.errors.description)))
                    }
                } onFailure: { (error) in
                    observer(.failure(error))
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getSingleExperience(id: String) -> RxSwift.Single<(Experience)> {
        return Single.create{[weak self] observer -> Disposable in
            guard let self = self else{return Disposables.create()}
            self.networkClient.performRequest(Experience.self
                                              , router: AuthRouter.SingleExperience(id: id))
                .subscribe { (response) in
                    if (response.meta.errors.isEmpty) {
                        if let data = response.data{
                            observer(.success(data))
                        }
                    } else {
                        observer(.failure(AppError(message: response.meta.errors.description)))
                    }
                } onFailure: { (error) in
                    observer(.failure(error))
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
    
    func getLikeAnExperience(id: String) -> RxSwift.Single<(Int)> {
        return Single.create{[weak self] observer -> Disposable in
            guard let self = self else{return Disposables.create()}
            self.networkClient.performRequest(Int.self
                                              , router: AuthRouter.LikeAnExperience(id: id))
                .subscribe { (response) in
                    if (response.meta.errors.isEmpty) {
                        if let data = response.data{
                            observer(.success(data))
                        }
                    } else {
                        observer(.failure(AppError(message: response.meta.errors.description)))
                    }
                } onFailure: { (error) in
                    observer(.failure(error))
                }.disposed(by: self.disposeBag)
            return Disposables.create()
        }
    }
}
