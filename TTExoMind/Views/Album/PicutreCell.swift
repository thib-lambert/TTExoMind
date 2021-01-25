//
//  PicutreCell.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 25/01/2021.
//

import UIKit

class PicutreCell: UICollectionViewCell {
    
    static let reusableIdentifier = "PicutreCell"
    
    var picture: Picture? {
        didSet {
            self.fetchPicture()
        }
    }
    
    fileprivate lazy var pictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    lazy var loader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        return loader
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(self.pictureImageView)
        
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            self.pictureImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.pictureImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.pictureImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.pictureImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fetchPicture() {
        guard let urlPicture = self.picture?.thumbnailUrl, let url = URL(string: urlPicture) else { return }
        
        if Tools.imageIsAlreadySave(key: urlPicture) {
            self.pictureImageView.image = Tools.retrieveImage(key: urlPicture)
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let strongSelf = self else { return }
                
                if let data = data, error == nil {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data) {
                            strongSelf.pictureImageView.image = image
                            Tools.storeImage(image: image, key: urlPicture)
                        }
                    }
                }
            }.resume()
        }
    }
}
