//
//  NetworkService.swift
//  Rick&Morty
//
//  Created by Dani on 2/11/22.
//

import Foundation

enum ApiResult {
    case success
    case failure
}

enum ApiError: Error {
    case invalidUrl
    case invalidResponse
    case invalidData
}

class NetworkService {
    static let shared = NetworkService()

    func getCharacters(page: Int, completion: @escaping (Result<CharacterList, Error>) -> Void) {
        let urlString = "https://rickandmortyapi.com/api/character?page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(ApiError.invalidUrl))
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                completion(.failure(ApiError.invalidResponse))
                return
            }

            guard let data = data else {
                completion(.failure(ApiError.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let characters = try decoder.decode(CharacterList.self, from: data)
                completion(.success(characters))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
