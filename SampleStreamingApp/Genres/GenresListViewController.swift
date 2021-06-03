//
//  GenresListViewController.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 2.06.21.
//

import UIKit
import Combine

class GenresListViewController: UIViewController {

    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 100, height: 100)

        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GenreCollectionViewCell.self, forCellWithReuseIdentifier: GenreCollectionViewCell.identifier)

        return collectionView
    }()

    var entities: [Genre] = [] {
        didSet {
            collectionView.reloadData()
        }
    }

    lazy var genresSubscriber: Subscribers.Assign<GenresListViewController, [Genre]> = {
        Subscribers.Assign(object: self, keyPath: \.entities)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        MovieBaseManager.shared.$genres.subscribe(genresSubscriber)

        view.addSubview(collectionView)
        collectionView.fillSuperview()
    }


}

extension UIView {
    func fillSuperview(insets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) {
        guard let superview = superview else { assert(false, "No superview"); return }

        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: insets.bottom),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right)
        ])
    }
}

extension GenresListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        entities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenreCollectionViewCell.identifier, for: indexPath)

        if let genreCell = cell as? GenreCollectionViewCell,
           entities.count > indexPath.row {
            genreCell.title.text = entities[indexPath.row].name
        }

        return cell
    }
}

extension GenresListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let genreViewController = MoviesViewController()
        guard entities.count > indexPath.row else { return }
        
        genreViewController.title = entities[indexPath.row].name
        navigationController?.pushViewController(genreViewController, animated: true)
    }
}
