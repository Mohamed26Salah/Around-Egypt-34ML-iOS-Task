//
//  ExperienceViewModel .swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import RxSwift
import RxRelay
import Network

class ExperienceViewModel{
    
    let disposeBag = DisposeBag()
    let experienceRepo = ExperienceRepo(networkClient: NetworkClient())
    
    var experincesModel: [Experience] = []
    var recommendedExperiences = BehaviorRelay<[Experience]>(value: [])
    var mostRecentExperinces = BehaviorRelay<[Experience]>(value: [])
    
    var errorSubject = PublishSubject<String>()
    var showLoading = BehaviorRelay<Bool>(value: false)
    var isThierAnError = BehaviorRelay<Bool>(value: true)
    
    init() {
        getMostRecentExperinces()
        getRecommendedExperiences()
        print(LocalDataManager.shared().returnDataBaseURL())
    }
}

//MARK: API Calls

extension ExperienceViewModel {
    func getRecommendedExperiences() {
        self.showLoading.accept(true)
        experienceRepo.getRecommendedExperiences()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.showLoading.accept(false)
                self.recommendedExperiences.accept(response)
            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
    func getMostRecentExperinces() {
        self.showLoading.accept(true)
        experienceRepo.getRecentExperiences()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.showLoading.accept(false)
                self.experincesModel = response
                self.mostRecentExperinces.accept(response)
                self.cachExperience()
                
            }, onFailure: { [weak self] error in
                guard let self = self else {
                    return
                }
                print("Error: \(error)")
                self.isThierAnError.accept(true)
                self.experincesModel = LocalDataManager.shared().getAllExperiences()
                self.mostRecentExperinces.accept(LocalDataManager.shared().getAllExperiences())
                self.recommendedExperiences.accept(LocalDataManager.shared().getRecommendedExperiencesFromRealm())
            })
            .disposed(by: disposeBag)
    }
    func getSearchedExperinces(query: String) {
        experienceRepo.getSearchExperiences(searchText: query)
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.showLoading.accept(false)
                self.mostRecentExperinces.accept(response)

            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}

//MARK: Cache Data

extension ExperienceViewModel {
    func cachExperience() {
        LocalDataManager.shared().cacheExperiences(experiences: self.experincesModel) {
            print("Done Cachcing")
        }
    }
}

//MARK: Check internet connectivity

extension ExperienceViewModel {
    func checkNetworkConnection(completion: @escaping (_ success: Bool) -> ()) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status != .unsatisfied {
                completion(true)
            } else {
                completion(false)
            }
        }
        let networkQueue = DispatchQueue(label: "network")
        monitor.start(queue: networkQueue)
    }
}
