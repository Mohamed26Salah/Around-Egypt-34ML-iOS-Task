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
        
        homeUIView.scrollView.delegate = self
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
        homeUIView.recommendedExpCollection.register(ExperienceCollectionViewCell.nib(),
                                                     forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        homeUIView.recommendedExpCollection.delegate = self
    }
}

extension HomeViewController {
    private func setupMostRecentExpCollectionView() {
        homeUIView.mostRecentExpCollection.register(ExperienceCollectionViewCell.nib(),
                                                    forCellWithReuseIdentifier: ExperienceCollectionViewCell.identifier)
        homeUIView.mostRecentExpCollection.delegate = self
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == homeUIView.recommendedExpCollection {
            return CGSize(width: homeUIView.recommendedExpCollection.frame.width, height: 250)
        } else if collectionView == homeUIView.mostRecentExpCollection {
            return CGSize(width: homeUIView.mostRecentExpCollection.frame.width, height: 250)
        }
        return CGSize.zero
    }
}


// MARK: - Collection View Scroll (Horizontal) -

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
        let centerPoint = CGPoint(x: homeUIView.recommendedExpCollection.contentOffset.x + homeUIView.recommendedExpCollection.bounds.width / 2,
                                  y: homeUIView.recommendedExpCollection.bounds.height / 2)
        if let indexPath = homeUIView.recommendedExpCollection.indexPathForItem(at: centerPoint) {
            homeUIView.recommendedExpCollection.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    // MARK: - Collection View Scroll (Vertical) -

    private func updateScrolling() {
        let collectionViewContentHeight = homeUIView.mostRecentExpCollection.collectionViewLayout.collectionViewContentSize.height
        
        // Adjust these values according to your desired scroll switching threshold
        let thresholdValue: CGFloat = 400
        let contentOffset = homeUIView.scrollView.contentOffset.y
        
        if  contentOffset >= thresholdValue && collectionViewContentHeight > homeUIView.mostRecentExpCollection.bounds.height {
            homeUIView.scrollView.isScrollEnabled = false
            homeUIView.mostRecentExpCollection.isScrollEnabled = true
        } else {
            homeUIView.scrollView.isScrollEnabled = true
            homeUIView.mostRecentExpCollection.isScrollEnabled = false
        }
    }
    
    internal func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == homeUIView.scrollView {
            updateScrolling()
        } else if let collectionView = scrollView as? UICollectionView, collectionView == homeUIView.mostRecentExpCollection {
            if collectionView.contentOffset.y <= 0 {
                homeUIView.scrollView.isScrollEnabled = true
                collectionView.isScrollEnabled = false
                
                // Scroll the main scroll view to a position inside the threshold
                let thresholdValue: CGFloat = 400
                let insideThresholdOffset = CGPoint(x: homeUIView.scrollView.contentOffset.x, y: thresholdValue - 1)
                homeUIView.scrollView.setContentOffset(insideThresholdOffset, animated: true)
            }
        }
    }
}

// MARK: - RxSwift - Collection View - Most Recent -

extension HomeViewController {
    func bindDataToTableView() {
        experienceViewModel.mostRecentExperinces
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: homeUIView.mostRecentExpCollection.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
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
                    self.homeUIView.mostRecentExpCollection.reloadData()
                    self.homeUIView.recommendedExpCollection.reloadData()
                }
                cell.accessibilityIdentifier = "ExperienceCell_\(row.id)"
            }
            .disposed(by: disposeBag)
        
        homeUIView.mostRecentExpCollection.rx.itemSelected
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
            .bind(to: homeUIView.recommendedExpCollection.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
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
                
                cell.likeButton.tintColor = .orangeHue
                cell.likesCountLabel.text = String(likesCount ?? row.likesNo)
                cell.likeButton.isChecked = isLiked
                cell.likeButton.isEnabled = !isLiked
                cell.likesButtonTapped = {
                    LocalDataManager.shared().likeExperience(experienceID: row.id)
                    self.experienceViewModel.likeAnExperience(experienceID: row.id)
                    self.homeUIView.recommendedExpCollection.reloadData()
                    self.homeUIView.mostRecentExpCollection.reloadData()
                }
                
            }
            .disposed(by: disposeBag)
        
        homeUIView.recommendedExpCollection.rx.itemSelected
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
            self.homeUIView.recommendedExpCollection.reloadData()
            self.homeUIView.mostRecentExpCollection.reloadData()
        }
    }
}



