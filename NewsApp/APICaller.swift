//
//  APICaller.swift
//  NewsApp
//
//  Created by Darrien Huntley on 2/25/22.
//

import Foundation

final class APICaller { // Object
    
    static let shared = APICaller()
    
    struct Constrants {
        static let topHeadLinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=9206d018912f4f3d9a9c426f2418a302")
    }
    
    private init() {}
    
    public func getTopStories(completion: @escaping (Result<[Article], Error>) -> Void) {
        guard let url = Constrants.topHeadLinesURL else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            } else if let data = data {
                do {
                    let result = try JSONDecoder().decode(APIResponse.self, from: data)
                    print("Articles: \(result.articles.count)")
                    
                    completion(.success(result.articles))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


// Models

struct APIResponse: Codable {
    let articles  : [Article]
}

