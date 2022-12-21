//
//  HomeViewModel.swift
//  Rick&Morty
//
//  Created by Dani on 2/11/22.
//

import Foundation

class HomeViewModel: NSObject {

    // MARK: - Properties
    var characterList: CharacterList = CharacterList(results: [])
    var characterListFiltered: [Character] = []
    let network = NetworkService.shared
    var page = 1

    // MARK: - Functions
    func getCharacters(this page: Int,  completion: @escaping(ApiResult) -> ())  {
        network.getCharacters(page: page) { result in
            switch result {
            case .success(let characterList):
                self.characterList.results.append(contentsOf: characterList.results)
                self.characterListFiltered = self.characterList.results
                NotificationCenter.default.post(name: Notification.Name("FilterCharacters"), object: nil)
                completion(.success)
            case .failure(_):
                completion(.failure)
            }
        }
    }

}
