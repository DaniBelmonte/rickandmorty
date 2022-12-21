//
//  ViewController.swift
//  Rick&Morty
//
//  Created by Dani on 2/11/22.
//

import UIKit
import Lottie
import Photos
import Toast

class HomeViewController: UIViewController {

    // MARK: - Properties
    var viewModel: HomeViewModel!
    var timer: Timer? = nil

    // MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var animationView: LottieAnimationView!

    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        getCharacters()
    }

    // MARK: - Selectors
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    @objc func filterCharacters() {
        filterSearchbarText()
    }

    // MARK: - Functions
    func setupUI() {
        animationView.loopMode = .loop
        animationView.play()
        viewModel = HomeViewModel()
        configureNotificationCenter()
        configureSearchBar()
        configureDismissKeyboard()
        configure(collectionView: collectionView)
    }

    func configureNotificationCenter() {
        NotificationCenter.default.removeObserver(self, name: Notification.Name("FilterCharacters"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filterCharacters), name: Notification.Name("FilterCharacters"), object: nil)
    }

    func configureDismissKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    func configureSearchBar() {
        searchBar.delegate = self
    }

    func showFailCallAlert() {
        let alert = UIAlertController(title: "Error", message: "Has an issue in api call", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    func filterSearchbarText() {
        DispatchQueue.main.async {
            let searchText = self.searchBar.text
            self.viewModel.characterListFiltered = []
            for character in self.viewModel.characterList.results {
                if character.name.uppercased().contains(searchText?.uppercased() ?? "") {
                    self.viewModel.characterListFiltered.append(character)
                } else if searchText == "" {
                    self.viewModel.characterListFiltered = self.viewModel.characterList.results
                }
            }
            self.collectionView.reloadData()
        }
    }

    // MARK: - Api call
    func getCharacters() {
        viewModel.getCharacters(this: 1, completion: { result in
            switch result {
            case .success:
                DispatchQueue.main.async { [self] in
                    filterSearchbarText()
                    self.collectionView.reloadData()
                    //TODO: sleep funtion is only to view Lottie Screen
                    sleep(2)
                    UIView.transition(with: animationView, duration: 0.4,
                                      options: .transitionCrossDissolve,
                                      animations: {
                        self.animationView.isHidden = true
                    })
                    self.animationView.stop()
                }
            case .failure:
                self.animationView.isHidden = true
                self.animationView.stop()
                self.showFailCallAlert()
            }
        })
    }
}

// MARK: - UISearchBarDelegate Extension
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.characterListFiltered = []
        for character in viewModel.characterList.results {
            if character.name.uppercased().contains(searchText.uppercased()) {
                viewModel.characterListFiltered.append(character)
            } else if searchText.isEmpty {
                viewModel.characterListFiltered = viewModel.characterList.results
            }
        }
        collectionView.reloadData()
    }
}

// MARK: - CharacterCellDelegate Extension
extension HomeViewController: CharacterCellDelegate {
    func showToast(text: String) {
        self.view.makeToast(text, duration: 1.0, position: .center)
    }

    func showShareMenu(activityController: UIActivityViewController) {
        activityController.popoverPresentationController?.sourceView = self.view
        activityController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        self.present(activityController, animated: true, completion: nil)
    }

    func showPermissionAlert() {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        if authStatus == .denied {
            let alert = UIAlertController(title: "Denied access", message: "Go to settings and allow permissions ", preferredStyle: .alert)
            let cancelaction = UIAlertAction(title: "Cancel", style: .default)
            let settingaction = UIAlertAction(title: "Settings", style: UIAlertAction.Style.default) { UIAlertAction in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url, options: [:], completionHandler: { _ in })
                }
            }
            alert.addAction(cancelaction)
            alert.addAction(settingaction)
            self.present(alert, animated: true, completion: nil)
        }
    }
}
