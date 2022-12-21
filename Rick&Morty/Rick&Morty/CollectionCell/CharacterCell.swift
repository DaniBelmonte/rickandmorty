//
//  CharacterCell.swift
//  Rick&Morty
//
//  Created by Dani on 2/11/22.
//

import UIKit
import AlamofireImage

protocol CharacterCellDelegate {
    func showPermissionAlert()
    func showShareMenu(activityController: UIActivityViewController)
    func showToast(text: String)
}

class CharacterCell: UICollectionViewCell {

    // MARK: - Properties
    var delegate: CharacterCellDelegate?
    var character: Character?

    // MARK: - IBOutlets
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var viewStatus: UIView!
    @IBOutlet weak var button: UIButton!

    // MARK: - Life cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    // MARK: - Functions
    func setupUI() {
        viewStatus.layer.cornerRadius = viewStatus.frame.width/2
        button.showsMenuAsPrimaryAction = true
        button.menu = configurePopUpMenu()
    }

    func display(this character: Character) {
        self.character = character
        guard let characterImageURL = URL(string: character.image) else { return }
        characterImage.af.setImage(withURL: characterImageURL)
        idLabel.text = "#\(character.id)"
        nameLabel.text = character.name
        switch character.status {
        case "Alive":
            viewStatus.backgroundColor = .green
        case "Dead":
            viewStatus.backgroundColor = .red
        default:
            viewStatus.backgroundColor = .orange
        }
    }

    func configurePopUpMenu() -> UIMenu {
        let usersItem = UIAction(title: "Download Image", image: UIImage(systemName: "square.and.arrow.down")) { (action) in

            guard let image = self.characterImage.image else {
                return
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            self.delegate?.showPermissionAlert()
        }

        let shareItem = UIAction(title: "Share URL", image: UIImage(systemName: "square.and.arrow.up")) { (action) in
            let text = self.character?.image
            let textToShare = [ text ]
            let activityViewController = UIActivityViewController(activityItems: textToShare as [Any], applicationActivities: nil)
            self.delegate?.showShareMenu(activityController: activityViewController)
        }

        let copyClipboard = UIAction(title: "Copy", image: UIImage(systemName: "doc.on.doc")) { (action) in
            UIPasteboard.general.string = self.character?.name
            self.delegate?.showToast(text: "Copy successfully")
        }
        return UIMenu(title: "Menu", options: .displayInline, children: [usersItem, shareItem, copyClipboard])
    }
}
