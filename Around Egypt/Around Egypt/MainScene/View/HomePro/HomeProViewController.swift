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

class HomeProViewController: UIViewController {
    
    let homeProUIView = HomeProUIView()
    let experienceViewModel: ExperienceViewModel = ExperienceViewModel()
    let disposeBag = DisposeBag()
    
    override func loadView() {
        self.view = homeProUIView
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
extension HomeProViewController {
    private func setupUI() {
        setupMostRecentExpCollectionView()
        setupRecommenedExpCollectionView()
    }
}


// MARK: - Collection View Manegement -
extension HomeProViewController {
    private func setupRecommenedExpCollectionView() {
        homeProUIView.recommendedExpCollectionView.register(ExperienceCollectionViewCell.nib(),
                                                            forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        homeProUIView.recommendedExpCollectionView.delegate = self
    }
}

extension HomeProViewController {
    private func setupMostRecentExpCollectionView() {
        homeProUIView.mostRecentExpCollectionView.register(ExperienceCollectionViewCell.nib(),
                                                           forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        homeProUIView.mostRecentExpCollectionView.delegate = self
    }
    
}

extension HomeProViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == homeProUIView.recommendedExpCollectionView {
            return CGSize(width: homeProUIView.recommendedExpCollectionView.frame.width, height: 250)
        } else if collectionView == homeProUIView.mostRecentExpCollectionView {
            return CGSize(width: homeProUIView.mostRecentExpCollectionView.frame.width, height: 250)
        }
        return CGSize.zero
    }
}


// MARK: - Collection View Scroll (Recommened Expo) -

extension HomeProViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        centerCellOnScreen()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            centerCellOnScreen()
        }
    }
    
    private func centerCellOnScreen() {
        let centerPoint = CGPoint(x: homeProUIView.recommendedExpCollectionView.contentOffset.x + homeProUIView.recommendedExpCollectionView.bounds.width / 2,
                                  y: homeProUIView.recommendedExpCollectionView.bounds.height / 2)
        if let indexPath = homeProUIView.recommendedExpCollectionView.indexPathForItem(at: centerPoint) {
            homeProUIView.recommendedExpCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
}

// MARK: - RxSwift - Collection View - Most Recent -

extension HomeProViewController {
    func bindDataToTableView() {
        experienceViewModel.mostRecentExperinces
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: homeProUIView.mostRecentExpCollectionView.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
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
                    self.homeProUIView.mostRecentExpCollectionView.reloadData()
                    self.homeProUIView.recommendedExpCollectionView.reloadData()
                }
                cell.accessibilityIdentifier = "ExperienceCell_\(row.id)"
            }
            .disposed(by: disposeBag)
        
        homeProUIView.mostRecentExpCollectionView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else {
                    return
                }
                guard indexPath.row < experienceViewModel.experincesModel.count else {
                    return // Ensure index is within bounds
                }
                let selectedExperience = experienceViewModel.experincesModel[indexPath.row]
                
                showExperienceDetailsSheet(experience: selectedExperience)
                
            })
            .disposed(by: disposeBag)
    }
    
}

// MARK: - RxSwift - CollectionView - Recommened -

extension HomeProViewController {
    func bindDataToCollectionView() {
        experienceViewModel.recommendedExperiences
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: homeProUIView.recommendedExpCollectionView.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
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
                    self.homeProUIView.recommendedExpCollectionView.reloadData()
                    self.homeProUIView.mostRecentExpCollectionView.reloadData()
                }
                
            }
            .disposed(by: disposeBag)
        
        homeProUIView.recommendedExpCollectionView.rx.itemSelected
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

extension HomeProViewController: UISearchBarDelegate  {
    private func setupSearchBar() {
        homeProUIView.searchBar.delegate = self
        homeProUIView.searchBar.backgroundImage = UIImage()
        
        if let textFieldInsideSearchBar = homeProUIView.searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .black
            let placeholderText = "Try \"Luxor\""
            let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            textFieldInsideSearchBar.attributedPlaceholder = attributedPlaceholder
        }
        
        // Change the search icon (magnifying glass) color
        if let textFieldInsideSearchBar = homeProUIView.searchBar.value(forKey: "searchField") as? UITextField {
            if let leftView = textFieldInsideSearchBar.leftView as? UIImageView {
                leftView.image = leftView.image?.withRenderingMode(.alwaysTemplate)
                leftView.tintColor = .gray
            }
        }
    }
}

//MARK: - Search Delegate -
extension HomeProViewController  {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //Handle if searchbar is empty
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            searchBar.resignFirstResponder()
            homeProUIView.verticalStackToBeHiddenWhenSearch.isHidden = false
            experienceViewModel.mostRecentExperinces.accept(experienceViewModel.experincesModel)
            return
        }
        
        //Handle if searchbar if text are written
        experienceViewModel.mostRecentExperinces.accept([])
        homeProUIView.verticalStackToBeHiddenWhenSearch.isHidden = true
        experienceViewModel.getSearchedExperinces(query: searchText)
    }
    //    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    //        searchBar.text = nil // Clear the search text
    //        searchBar.resignFirstResponder() // Dismiss the keyboard
    //        self.stackTobeHiddenWhenSearch.isHidden = false
    //        experienceViewModel.mostRecentExperinces.accept(experienceViewModel.experincesModel)
    //    }
}

//MARK: - Very Very Simple coordiantor -

extension HomeProViewController {
    func showExperienceDetailsSheet(experience: Experience) {
        let swiftUIController = UIHostingController(rootView: ExperienceDetails(experienceViewModel: experienceViewModel, experience: experience))
        present(swiftUIController, animated: true, completion: nil)
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("Sheet has been dismissed.")
    }
}

//MARK: - Refresh Tables -

extension HomeProViewController {
    func updateLikesCountFromExperienceDetails() {
        experienceViewModel.updateLikeCount = { [weak self] in
            guard let self = self else {return}
            self.homeProUIView.recommendedExpCollectionView.reloadData()
            self.homeProUIView.mostRecentExpCollectionView.reloadData()
        }
    }
}
