//
//  AlbumDetailVC.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 25/01/2021.
//

import UIKit

class AlbumDetailVC: UIViewController {
    
    var album: Album?
    
    fileprivate var pictures: [Picture] = []
    
    /// Loader pour indiquer la récupération des données
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    fileprivate lazy var collection: UICollectionView = {
        let collection = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.register(PicutreCell.self, forCellWithReuseIdentifier: PicutreCell.reusableIdentifier)
        collection.delegate = self
        collection.dataSource = self
        collection.isHidden = true
        collection.backgroundColor = .clear
        return collection
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.App.grey
        
        self.view.addSubview(self.loader)
        self.view.addSubview(self.collection)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.loader.startAnimating()
        self.setupConstraints()
        self.fetchPictures()
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            
            self.collection.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collection.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.collection.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            self.collection.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        ])
    }
    
    fileprivate func fetchPictures() {
        
        func showFailAlert(_ error: Error? = nil) {
            let alert = UIAlertController(title: "Erreur de récupération", message: error?.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        guard let album = album,
              let url = URL(string: "https://jsonplaceholder.typicode.com/users/\(album.userId)/photos?albumId=\(album.id)")
        else {
            showFailAlert()
            return
        }
        
        if DiskTools.Pictures.picturesAreStored(album: album) {
            print("AlbumDetailVC " + #function + " from disk")
            self.loader.stopAnimating()
            self.loader.isHidden = true
            self.collection.isHidden = false
            self.pictures = DiskTools.Pictures.retrieve(album: album)
            self.collection.reloadData()
        } else {
            print("AlbumDetailVC " + #function + " from network")
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                if let data = data, error == nil {
                    do {
                        let jsonData = try JSONDecoder().decode([Picture].self, from: data)
                        strongSelf.pictures = jsonData
                        
                        DiskTools.Pictures.store(pictures: strongSelf.pictures, for: album)
                        
                        DispatchQueue.main.async {
                            strongSelf.loader.stopAnimating()
                            strongSelf.loader.isHidden = true
                            strongSelf.collection.isHidden = false
                            strongSelf.collection.reloadData()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            strongSelf.pictures = []
                            strongSelf.collection.reloadData()
                            showFailAlert(error)
                        }
                    }
                }
            }.resume()
        }
    }
}

extension AlbumDetailVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pictures.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let defaultCell = UICollectionViewCell()
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PicutreCell.reusableIdentifier, for: indexPath) as? PicutreCell {
            cell.picture = self.pictures[indexPath.row]
            cell.userId = self.album?.userId
            return cell
        }
        
        return defaultCell
    }
}

extension AlbumDetailVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 3
        let availableWidth = collectionView.frame.width
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
