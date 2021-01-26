//
//  ViewController.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 22/01/2021.
//

import UIKit

class ViewController: UIViewController {

    /// Liste des utilisateurs récupérés via l'appel réseau
    fileprivate var users: [User] = []

    /// Liste des utilisateurs filtrés avec la recherche.
    fileprivate var filteredUsers: [User] = []

    /// Loader pour indiquer la récupération des données
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()

    /// Liste des utilisateurs
    fileprivate lazy var list: UserList = {
        let list = UserList()
        list.translatesAutoresizingMaskIntoConstraints = false
        list.userDelegate = self
        return list
    }()

    /// SearchBar pour filtrer les utilisateurs
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .sentences
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        searchBar.placeholder = "Rechercher"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.App.grey
        self.title = "Utilisateurs"

        self.view.addSubview(self.loader)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.list)

        self.setupConstraints()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowNotification(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideNotification(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.list.isHidden = true
        self.loader.startAnimating()
        self.fetchUsers()
    }

    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),

            self.searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),

            self.list.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            self.list.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            self.list.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    fileprivate func fetchUsers() {

        if DiskTools.Users.usersAreStored {
            print("ViewController " + #function + " from disk")
            self.users = DiskTools.Users.retrieve()
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.list.isHidden = false
            self.list.users = self.users
        } else {
            guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else { return }
            print("ViewController " + #function + " from network")

            let task = AsyncTaskJson<[User]>(url: url)
            task.onPostExecute = { [weak self] (result, error) in
                guard let strongSelf = self else { return }

                func showData() {
                    strongSelf.loader.stopAnimating()
                    strongSelf.loader.isHidden = true
                    strongSelf.list.isHidden = false
                    strongSelf.list.users = strongSelf.users
                }

                if let error = error {
                    strongSelf.users = []
                    showData()

                    let alert = UIAlertController(title: "Erreur de récupération", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    strongSelf.present(alert, animated: true, completion: nil)
                } else if let result = result {
                    strongSelf.users = result

                    // Save all users in disk
                    DiskTools.Users.store(users: strongSelf.users)

                    // Create folder for each user
                    strongSelf.users.forEach {
                        $0.createFolder()
                    }

                    showData()
                }
            }
            task.execute()
        }
    }

    @objc fileprivate func keyboardWillShowNotification(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }

        self.list.contentInset.bottom = keyboardSize.height
    }

    @objc fileprivate func keyboardWillHideNotification(notification: Notification) {
        self.list.contentInset.bottom = 0
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // Filtrage des utilisateurs qui correspondent à la recherche dans les champs affichés
        self.filteredUsers = searchText.isEmpty ? self.users : self.users.filter {
            let allNames = [$0.name, $0.username, $0.email, $0.phone, $0.website]
            return allNames.filter { (name) -> Bool in
                return name.lowercased().contains(searchText.lowercased())
            }.count > 0
        }

        // Rechargement des données à afficher
        self.list.users = self.filteredUsers
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.list.users = self.users
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
}

extension ViewController: UserListDelegate {
    func userList(_ userList: UserList, didSelectUser user: User) {
        let viewController = UserDetailVC()
        viewController.user = user
        self.show(viewController, sender: nil)
    }
}
