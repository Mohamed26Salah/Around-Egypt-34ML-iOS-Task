//
//  HomeProUIView.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 06/01/2024.
//

import Foundation
import SwiftUI
import UIKit

final class HomeUIView: UIView {
    
    //MARK: - Main Views Layout
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let searchView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let expereinceShowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Search View Layout
    
    private let searchHorizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let navigateView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let searchBarView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let filterView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let imageView: UIImageView = {
        let navigateImageView = UIImageView()
        navigateImageView.translatesAutoresizingMaskIntoConstraints = false
        return navigateImageView
    }()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.accessibilityIdentifier = "homeProUISearchBar"
        //        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "Try Luxor"
        return searchBar
    }()
    
    //MARK: - Experience View Layout -
    
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private let expereinceShowViewInsideScrollView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let verticalMainExperienceStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let verticalStackToBeHiddenWhenSearch: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .clear
        return stackView
    }()
    private let recentExperienceCollectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - stack To Be Hidden When Search View Layout -
    private let welcomeLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let welcomeDescriptionLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let recommenedExperienceLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let experienceHorizontalCollectionView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private let mostRecentLabelView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome!"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        //        label.applyLabelStyle(style: .Heading3, color: .black)
        return label
    }()
    let welcomeDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Now you can explore any experience in 360 degrees and get all the details about it all in one place."
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        //        label.applyLabelStyle(style: .BodyMediumMedium, color: .black)
        label.numberOfLines = 3
        label.lineBreakMode = .byWordWrapping
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()
    let recommenedExperienceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Recommended"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        //        label.applyLabelStyle(style: .Heading3, color: .black)
        return label
    }()
    let mostRecentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Most Recent"
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        //        label.applyLabelStyle(style: .Heading3, color: .black)
        return label
    }()
    let recommendedExpCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        // collectionView.register(YourCustomCell.self, forCellWithReuseIdentifier: "YourCustomCellReuseIdentifier")
        return collectionView
    }()
    
    //MARK: - Most Recent Expereience View Layout -
    
    let mostRecentExpCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        // collectionView.register(YourCustomCell.self, forCellWithReuseIdentifier: "YourCustomCellReuseIdentifier")
        return collectionView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupMainStackView()
        setupSearchHorizontalStackView()
        setupMainScrollView()
        setupMainVerticalStackInsideScrollView()
        setupVerticalStackToBeHidden()
        setupMostRecetCollectionView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

//MARK: - Main Views constrains

extension HomeUIView {
    private func setupMainStackView() {
        addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        stackView.addArrangedSubview(searchView)
        stackView.addArrangedSubview(expereinceShowView)
        searchView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
}

//MARK: - Search View constrains

extension HomeUIView {
    private func setupSearchHorizontalStackView() {
        searchView.addSubview(searchHorizontalStackView)
        
        NSLayoutConstraint.activate([
            searchHorizontalStackView.topAnchor.constraint(equalTo: searchView.topAnchor),
            searchHorizontalStackView.leadingAnchor.constraint(equalTo: searchView.leadingAnchor),
            searchHorizontalStackView.trailingAnchor.constraint(equalTo: searchView.trailingAnchor),
            searchHorizontalStackView.bottomAnchor.constraint(equalTo: searchView.bottomAnchor)
        ])
        
        searchHorizontalStackView.addArrangedSubview(navigateView)
        searchHorizontalStackView.addArrangedSubview(searchBarView)
        searchHorizontalStackView.addArrangedSubview(filterView)
        
        setupNavigateView()
        setupFilterView()
        setupSearchBar()
    }
    private func setupNavigateView() {
        navigateView.widthAnchor.constraint(equalTo: searchHorizontalStackView.widthAnchor, multiplier: 0.16).isActive = true
        let navigateImageView = UIImageView()
        navigateImageView.translatesAutoresizingMaskIntoConstraints = false
        navigateView.addSubview(navigateImageView)
        navigateImageView.image = UIImage(systemName: "line.horizontal.3")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        NSLayoutConstraint.activate([
            navigateImageView.centerXAnchor.constraint(equalTo: navigateView.centerXAnchor),
            navigateImageView.centerYAnchor.constraint(equalTo: navigateView.centerYAnchor),
            navigateImageView.widthAnchor.constraint(equalToConstant: 30),
            navigateImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    private func setupFilterView() {
        filterView.widthAnchor.constraint(equalTo: searchHorizontalStackView.widthAnchor, multiplier: 0.16).isActive = true
        let filterImageView = UIImageView()
        filterImageView.translatesAutoresizingMaskIntoConstraints = false
        filterView.addSubview(filterImageView)
        filterImageView.image = UIImage(named: "IconsFilter")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        
        NSLayoutConstraint.activate([
            filterImageView.centerXAnchor.constraint(equalTo: filterView.centerXAnchor),
            filterImageView.centerYAnchor.constraint(equalTo: filterView.centerYAnchor),
            filterImageView.widthAnchor.constraint(equalToConstant: 30),
            filterImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    private func setupSearchBar() {
        searchBarView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor)
        ])
    }
}

//MARK: - Experience View constrains
extension HomeUIView {
    private func setupMainScrollView() {
        addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: expereinceShowView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: expereinceShowView.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: expereinceShowView.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: expereinceShowView.bottomAnchor)
        ])
        
        scrollView.addSubview(expereinceShowViewInsideScrollView)
        
        let hconst = expereinceShowViewInsideScrollView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 2)
        hconst.isActive = true
        hconst.priority = UILayoutPriority(250)
        
        NSLayoutConstraint.activate([
            expereinceShowViewInsideScrollView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            expereinceShowViewInsideScrollView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            expereinceShowViewInsideScrollView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            expereinceShowViewInsideScrollView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            expereinceShowViewInsideScrollView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
//        scrollView.delegate = self
    }
    private func setupMainVerticalStackInsideScrollView() {
        expereinceShowViewInsideScrollView.addSubview(verticalMainExperienceStack)
        
        NSLayoutConstraint.activate([
            verticalMainExperienceStack.topAnchor.constraint(equalTo: expereinceShowViewInsideScrollView.topAnchor),
            verticalMainExperienceStack.leadingAnchor.constraint(equalTo: expereinceShowViewInsideScrollView.leadingAnchor),
            verticalMainExperienceStack.trailingAnchor.constraint(equalTo: expereinceShowViewInsideScrollView.trailingAnchor),
            verticalMainExperienceStack.bottomAnchor.constraint(equalTo: expereinceShowViewInsideScrollView.bottomAnchor)
        ])
        
        verticalMainExperienceStack.addArrangedSubview(spaceView)
        verticalMainExperienceStack.addArrangedSubview(verticalStackToBeHiddenWhenSearch)
        verticalMainExperienceStack.addArrangedSubview(recentExperienceCollectionView)
        
        spaceView.heightAnchor.constraint(equalToConstant: 10).isActive = true
        verticalStackToBeHiddenWhenSearch.heightAnchor.constraint(equalToConstant: 425).isActive = true
        
    }
}

//MARK: - Vertical Stack To Be Hidden View constrains (Horizontal Collection View) -

extension HomeUIView {
    private func setupVerticalStackToBeHidden() {
        
        verticalStackToBeHiddenWhenSearch.addArrangedSubview(welcomeLabelView)
        verticalStackToBeHiddenWhenSearch.addArrangedSubview(welcomeDescriptionLabelView)
        verticalStackToBeHiddenWhenSearch.addArrangedSubview(recommenedExperienceLabelView)
        verticalStackToBeHiddenWhenSearch.addArrangedSubview(experienceHorizontalCollectionView)
        verticalStackToBeHiddenWhenSearch.addArrangedSubview(mostRecentLabelView)
        
        welcomeLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        welcomeDescriptionLabelView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        recommenedExperienceLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mostRecentLabelView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        experienceHorizontalCollectionView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        
        setupWelcomeLabel()
        setupWelcomeDescriptionLabel()
        setupRecommendedLabel()
        setupRecommendedCollectionView()
        setupMostRecentLabel()
    }
    private func setupWelcomeLabel() {
        welcomeLabelView.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.leadingAnchor.constraint(equalTo: welcomeLabelView.leadingAnchor, constant: 15),
            welcomeLabel.trailingAnchor.constraint(equalTo: welcomeLabelView.trailingAnchor, constant: -15),
            welcomeLabel.topAnchor.constraint(equalTo: welcomeLabelView.topAnchor),
            welcomeLabel.bottomAnchor.constraint(equalTo: welcomeLabelView.bottomAnchor)
        ])
    }
    private func setupWelcomeDescriptionLabel() {
        welcomeDescriptionLabelView.addSubview(welcomeDescriptionLabel)
        
        NSLayoutConstraint.activate([
            welcomeDescriptionLabel.leadingAnchor.constraint(equalTo: welcomeDescriptionLabelView.leadingAnchor, constant: 15),
            welcomeDescriptionLabel.trailingAnchor.constraint(equalTo: welcomeDescriptionLabelView.trailingAnchor, constant: -15),
            welcomeDescriptionLabel.topAnchor.constraint(equalTo: welcomeDescriptionLabelView.topAnchor),
            welcomeDescriptionLabel.bottomAnchor.constraint(equalTo: welcomeDescriptionLabelView.bottomAnchor)
        ])
    }
    private func setupRecommendedLabel() {
        recommenedExperienceLabelView.addSubview(recommenedExperienceLabel)
        
        NSLayoutConstraint.activate([
            recommenedExperienceLabel.leadingAnchor.constraint(equalTo: recommenedExperienceLabelView.leadingAnchor, constant: 15),
            recommenedExperienceLabel.trailingAnchor.constraint(equalTo: recommenedExperienceLabelView.trailingAnchor, constant: -15),
            recommenedExperienceLabel.topAnchor.constraint(equalTo: recommenedExperienceLabelView.topAnchor),
            recommenedExperienceLabel.bottomAnchor.constraint(equalTo: recommenedExperienceLabelView.bottomAnchor)
        ])
    }
    private func setupRecommendedCollectionView() {
        experienceHorizontalCollectionView.addSubview(recommendedExpCollection)
        
        NSLayoutConstraint.activate([
            recommendedExpCollection.leadingAnchor.constraint(equalTo: experienceHorizontalCollectionView.leadingAnchor, constant: 15),
            recommendedExpCollection.trailingAnchor.constraint(equalTo: experienceHorizontalCollectionView.trailingAnchor, constant: -15),
            recommendedExpCollection.topAnchor.constraint(equalTo: experienceHorizontalCollectionView.topAnchor),
            recommendedExpCollection.bottomAnchor.constraint(equalTo: experienceHorizontalCollectionView.bottomAnchor)
        ])
    }
    private func setupMostRecentLabel() {
        mostRecentLabelView.addSubview(mostRecentLabel)
        
        NSLayoutConstraint.activate([
            mostRecentLabel.leadingAnchor.constraint(equalTo: mostRecentLabelView.leadingAnchor, constant: 15),
            mostRecentLabel.trailingAnchor.constraint(equalTo: mostRecentLabelView.trailingAnchor, constant: -15),
            mostRecentLabel.topAnchor.constraint(equalTo: mostRecentLabelView.topAnchor),
            mostRecentLabel.bottomAnchor.constraint(equalTo: mostRecentLabelView.bottomAnchor)
        ])
    }
}

//MARK: - Vertical Experience Collection View -

extension HomeUIView {
    private func setupMostRecetCollectionView() {
        recentExperienceCollectionView.addSubview(mostRecentExpCollection)
        NSLayoutConstraint.activate([
            mostRecentExpCollection.leadingAnchor.constraint(equalTo: recentExperienceCollectionView.leadingAnchor, constant: 15),
            mostRecentExpCollection.trailingAnchor.constraint(equalTo: recentExperienceCollectionView.trailingAnchor, constant: -15),
            mostRecentExpCollection.topAnchor.constraint(equalTo: recentExperienceCollectionView.topAnchor),
            mostRecentExpCollection.bottomAnchor.constraint(equalTo: recentExperienceCollectionView.bottomAnchor)
        ])
//        mostRecentExpCollection.delegate = self
    }
}



struct UIViewPreview: UIViewRepresentable {
    let build: () -> UIView
    init(_ build: @escaping () -> UIView) {
        self.build = build
    }
    
    func makeUIView(context: Context) -> some UIView {
        build()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) { }
}



struct PreviewViewController_Previews: PreviewProvider {
    
    static var previews: some View {
        UIViewPreview {
            HomeUIView()
        }
    }
}

