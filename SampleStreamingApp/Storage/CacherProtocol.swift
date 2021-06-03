//
//  CacherProtocol.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 3.06.21.
//

import Foundation

protocol Cacher {
    func set(genres: [Genre])
    func getGenres() -> [Genre]?
}

class CacheObject<T: Codable>: Codable {
    private let creationDate: Date
    let genres: [T]

    var isStale: Bool {
        creationDate.timeIntervalSinceNow < 24*60*60
    }

    init(creationDate: Date, genres: [T]) {
        self.creationDate = creationDate
        self.genres = genres
    }
}
