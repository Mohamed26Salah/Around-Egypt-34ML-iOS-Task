//
//  HomeViewController.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import UIKit
import RxSwift
import SDWebImage
class HomeViewController: UIViewController {
    
    // MARK: - Variables -
    @IBOutlet weak var recommendedExpCollectionView: UICollectionView!
    @IBOutlet weak var mostRecentExpCollectionView: UICollectionView!
    
    let experienceViewModel: ExperienceViewModel = ExperienceViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Initialization -
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
        bindDataToTableView()
        bindDataToCollectionView()
    }
    
}

// MARK: - UI Style -
extension HomeViewController {
    private func setupUI() {
        setupMostRecentExpCollectionView()
        setupRecommenedExpCollectionView()
    }
}


// MARK: - Collection View Manegement -
extension HomeViewController {
    private func setupRecommenedExpCollectionView() {
        recommendedExpCollectionView.register(ExperienceCollectionViewCell.nib(),
                                              forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        recommendedExpCollectionView.delegate = self
    }
}

extension HomeViewController {
    private func setupMostRecentExpCollectionView() {
        mostRecentExpCollectionView.register(ExperienceCollectionViewCell.nib(),
                                              forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        mostRecentExpCollectionView.delegate = self
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recommendedExpCollectionView {
            return CGSize(width: recommendedExpCollectionView.frame.width, height: 250)
        } else if collectionView == mostRecentExpCollectionView {
            return CGSize(width: mostRecentExpCollectionView.frame.width, height: 250)
        }
        return CGSize.zero
    }
}


// MARK: - Collection View Scroll (Recommened Expo) -

extension HomeViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCellOnScreen()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCellOnScreen()
        }
    }

    private func centerCellOnScreen() {
        let centerPoint = CGPoint(x: recommendedExpCollectionView.contentOffset.x + recommendedExpCollectionView.bounds.width / 2,
                                  y: recommendedExpCollectionView.bounds.height / 2)
        if let indexPath = recommendedExpCollectionView.indexPathForItem(at: centerPoint) {
            recommendedExpCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - RxSwift - Collection View - Most Recent -

extension HomeViewController {
    func bindDataToTableView() {
        experienceViewModel.mostRecentExperinces
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: mostRecentExpCollectionView.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
                guard let self = self else {return}
                if let url = URL(string: row.coverPhoto ) {
                    cell.coverImage.sd_setImage(with: url)
                }
                cell.likesCountLabel.text = String(row.likesNo)
                cell.experienceTitleLabel.text = row.title
                cell.watchCountLabel.text = String(row.viewsNo)
                cell.likesButtonTapped = {
                    print("Likes Button Tapped")
                }
            }
            .disposed(by: disposeBag)
        
        mostRecentExpCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else {
                    return
                }
                let selectedExperience = experienceViewModel.experincesModel[indexPath.row]
                
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - RxSwift - CollectionView

extension HomeViewController {
    func bindDataToCollectionView() {
        experienceViewModel.recommendedExperiences
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: recommendedExpCollectionView.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
                guard let self = self else {return}
                if let url = URL(string: row.coverPhoto ) {
                    cell.coverImage.sd_setImage(with: url)
                }
                cell.likesCountLabel.text = String(row.likesNo)
                cell.experienceTitleLabel.text = row.title
                cell.watchCountLabel.text = String(row.viewsNo)
                cell.likesButtonTapped = {
                    print("Likes Button Tapped")
                }
            }
            .disposed(by: disposeBag)
        
        recommendedExpCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else {
                    return
                }
                let selectedExperience = experienceViewModel.experincesModel[indexPath.row]
                
            })
            .disposed(by: disposeBag)
    }
}

