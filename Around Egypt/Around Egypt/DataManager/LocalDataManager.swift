//
//  LocalDataManager.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 05/01/2024.
//

import Foundation
import RealmSwift
import UIKit
//import Differentiator

class LocalDataManager {
    private init() {}
    
    private static let sharedInstance = LocalDataManager()
    private let realm = try! Realm()

    static func shared() -> LocalDataManager {
        return LocalDataManager.sharedInstance
    }

    //MARK: - Convert From Api To Local -
    
    func convertFromApiToLocal(experience: Experience) -> LocalExperience {
        return LocalExperience(
            id: experience.id,
            title: experience.title,
            coverPhoto: experience.coverPhoto,
            localDescription: experience.description,
            viewsNo: experience.viewsNo,
            likesNo: experience.likesNo,
            address: experience.address,
            isLiked: false, //Just the first time it is Saved!
            recommended: experience.recommended
        )
    }
    
    //MARK: - Convert From Local To APi -
    
    func convertFromLocalToApi(localExperience: LocalExperience) -> Experience {
        return Experience(
            id: localExperience.id,
            title: localExperience.title,
            coverPhoto: localExperience.coverPhoto,
            description: localExperience.localDescription,
            viewsNo: localExperience.viewsNo,
            likesNo: localExperience.likesNo,
            address: localExperience.address,
            recommended: localExperience.recommended
        )
    }
    
    //MARK: - Cache Experience -
    
    func cacheExperiences(experiences: [Experience], completion: @escaping () -> Void) {
        let realm = try! Realm()
        
        for experience in experiences {
            let experienceID = experience.id
            let existingExperience = realm.object(ofType: LocalExperience.self, forPrimaryKey: experienceID)
            
            if let existing = existingExperience {
                let localExperience = convertFromApiToLocal(experience: experience)
                updateCachedExperienceIfNeeded(localExperience: localExperience, existingExperience: existing)
            } else {
                let localExperience = convertFromApiToLocal(experience: experience)
                
                try! realm.write {
                    realm.add(localExperience)
                }
            }
        }
        
        cacheImagesAsync(experiences: experiences) {
            completion()
        }
    }

    //MARK: - Cache Experience Images Async -
    
    func cacheImagesAsync(experiences: [Experience], completion: @escaping () -> Void) {
        let dispatchGroup = DispatchGroup()

        for experience in experiences {
            guard let imageURL = URL(string: experience.coverPhoto) else { continue }
            
            if let cachedImage = realm.object(ofType: CachedImage.self, forPrimaryKey: experience.id) {
                // Image already cached, no need to download again
                continue
            }

            dispatchGroup.enter()

            let task = URLSession.shared.dataTask(with: imageURL) { [weak self] data, _, error in
                defer {
                    dispatchGroup.leave()
                }

                guard let self = self else { return }

                if let imageData = data {
                    if let compressedImageData = UIImage(data: imageData)?.jpeg(.lowest) {
                        do {
                            let realm = try Realm()
                            let cachedImage = CachedImage()
                            cachedImage.id = experience.id
                            cachedImage.imageData = compressedImageData

                            try realm.write {
                                realm.add(cachedImage, update: .modified)
                            }
                        } catch {
                            print("Error updating Realm with compressed image data: \(error)")
                        }
                    } else {
                        print("Error compressing the image.")
                    }
                } else if let error = error {
                    print("Error downloading the image: \(error)")
                }
            }
            task.resume()
        }

        dispatchGroup.notify(queue: .main) {
            completion()
        }
    }
    
    //MARK: - update like info in cache -
    
    func likeExperience(experienceID: String) {
        let realm = try! Realm()
        
        if let experience = realm.object(ofType: LocalExperience.self, forPrimaryKey: experienceID) {
            do {
                try realm.write {
                    experience.isLiked = true
                    experience.likesNo += 1
                }
            } catch {
                print("Error updating like status: \(error)")
            }
        } else {
            print("Experience with ID \(experienceID) not found.")
        }
    }
    
    //MARK: - Update Likes, views And Recommended count from Api -
    
    func updateCachedExperienceIfNeeded(localExperience: LocalExperience, existingExperience: LocalExperience) {
        let realm = try! Realm()
        
        if localExperience.likesNo != existingExperience.likesNo || localExperience.viewsNo != existingExperience.viewsNo || localExperience.recommended != existingExperience.recommended {
            do {
                try realm.write {
                    existingExperience.likesNo = localExperience.likesNo
                    existingExperience.viewsNo = localExperience.viewsNo
                    existingExperience.recommended = localExperience.recommended
                }
            } catch {
                print("Error updating cached experience: \(error)")
            }
        }
    }


    //MARK: - check if Experience is Liked -
    
    func isExperienceLiked(experienceID: String) -> Bool {
        let realm = try! Realm()
        
        if let localExperience = realm.object(ofType: LocalExperience.self, forPrimaryKey: experienceID) {
            return localExperience.isLiked
        }
        
        return false 
    }
    
    //MARK: - Get All Cached Experiences -
    
    func getAllLocalExperiences() -> [LocalExperience] {
        let realm = try! Realm()
        let allLocalExperiences = realm.objects(LocalExperience.self)
        return Array(allLocalExperiences)
    }
        
    func getAllExperiences() -> [Experience] {
        let allLocalExperiences = getAllLocalExperiences()
        
        var allExperiences: [Experience] = []
        for localExperience in allLocalExperiences {
            let experience = convertFromLocalToApi(localExperience: localExperience)
            allExperiences.append(experience)
        }
        
        return allExperiences
    }
    
    //MARK: - Get A Single Experiences -
    
    func getExperienceByID(id: String) -> Experience? {
            let realm = try! Realm()
            if let localExperience = realm.object(ofType: LocalExperience.self, forPrimaryKey: id) {
                return convertFromLocalToApi(localExperience: localExperience)
            }
            return nil
        }
    
    //MARK: - Get All Recommended Experiences -
    
    func filterRecommendedExperiences(localExperiences: [LocalExperience]) -> [Experience] {
        let recommendedLocalExperiences = localExperiences.filter { $0.recommended == 1 }
        
        var recommendedExperiences: [Experience] = []
        for recommendedLocalExperience in recommendedLocalExperiences {
            let experience = convertFromLocalToApi(localExperience: recommendedLocalExperience)
            recommendedExperiences.append(experience)
        }
        
        return recommendedExperiences
    }
    
    //MARK: - Get All Cached Recommended Experiences From Realm -
    
    func getRecommendedExperiencesFromRealm() -> [Experience] {
        let realm = try! Realm()
        let localExperiences = realm.objects(LocalExperience.self).filter("recommended == 1")
        
        var recommendedExperiences: [Experience] = []
        for localExperience in localExperiences {
            let experience = convertFromLocalToApi(localExperience: localExperience)
            recommendedExperiences.append(experience)
        }
        
        return recommendedExperiences
    }
    
    //MARK: - Get All Cached Non Recommended Experiences From Realm -
    
    func getNonRecommendedExperiencesFromRealm() -> [Experience] {
        let realm = try! Realm()
        let localExperiences = realm.objects(LocalExperience.self).filter("recommended != 1")
        
        var nonRecommendedExperiences: [Experience] = []
        for localExperience in localExperiences {
            let experience = convertFromLocalToApi(localExperience: localExperience)
            nonRecommendedExperiences.append(experience)
        }
        
        return nonRecommendedExperiences
    }

    //MARK: - Get All Cached normal And Recommended Experiences -
    
    func getRecommendedAndAllExperiences() -> (recommended: [Experience], allLocal: [LocalExperience]) {
        let realm = try! Realm()
        let allLocalExperiences = realm.objects(LocalExperience.self)
        
        let allLocalExperiencesArray = Array(allLocalExperiences)
        let recommendedExperiences: [Experience] = filterRecommendedExperiences(localExperiences: allLocalExperiencesArray)
    
        return (recommendedExperiences, allLocalExperiencesArray)
    }

    //MARK: - Get All CachedImage Data -
    
    func getCachedImageDataFromRealm(withID id: String) -> Data? {
        let realm = try! Realm()
        if let cachedImage = realm.object(ofType: CachedImage.self, forPrimaryKey: id) {
            return cachedImage.imageData
        }
        return nil
    }


    func returnDataBaseURL() -> String {
        if let realmURL = Realm.Configuration.defaultConfiguration.fileURL {
            return ("Realm database URL: \(realmURL)")
        }
        return "Couldn't Find the Database"
    }

}



//    func cacheExperiences(experiences: [Experience], completion: @escaping () -> Void) {
//        let realm = try! Realm()
//        for experience in experiences {
//            let experienceID = experience.id
//            // Check if the experience with this ID is already cached
//            let existingExperience = realm.object(ofType: LocalExperience.self, forPrimaryKey: experienceID)
//
//            if existingExperience == nil {
//                // Experience not cached, convert and save to Realm
//                let localExperience = convertFromApiToLocal(experience: experience)
//
//                try! realm.write {
//                    realm.add(localExperience)
//                }
//            }
//        }
//        cacheImagesAsync(experiences: experiences) {
//            completion()
//        }
//    }


