//
//  MovieBaseManager.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 2.06.21.
//

import Foundation
import TMDBSwift
import Combine

class MovieBaseManager {
    static let shared = MovieBaseManager()
    static private let apiKey = "0b1a18e2b899d214aba36f03889b819e"

    private let cacher: Cacher = FileStorage()

    private init(){
        TMDBConfig.apikey = Self.apiKey


        if let cachedVersion = cacher.getGenres() {
            genres = cachedVersion
        } else {
            self.fetchAllGenres()
        }
    }


    @Published private(set) var genres: [Genre] = []

    private func fetchAllGenres() {
        GenresMDB.genres(listType: .movie, language: "en") { [weak self] (_, genres) in
            guard let genres = genres else { return }

            let genreWrappers = genres.map { Genre(id: $0.id, name: $0.name) }
            self?.genres = genreWrappers

            self?.cacher.set(genres: genreWrappers)
        }
    }

    func getMoviesFor(genre: String, page: Int, completionHandler: @escaping ([MovieMDB]?) -> ()) {
        DiscoverMDB.discover(discoverType: .movie, params: [//.with_genres(genre),
                                                            .page(page)]) { (responce, movies, _) in

            completionHandler(movies)
        }
    }
}

struct Genre: Codable {
    let id: Int?
    let name: String?
}
