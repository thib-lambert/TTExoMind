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
    
    var userId: Int? {
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
        
        self.contentView.addSubview(self.loader)
        self.contentView.addSubview(self.pictureImageView)
        
        NSLayoutConstraint.activate([
            self.loader.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.loader.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            
            self.pictureImageView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.pictureImageView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor),
            self.pictureImageView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            self.pictureImageView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor)
        ])
        
        self.fetchPicture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func fetchPicture() {
        guard let picture = self.picture,
              let url = URL(string: picture.thumbnailUrl),
              let userId = self.userId
        else { return }
        
        if DiskTools.Pictures.pictureIsStored(picture: picture, forUserId: userId) {
            self.pictureImageView.image = DiskTools.Pictures.retrieve(picture: picture, forUserId: userId)
        } else {
            URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let strongSelf = self,
                    let data = data,
                    error == nil
                else { return }
                
                let image = UIImage(data: data)
                DiskTools.Pictures.save(image, picture: picture, forUserId: userId)
                
                DispatchQueue.main.async {
                    strongSelf.pictureImageView.image = image
                }
            }.resume()
        }
    }
}
