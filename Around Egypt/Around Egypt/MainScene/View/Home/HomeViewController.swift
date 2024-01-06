//
//  HomeProViewController.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 06/01/2024.
//

import UIKit
import RxSwift
import RxCocoa
import RxRelay
import SDWebImage
import SwiftUI

class HomeViewController: UIViewController {
    
    let homeUIView = HomeUIView()
    let experienceViewModel: ExperienceViewModel = ExperienceViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = homeUIView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        setupUI()
        bindDataToTableView()
        bindDataToCollectionView()
        setupSearchBar()
        updateLikesCountFromExperienceDetails()
        //            print(viewControllerView == self.view) // true
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
        homeUIView.recommendedExpCollectionView.register(ExperienceCollectionViewCell.nib(),
                                                            forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        homeUIView.recommendedExpCollectionView.delegate = self
    }
}

extension HomeViewController {
    private func setupMostRecentExpCollectionView() {
        homeUIView.mostRecentExpCollectionView.register(ExperienceCollectionViewCell.nib(),
                                                           forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        homeUIView.mostRecentExpCollectionView.delegate = self
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == homeUIView.recommendedExpCollectionView {
            return CGSize(width: homeUIView.recommendedExpCollectionView.frame.width, height: 250)
        } else if collectionView == homeUIView.mostRecentExpCollectionView {
            return CGSize(width: homeUIView.mostRecentExpCollectionView.frame.width, height: 250)
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
        let centerPoint = CGPoint(x: homeUIView.recommendedExpCollectionView.contentOffset.x + homeUIView.recommendedExpCollectionView.bounds.width / 2,
                                  y: homeUIView.recommendedExpCollectionView.bounds.height / 2)
        if let indexPath = homeUIView.recommendedExpCollectionView.indexPathForItem(at: centerPoint) {
            homeUIView.recommendedExpCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - RxSwift - Collection View - Most Recent -

extension HomeViewController {
    func bindDataToTableView() {
        experienceViewModel.mostRecentExperinces
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: homeUIView.mostRecentExpCollectionView.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
                guard let self = self else {return}
                experienceViewModel.checkNetworkConnection { success in
                    if success {
                        if let url = URL(string: row.coverPhoto) {
                            cell.coverImage.sd_setImage(with: url)
                        }
                    } else {
                        if let imageD = LocalDataManager.shared().getCachedImageDataFromRealm(withID: row.id) {
                            let uiImage = UIImage(data: imageD)
                            DispatchQueue.main.async {
                                cell.coverImage.image = uiImage
                            }
                        }
                    }
                }
                
                cell.experienceTitleLabel.text = row.title
                cell.watchCountLabel.text = String(row.viewsNo)
                
                //Manage Like Button
                let likesCount = LocalDataManager.shared().getExperienceByID(id: row.id)?.likesNo
                let isLiked = LocalDataManager.shared().isExperienceLiked(experienceID: row.id)
                
                cell.likesCountLabel.text = String(likesCount ?? row.likesNo)
                cell.likeButton.isChecked = isLiked
                cell.likeButton.isEnabled = !isLiked
                cell.likesButtonTapped = {
                    LocalDataManager.shared().likeExperience(experienceID: row.id)
                    self.experienceViewModel.likeAnExperience(experienceID: row.id)
                    self.homeUIView.mostRecentExpCollectionView.reloadData()
                    self.homeUIView.recommendedExpCollectionView.reloadData()
                }
                cell.accessibilityIdentifier = "ExperienceCell_\(row.id)"
            }
            .disposed(by: disposeBag)
        
        homeUIView.mostRecentExpCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else {
                    return
                }
                guard indexPath.row < experienceViewModel.experincesModel.count else {
                    return // Ensure index is within bounds
                }
                let selectedExperience = experienceViewModel.mostRecentExperinces.value[indexPath.row]
                
                showExperienceDetailsSheet(experience: selectedExperience)
                
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - RxSwift - CollectionView - Recommened -

extension HomeViewController {
    func bindDataToCollectionView() {
        experienceViewModel.recommendedExperiences
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: homeUIView.recommendedExpCollectionView.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
                guard let self = self else {return}
                experienceViewModel.checkNetworkConnection { success in
                    if success {
                        if let url = URL(string: row.coverPhoto ) {
                            cell.coverImage.sd_setImage(with: url)
                        }
                    } else {
                        if let imageD = LocalDataManager.shared().getCachedImageDataFromRealm(withID: row.id) {
                            let uiImage = UIImage(data: imageD)
                            DispatchQueue.main.async {
                                cell.coverImage.image = uiImage
                            }
                        }
                    }
                }
                cell.experienceTitleLabel.text = row.title
                cell.watchCountLabel.text = String(row.viewsNo)
                
                //Manage Like Button
                let likesCount = LocalDataManager.shared().getExperienceByID(id: row.id)?.likesNo
                let isLiked = LocalDataManager.shared().isExperienceLiked(experienceID: row.id)
                
                cell.likesCountLabel.text = String(likesCount ?? row.likesNo)
                cell.likeButton.isChecked = isLiked
                cell.likeButton.isEnabled = !isLiked
                cell.likesButtonTapped = {
                    LocalDataManager.shared().likeExperience(experienceID: row.id)
                    self.experienceViewModel.likeAnExperience(experienceID: row.id)
                    self.homeUIView.recommendedExpCollectionView.reloadData()
                    self.homeUIView.mostRecentExpCollectionView.reloadData()
                }
                
            }
            .disposed(by: disposeBag)
        
        homeUIView.recommendedExpCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else {
                    return
                }
                guard indexPath.row < experienceViewModel.experincesModel.count else {
                    return // Ensure index is within bounds
                }
                let selectedExperience = experienceViewModel.recommendedExperiences.value[indexPath.row]
                showExperienceDetailsSheet(experience: selectedExperience)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Setup Search Bar -

extension HomeViewController: UISearchBarDelegate  {
    private func setupSearchBar() {
        homeUIView.searchBar.delegate = self
        homeUIView.searchBar.backgroundImage = UIImage()
        
        if let textFieldInsideSearchBar = homeUIView.searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .black
            let placeholderText = "Try \"Luxor\""
            let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            textFieldInsideSearchBar.attributedPlaceholder = attributedPlaceholder
        }
        
        // Change the search icon (magnifying glass) color
        if let textFieldInsideSearchBar = homeUIView.searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = textFieldInsideSearchBar.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .gray
            }
        }
    }
}

//MARK: - Search Delegate -
extension HomeViewController  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Handle if searchbar is empty
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            searchBar.resignFirstResponder()
            homeUIView.verticalStackToBeHiddenWhenSearch.isHidden = false
            experienceViewModel.mostRecentExperinces.accept(experienceViewModel.experincesModel)
            return
        }
        
        homeUIView.scrollView.setContentOffset(CGPoint(x: 0, y: -homeUIView.scrollView.contentInset.top), animated: true)
        //Handle if searchbar if text are written
        experienceViewModel.mostRecentExperinces.accept([])
        homeUIView.verticalStackToBeHiddenWhenSearch.isHidden = true
        experienceViewModel.getSearchedExperinces(query: searchText)
        
    }
}

//MARK: - Very Very Simple coordiantor -

extension HomeViewController {
    func showExperienceDetailsSheet(experience: Experience) {
        let swiftUIController = UIHostingController(rootView: ExperienceDetails(experienceViewModel: experienceViewModel, experience: experience))
        present(swiftUIController, animated: true, completion: nil)
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("Sheet has been dismissed.")
    }
}

//MARK: - Refresh Tables -

extension HomeViewController {
    func updateLikesCountFromExperienceDetails() {
        experienceViewModel.updateLikeCount = { [weak self] in
            guard let self = self else {return}
            self.homeUIView.recommendedExpCollectionView.reloadData()
            self.homeUIView.mostRecentExpCollectionView.reloadData()
        }
    }
}
