//
//  HomeViewController.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 04/01/2024.
//

import UIKit
import RxSwift
import SDWebImage
import SwiftUI
class HomeViewController: UIViewController {
    
    // MARK: - Variables -
    @IBOutlet weak var recommendedExpCollectionView: UICollectionView!
    @IBOutlet weak var mostRecentExpCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var stackTobeHiddenWhenSearch: UIStackView!
    
    let experienceViewModel: ExperienceViewModel = ExperienceViewModel()
    let disposeBag = DisposeBag()
    
    // MARK: - Initialization -
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        setupUI()
        bindDataToTableView()
        bindDataToCollectionView()
        setupSearchBar()
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

extension HomeViewController {
    func bindDataToCollectionView() {
        experienceViewModel.recommendedExperiences
            .observe(on: MainScheduler.asyncInstance)
            .bind(to: recommendedExpCollectionView.rx.items(cellIdentifier: ExperienceCollectionViewCell.identifier, cellType: ExperienceCollectionViewCell.self)) { [weak self] _, row, cell in
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
        searchBar.delegate = self
        searchBar.backgroundImage = UIImage()
        
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
            textFieldInsideSearchBar.textColor = .black
            let placeholderText = "Try \"Luxor\""
            let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
            textFieldInsideSearchBar.attributedPlaceholder = attributedPlaceholder
        }
        
        // Change the search icon (magnifying glass) color
        if let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField {
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
            self.stackTobeHiddenWhenSearch.isHidden = false
            experienceViewModel.mostRecentExperinces.accept(experienceViewModel.experincesModel)
            return
        }
        
        //Handle if searchbar if text are written
        experienceViewModel.mostRecentExperinces.accept([])
        self.stackTobeHiddenWhenSearch.isHidden = true
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

extension HomeViewController {
    func showExperienceDetailsSheet(experience: Experience) {
        let swiftUIController = UIHostingController(rootView: ExperienceDetails(experienceViewModel: experienceViewModel, experience: experience))
        present(swiftUIController, animated: true, completion: nil)
    }
}
