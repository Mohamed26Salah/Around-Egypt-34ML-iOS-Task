////
////  test.swift
////  Around Egypt
////
////  Created by Mohamed Salah on 05/01/2024.
////
//
//import Foundation
////
////  Experience.swift
////  Around Egypt
////
////  Created by Mohamed Salah on 04/01/2024.
////
//
//import Foundation
//
//// MARK: - Datum
//struct Experience: Codable {
//    var id: String
//    var title: String
//    var coverPhoto: String
//    var description: String
//    var viewsNo: Int
//    var likesNo: Int
//    
////    var recommended: Int
////    var hasVideo: Int
////    var tags: [City]
////    var city: City
////    var tourHTML: String
////    var famousFigure: String
////    var period: Era?
////    var era: Era?
////    var founded: String
////    var detailedDescription: String
//    
//    var address: String
//    
////    var gmapLocation: GmapLocation
////    var openingHours: OpeningHoursUnion
////    var translatedOpeningHours: TranslatedOpeningHours
////    var startingPrice: Int?
////    var ticketPrices: [TicketPrice]
////    var experienceTips: [JSONAny]
//    
//    var isLiked: JSONNull?
//    
////    var reviews: [JSONAny]
////    var rating: Int
////    var reviewsNo: Int
////    var audioURL: String
////    var hasAudio: Bool
//
//    enum CodingKeys: String, CodingKey {
//        case id = "id"
//        case title = "title"
//        case coverPhoto = "cover_photo"
//        case description = "description"
//        case viewsNo = "views_no"
//        case likesNo = "likes_no"
////        case recommended = "recommended"
////        case hasVideo = "has_video"
////        case tags = "tags"
////        case city = "city"
////        case tourHTML = "tour_html"
////        case famousFigure = "famous_figure"
////        case period = "period"
////        case era = "era"
////        case founded = "founded"
////        case detailedDescription = "detailed_description"
//        case address = "address"
////        case gmapLocation = "gmap_location"
////        case openingHours = "opening_hours"
////        case translatedOpeningHours = "translated_opening_hours"
////        case startingPrice = "starting_price"
////        case ticketPrices = "ticket_prices"
////        case experienceTips = "experience_tips"
//        case isLiked = "is_liked"
////        case reviews = "reviews"
////        case rating = "rating"
////        case reviewsNo = "reviews_no"
////        case audioURL = "audio_url"
////        case hasAudio = "has_audio"
//    }
//}
//
////// MARK: - City
////struct City: Codable {
////    var id: Int
////    var name: String
////    var disable: JSONNull?
////    var topPick: Int
////
////    enum CodingKeys: String, CodingKey {
////        case id = "id"
////        case name = "name"
////        case disable = "disable"
////        case topPick = "top_pick"
////    }
////}
////
////// MARK: - Era
////struct Era: Codable {
////    var id: String
////    var value: String
////    var createdAt: String
////    var updatedAt: String
////
////    enum CodingKeys: String, CodingKey {
////        case id = "id"
////        case value = "value"
////        case createdAt = "created_at"
////        case updatedAt = "updated_at"
////    }
////}
////
////// MARK: - GmapLocation
////struct GmapLocation: Codable {
////    var type: TypeEnum
////    var coordinates: [Double]
////
////    enum CodingKeys: String, CodingKey {
////        case type = "type"
////        case coordinates = "coordinates"
////    }
////}
////
////enum TypeEnum: String, Codable {
////    case point = "Point"
////}
////
////enum OpeningHoursUnion: Codable {
////    case anythingArray([JSONAny])
////    case openingHoursClass(OpeningHoursClass)
////
////    init(from decoder: Decoder) throws {
////        let container = try decoder.singleValueContainer()
////        if let x = try? container.decode([JSONAny].self) {
////            self = .anythingArray(x)
////            return
////        }
////        if let x = try? container.decode(OpeningHoursClass.self) {
////            self = .openingHoursClass(x)
////            return
////        }
////        throw DecodingError.typeMismatch(OpeningHoursUnion.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for OpeningHoursUnion"))
////    }
////
////    func encode(to encoder: Encoder) throws {
////        var container = encoder.singleValueContainer()
////        switch self {
////        case .anythingArray(let x):
////            try container.encode(x)
////        case .openingHoursClass(let x):
////            try container.encode(x)
////        }
////    }
////}
////
////// MARK: - OpeningHoursClass
////struct OpeningHoursClass: Codable {
////    var sunday: [String]
////    var monday: [String]
////    var tuesday: [String]
////    var wednesday: [String]
////    var thursday: [String]
////    var friday: [String]
////    var saturday: [String]
////
////    enum CodingKeys: String, CodingKey {
////        case sunday = "sunday"
////        case monday = "monday"
////        case tuesday = "tuesday"
////        case wednesday = "wednesday"
////        case thursday = "thursday"
////        case friday = "friday"
////        case saturday = "saturday"
////    }
////}
////
////// MARK: - TicketPrice
////struct TicketPrice: Codable {
////    var type: String
////    var price: Int
////
////    enum CodingKeys: String, CodingKey {
////        case type = "type"
////        case price = "price"
////    }
////}
////
////// MARK: - TranslatedOpeningHours
////struct TranslatedOpeningHours: Codable {
////    var sunday: FridayClass?
////    var monday: FridayClass?
////    var tuesday: FridayClass?
////    var wednesday: FridayClass?
////    var thursday: FridayClass?
////    var friday: FridayClass?
////    var saturday: FridayClass?
////
////    enum CodingKeys: String, CodingKey {
////        case sunday = "sunday"
////        case monday = "monday"
////        case tuesday = "tuesday"
////        case wednesday = "wednesday"
////        case thursday = "thursday"
////        case friday = "friday"
////        case saturday = "saturday"
////    }
////}
////
////// MARK: - FridayClass
////struct FridayClass: Codable {
////    var day: DayEnum
////    var time: String
////
////    enum CodingKeys: String, CodingKey {
////        case day = "day"
////        case time = "time"
////    }
////}
////
////enum DayEnum: String, Codable {
////    case friday = "Friday"
////    case monday = "Monday"
////    case saturday = "Saturday"
////    case sunday = "Sunday"
////    case thursday = "Thursday"
////    case tuesday = "Tuesday"
////    case wednesday = "Wednesday"
////}
//
//// MARK: - Meta
//struct Meta: Codable {
//    var code: Int
//    var errors: [JSONAny]
//
//    enum CodingKeys: String, CodingKey {
//        case code = "code"
//        case errors = "errors"
//    }
//}
//
//// MARK: - Pagination
//struct Pagination: Codable {
//}
//
//// MARK: - Encode/decode helpers
//
//class JSONNull: Codable, Hashable {
//
//    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
//        return true
//    }
//
//    public var hashValue: Int {
//        return 0
//    }
//
//    public func hash(into hasher: inout Hasher) {
//        // No-op
//    }
//
//    public init() {}
//
//    public required init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        if !container.decodeNil() {
//            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        var container = encoder.singleValueContainer()
//        try container.encodeNil()
//    }
//}
//
//class JSONCodingKey: CodingKey {
//    let key: String
//
//    required init?(intValue: Int) {
//        return nil
//    }
//
//    required init?(stringValue: String) {
//        key = stringValue
//    }
//
//    var intValue: Int? {
//        return nil
//    }
//
//    var stringValue: String {
//        return key
//    }
//}
//
//class JSONAny: Codable {
//
//    let value: Any
//
//    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
//        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
//        return DecodingError.typeMismatch(JSONAny.self, context)
//    }
//
//    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
//        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
//        return EncodingError.invalidValue(value, context)
//    }
//
//    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if container.decodeNil() {
//            return JSONNull()
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
//        if let value = try? container.decode(Bool.self) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self) {
//            return value
//        }
//        if let value = try? container.decode(Double.self) {
//            return value
//        }
//        if let value = try? container.decode(String.self) {
//            return value
//        }
//        if let value = try? container.decodeNil() {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer() {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
//        if let value = try? container.decode(Bool.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Int64.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(Double.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decode(String.self, forKey: key) {
//            return value
//        }
//        if let value = try? container.decodeNil(forKey: key) {
//            if value {
//                return JSONNull()
//            }
//        }
//        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
//            return try decodeArray(from: &container)
//        }
//        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
//            return try decodeDictionary(from: &container)
//        }
//        throw decodingError(forCodingPath: container.codingPath)
//    }
//
//    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
//        var arr: [Any] = []
//        while !container.isAtEnd {
//            let value = try decode(from: &container)
//            arr.append(value)
//        }
//        return arr
//    }
//
//    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
//        var dict = [String: Any]()
//        for key in container.allKeys {
//            let value = try decode(from: &container, forKey: key)
//            dict[key.stringValue] = value
//        }
//        return dict
//    }
//
//    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
//        for value in array {
//            if let value = value as? Bool {
//                try container.encode(value)
//            } else if let value = value as? Int64 {
//                try container.encode(value)
//            } else if let value = value as? Double {
//                try container.encode(value)
//            } else if let value = value as? String {
//                try container.encode(value)
//            } else if value is JSONNull {
//                try container.encodeNil()
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer()
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
//        for (key, value) in dictionary {
//            let key = JSONCodingKey(stringValue: key)!
//            if let value = value as? Bool {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Int64 {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? Double {
//                try container.encode(value, forKey: key)
//            } else if let value = value as? String {
//                try container.encode(value, forKey: key)
//            } else if value is JSONNull {
//                try container.encodeNil(forKey: key)
//            } else if let value = value as? [Any] {
//                var container = container.nestedUnkeyedContainer(forKey: key)
//                try encode(to: &container, array: value)
//            } else if let value = value as? [String: Any] {
//                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
//                try encode(to: &container, dictionary: value)
//            } else {
//                throw encodingError(forValue: value, codingPath: container.codingPath)
//            }
//        }
//    }
//
//    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
//        if let value = value as? Bool {
//            try container.encode(value)
//        } else if let value = value as? Int64 {
//            try container.encode(value)
//        } else if let value = value as? Double {
//            try container.encode(value)
//        } else if let value = value as? String {
//            try container.encode(value)
//        } else if value is JSONNull {
//            try container.encodeNil()
//        } else {
//            throw encodingError(forValue: value, codingPath: container.codingPath)
//        }
//    }
//
//    public required init(from decoder: Decoder) throws {
//        if var arrayContainer = try? decoder.unkeyedContainer() {
//            self.value = try JSONAny.decodeArray(from: &arrayContainer)
//        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
//            self.value = try JSONAny.decodeDictionary(from: &container)
//        } else {
//            let container = try decoder.singleValueContainer()
//            self.value = try JSONAny.decode(from: container)
//        }
//    }
//
//    public func encode(to encoder: Encoder) throws {
//        if let arr = self.value as? [Any] {
//            var container = encoder.unkeyedContainer()
//            try JSONAny.encode(to: &container, array: arr)
//        } else if let dict = self.value as? [String: Any] {
//            var container = encoder.container(keyedBy: JSONCodingKey.self)
//            try JSONAny.encode(to: &container, dictionary: dict)
//        } else {
//            var container = encoder.singleValueContainer()
//            try JSONAny.encode(to: &container, value: self.value)
//        }
//    }
//}
