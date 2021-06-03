//
//  FileStorageManager.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 3.06.21.
//

import Foundation

class FileStorage {
    private let fileManager = FileManager.default
    private let fileName = "TMPGenresList"

    private func save(data: Data) {
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)

            try data.write(to: fileURL)
        } catch {
            print(error)
        }
    }

    private func read() -> Data? {
        do {
            let documentDirectory = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor:nil, create:false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            return try Data(contentsOf: fileURL)
        } catch {
            print(error)
        }

        return nil
    }
}

extension FileStorage: Cacher {
    func set(genres: [Genre]) {
        do {
            let cacheObject = CacheObject<Genre>(creationDate: Date(), genres: genres)
            let data = try JSONEncoder().encode(cacheObject)
            save(data: data)
        } catch {
            print(error)
        }
    }

    func getGenres() -> [Genre]? {
        do {
            if let data = read() {
                let cacheObject = try JSONDecoder().decode(CacheObject<Genre>.self, from: data)
                return cacheObject.genres
            }
        } catch {
            print(error)
        }

        return nil
    }
}
