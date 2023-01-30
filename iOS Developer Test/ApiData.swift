//
//  ApiData.swift
//  iOS Developer Test
//
//  Created by Motiur Rahaman on 2023-01-16.
//


import Foundation
struct ApiData: Codable {
    let lessons: [lession]
    
}
struct lession: Codable,Identifiable{
    let id: Int
    let name: String
    let description: String
    let thumbnail: String
    let video_url: String
}
