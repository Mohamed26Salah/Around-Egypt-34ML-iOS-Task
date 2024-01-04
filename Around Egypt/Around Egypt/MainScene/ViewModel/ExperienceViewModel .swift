//
//  ExperienceViewModel .swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import Foundation
import RxSwift
import RxRelay
class ExperienceViewModel{
    
    let disposeBag = DisposeBag()
    let experienceRepo = ExperienceRepo(networkClient: NetworkClient())
    
    var experincesModel: [Experience] = []
    var recommendedExperiences = BehaviorRelay<[Experience]>(value: [])
    var mostRecentExperinces = BehaviorRelay<[Experience]>(value: [])
    
    var errorSubject = PublishSubject<String>()
    var showLoading = BehaviorRelay<Bool>(value: false)
}

//MARK: API Calls

extension ExperienceViewModel {
    func getRecommendedExperiences() {
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
        experienceRepo.getRecentExperiences()
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
                self.showLoading.accept(false)
                self.experincesModel = response
                self.mostRecentExperinces.accept(response)

            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
    }
}
