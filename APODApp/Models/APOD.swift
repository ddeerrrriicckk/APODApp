//
//  APOD.swift
//  APODApp
//
//

import Foundation

struct APOD: Codable {
    let date: String
    let title: String
    let explanation: String
    let url: String
    let hdurl: String?
    let media_type: String
    let copyright: String?

    enum CodingKeys: String, CodingKey {
        case date
        case title
        case explanation
        case url
        case hdurl
        case media_type
        case copyright
    }
}
