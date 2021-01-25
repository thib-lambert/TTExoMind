//
//  UserDetailVC.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 24/01/2021.
//

import Foundation
import UIKit

class UserDetailVC: UIViewController {
    
    var user: User? {
        didSet {
            self.userDetail.user = self.user
        }
    }
    
    fileprivate var albums: [Album] = []
    
    /// Loader pour indiquer la récupération des données
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    fileprivate lazy var list: AlbumList = {
        let list = AlbumList()
        list.isHidden = true
        list.translatesAutoresizingMaskIntoConstraints = false
        list.albumDelegate = self
        return list
    }()
    
    fileprivate lazy var userDetail: UserDetail = {
        let userVM = UserDetail()
        userVM.isHidden = true
        userVM.translatesAutoresizingMaskIntoConstraints = false
        return userVM
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.App.grey
        self.title = user?.name
        
        self.view.addSubview(self.loader)
        self.view.addSubview(self.list)
        self.view.addSubview(self.userDetail)
        
        self.setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loader.startAnimating()
        self.fetchAlbums()
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.userDetail.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            self.userDetail.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.userDetail.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
            self.list.topAnchor.constraint(equalTo: self.userDetail.bottomAnchor, constant: 10),
            self.list.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.list.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    fileprivate func fetchAlbums() {
        
        func showFailAlert(_ error: Error? = nil) {
            let alert = UIAlertController(title: "Erreur de récupération", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        guard let userId = user?.id else {
            showFailAlert()
            return
        }
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(userId)/albums") else {
            showFailAlert()
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
            guard let strongSelf = self else { return }
            if let data = data, error == nil {
                do {
                    let jsonData = try JSONDecoder().decode([Album].self, from: data)
                    strongSelf.albums = jsonData
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        strongSelf.loader.stopAnimating()
                        strongSelf.loader.isHidden = true
                        strongSelf.userDetail.isHidden = false
                        strongSelf.list.isHidden = false
                        strongSelf.list.albums = strongSelf.albums
                    }
                } catch {
                    DispatchQueue.main.async {
                        strongSelf.list.albums = []
                        showFailAlert(error)
                    }
                }
            }
        }.resume()
    }
}

extension UserDetailVC: AlbumListDelegate {
    func albumList(_ albumList: AlbumList, didSelectAlbum: Album) {
        let vc = AlbumDetailVC()
        vc.album = didSelectAlbum
        self.show(vc, sender: nil)
    }
}
