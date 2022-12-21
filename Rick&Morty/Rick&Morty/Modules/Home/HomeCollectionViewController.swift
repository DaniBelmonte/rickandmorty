//
//  HomeCollectionViewController.swift
//  Rick&Morty
//
//  Created by Dani on 2/11/22.
//

import Foundation
import UIKit

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func configure(collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CharacterCell", bundle: nil), forCellWithReuseIdentifier: "CharacterCell")
    }


    // MARK: - Collection Delegate Functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.characterListFiltered.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CharacterCell", for: indexPath as IndexPath) as! CharacterCell
        cell.display(this: (viewModel.characterListFiltered[indexPath.row]))
        cell.layer.cornerRadius = 12
        cell.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc = UIStoryboard.init(name: "CharacterDetailViewController", bundle: Bundle.main).instantiateViewController(withIdentifier: "CharacterDetailViewController") as? CharacterDetailViewController else { return }
        vc.modalPresentationStyle = .pageSheet
        vc.character = viewModel.characterListFiltered[indexPath.row]
        self.present(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/2)-4, height: 204)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.page != 42 {
            if indexPath.row >= (viewModel.characterListFiltered.count)-5 {
                viewModel.page += 1
                viewModel.getCharacters(this: (viewModel.page)) { result in
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            collectionView.reloadData()
                        }
                    case .failure:
                        self.showFailCallAlert()
                    }
                }
            }
        }
    }
}
