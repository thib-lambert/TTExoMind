//
//  ViewController.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 22/01/2021.
//

import UIKit

class ViewController: UIViewController {
    
    /// Liste des utilisateurs récupérés via l'appel réseau
    var users: [User] = []
    
    /// Liste des utilisateurs filtrés avec la recherche.
    var filteredUsers: [User] = []
    
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
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
        func showFailAlert(_ error: Error? = nil) {
            let alert = UIAlertController(title: "Erreur de récupération", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users") else {
            showFailAlert()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            if let data = data, error == nil {
                do {
                    let jsonData = try JSONDecoder().decode([User].self, from: data)
                    strongSelf.users = jsonData
                    
                    DispatchQueue.main.async {
                        strongSelf.loader.stopAnimating()
                        strongSelf.loader.isHidden = true
                        strongSelf.list.isHidden = false
                        strongSelf.list.users = strongSelf.users
                    }
                } catch {
                    DispatchQueue.main.async {
                        strongSelf.list.users = []
                        showFailAlert(error)
                    }
                }
            }
        }.resume()
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
    func userList(_ userList: UserList, didSelectUser: User) {
        let vc = UserDetailVC()
        vc.user = didSelectUser
        self.show(vc, sender: nil)
    }
}
