//
//  MovieModel.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 3.06.21.
//

import UIKit
import TMDBSwift

class MovieModel {
    let id: Int
    let name: String

    init(id: Int, title: String) {
        self.id = id
        self.name = title
    }

    func loadImage(completionClosure: @escaping (UIImage?) -> Void) {
        MovieMDB.images(movieID: id, language: "en") { [weak self] (_, images) in
            guard let imageFilePath = images?.posters.first?.file_path else { return }
            let imageFullPath = "https://image.tmdb.org/t/p/w500" + imageFilePath
            let url = URL(string: imageFullPath)!

            let request = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad)
            let task = URLSession.shared.dataTask(with: request) { (data, _, _) in
                if let _ = self,
                   let data = data,
                   let posterImage = UIImage(data: data) {

                    DispatchQueue.main.async {
                        completionClosure(posterImage)
                    }
                }
            }
            task.resume()
        }
    }
}
