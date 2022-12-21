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

enum ApiResultCharacter {
    case success(CharacterList)
    case failure(String)
}

class NetworkService  {
    static let shared = NetworkService()

    func getCharacters(page: Int, completion: @escaping(ApiResultCharacter) -> Void) {
        let urlString = "https://rickandmortyapi.com/api/character?page=\(page)"
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) {data, response, error in

                if let httpResponse = response as? HTTPURLResponse{
                    if httpResponse.statusCode == 200 {
                        if error != nil{
                            completion(.failure("Error \(String(describing: error))"))
                        }
                        if let data = data {
                            let decoder = JSONDecoder()
                          do {
                                let json: CharacterList = try decoder.decode(CharacterList.self, from: data)
                                completion(.success(json))
                            } catch let error {
                                completion(.failure(error.localizedDescription))
                            }
                        } else {
                          completion(.failure("Error data"))
                        }
                    } else if (400..<500).contains(httpResponse.statusCode) {
                        completion(.failure("\(httpResponse.statusCode)"))
                    }
                }
            }.resume()
        }
    }
}
