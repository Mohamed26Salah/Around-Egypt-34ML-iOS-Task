//
//  HomeViewController.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {
    let authRepo = ExperienceRepo(networkClient: NetworkClient())
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        authRepo.getSearchExperiences(searchText: "Aswan")
            .observe(on: MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                guard let self = self else {
                    return
                }
//                print(response.data)
            }, onFailure: { error in
                print("Error: \(error)")
            })
            .disposed(by: disposeBag)
        // Do any additional setup after loading the view.
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
