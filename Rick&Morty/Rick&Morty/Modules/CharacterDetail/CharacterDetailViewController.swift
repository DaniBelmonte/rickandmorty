//
//  CharacterDetailViewController.swift
//  Rick&Morty
//
//  Created by Dani on 2/11/22.
//

import UIKit

class CharacterDetailViewController: UIViewController {

    // MARK: - Properties
    var character: Character? = nil

    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var speciesLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLabel.text = character?.name
        guard let characterImageURL = URL(string: character?.image ?? "") else { return }
        characterImage.af.setImage(withURL: characterImageURL)
        statusLabel.text = "State: \(character?.status ?? "")"
        genreLabel.text = "Gener: \(character?.gender ?? "")"
        let typeText = character?.type == "" ? "Type: Without type" : "Type: \(character?.type ?? "Without Type")"
        typeLabel.text = typeText
        speciesLabel.text = "Specie: \(character?.species ?? "")"

    }
}
