//
//  AlbumList.swift
//  TTExoMind
//
//  Created by Thibaud Lambert on 24/01/2021.
//

import UIKit

protocol AlbumListDelegate: class {
    func albumList(_ albumList: AlbumList, didSelectAlbum album: Album)
}

class AlbumList: UITableView {

    weak var albumDelegate: AlbumListDelegate?

    /// Liste des utilisateurs récupérés via l'appel réseau
    var albums: [Album] = [] {
        didSet {
            self.reloadData()
        }
    }

    fileprivate lazy var listHeader: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.text = "Albums"
        label.textColor = .black
        label.sizeToFit()
        return label
    }()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        self.backgroundColor = UIColor.App.grey
        self.dataSource = self
        self.delegate = self
        self.register(AlbumCell.self, forCellReuseIdentifier: AlbumCell.reusableIdentifier)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Wrap content
        var frame = self.frame
        frame.size.height = self.contentSize.height
        self.frame = frame
    }
}

extension AlbumList: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albums.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let defaultCell = UITableViewCell()

        if let cell = tableView.dequeueReusableCell(withIdentifier: AlbumCell.reusableIdentifier) as? AlbumCell {
            cell.album = self.albums[indexPath.row]
            return cell
        }

        return defaultCell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "ALBUMS"
    }
}

extension AlbumList: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.albumDelegate?.albumList(self, didSelectAlbum: self.albums[indexPath.row])
    }
}
