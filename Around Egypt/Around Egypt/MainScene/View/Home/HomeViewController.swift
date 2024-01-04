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
    }

}
