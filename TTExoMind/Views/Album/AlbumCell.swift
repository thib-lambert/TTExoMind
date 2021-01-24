//
//  AlbumCell.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 24/01/2021.
//

import UIKit

class AlbumCell: UITableViewCell {
    
    static let reusableIdentifier = "AlbumCell"
    
    var album: Album? {
        didSet {
            self.titleLabel.text = album?.title
        }
    }
    
    fileprivate lazy var picture: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(named: "photo-album")
        return iv
    }()
    
    fileprivate lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        
        self.contentView.addSubview(self.picture)
        self.contentView.addSubview(self.titleLabel)
        
        self.setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupConstraints() {
        NSLayoutConstraint.activate([
            self.picture.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            self.picture.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 10),
            self.picture.widthAnchor.constraint(equalToConstant: 50),
            self.picture.heightAnchor.constraint(equalToConstant: 50),
            
            self.titleLabel.leadingAnchor.constraint(equalTo: self.picture.trailingAnchor, constant: 10),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.picture.bottomAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.picture.topAnchor)
        ])
    }
}
