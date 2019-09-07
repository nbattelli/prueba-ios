//
//  MovieRepository.swift
//  rappi-ios
//
//  Created by Nicolas Battelli on 05/09/2019.
//  Copyright © 2019 Nicolas Battelli. All rights reserved.
//

import Foundation

final class MovieRepository {
    static let fileManager = FileManager()
    
    static func saveMoviesToDisk(category: MoviesCategory, movies: MovieListViewModel?) {
        guard let movies = movies else {return}
        let url = self.getDocumentsURL().appendingPathComponent(category.fileName())
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(movies)
            if fileManager.fileExists(atPath: url.path) {
                try fileManager.removeItem(at: url)
            }
            fileManager.createFile(atPath: url.path, contents: data, attributes: nil)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    static func getMoviesFromDisk(category: MoviesCategory) -> MovieListViewModel? {
        let url = getDocumentsURL().appendingPathComponent(category.fileName())
        
        if !fileManager.fileExists(atPath: url.path) {
            return nil
        }
        
        if let data = fileManager.contents(atPath: url.path) {
            let decoder = JSONDecoder()
            do {
                let movies = try decoder.decode(MovieListViewModel.self, from: data)
                return movies
            } catch {
                return nil
            }
        } else {
            fatalError("No data retrieved from file")
        }
    }
    
    private static func getDocumentsURL() -> URL {
        if let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            return url
        } else {
            fatalError("Could not retrieve documents directory")
        }
    }
}
