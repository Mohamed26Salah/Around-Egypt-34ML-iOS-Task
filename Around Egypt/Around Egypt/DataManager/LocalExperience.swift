//
//  LocalExperience.swift
//  Around Egypt
//
//  Created by Mohamed Salah on 05/01/2024.
//

import Foundation
import RealmSwift

class LocalExperience: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var title: String
    @Persisted var coverPhoto: String
    @Persisted var localDescription: String
    @Persisted var viewsNo: Int
    @Persisted var likesNo: Int
    @Persisted var address: String
    @Persisted var isLiked: Bool
    @Persisted var recommended: Int
    
    convenience init(id: String, title: String, coverPhoto: String, localDescription: String, viewsNo: Int, likesNo: Int, address: String, isLiked: Bool, recommended: Int) {
        self.init()
        self.id = id
        self.title = title
        self.coverPhoto = coverPhoto
        self.localDescription = localDescription
        self.viewsNo = viewsNo
        self.likesNo = likesNo
        self.address = address
        self.isLiked = isLiked
        self.recommended = recommended
    }
}


// Realm CachedImage object class
class CachedImage: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var imageData: Data
}
