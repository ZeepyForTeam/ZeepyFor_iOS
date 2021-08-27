//
//  KakaoResponse.swift
//  Zeepy
//
//  Created by JUEUN KIM on 2021/08/27.
//

import Foundation

// MARK: - ResponseKakaoAddressModel
struct ResponseKakaoAddressModel: Codable {
    let meta: KakaoMeta
    let documents: [KakaoDocument]
}

// MARK: - Document
struct KakaoDocument: Codable {
    let placeName, distance: String
    let placeURL: String
    let categoryName, addressName, roadAddressName, id: String
    let phone, categoryGroupCode, categoryGroupName, x: String
    let y: String

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case distance
        case placeURL = "place_url"
        case categoryName = "category_name"
        case addressName = "address_name"
        case roadAddressName = "road_address_name"
        case id, phone
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case x, y
    }
}

// MARK: - Meta
struct KakaoMeta: Codable {
    let sameName: KakaoSameName
    let pageableCount, totalCount: Int
    let isEnd: Bool

    enum CodingKeys: String, CodingKey {
        case sameName = "same_name"
        case pageableCount = "pageable_count"
        case totalCount = "total_count"
        case isEnd = "is_end"
    }
}

// MARK: - SameName
struct KakaoSameName: Codable {
    let region: [String]
    let keyword, selectedRegion: String

    enum CodingKeys: String, CodingKey {
        case region, keyword
        case selectedRegion = "selected_region"
    }
}

