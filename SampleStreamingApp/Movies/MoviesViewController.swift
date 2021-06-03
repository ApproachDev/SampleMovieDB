//
//  MoviesViewController.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 2.06.21.
//

import UIKit
import TMDBSwift

class MoviesViewController: UIViewController {
    private let isIphone = UIDevice.current.model == "iPhone"
    
    lazy var numberOfColumns = isIphone ? 2 : 4

    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let width = (UIScreen.main.bounds.width / CGFloat(numberOfColumns)) - 20.0
        layout.itemSize = CGSize(width: width, height: (width / 3) * 4)
        layout.minimumLineSpacing = 10.0
        layout.minimumInteritemSpacing = 10.0

        return layout
    }()

    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)

        return collectionView
    }()

    private var pagesFetched: Int = 0
    private var allItemsLoaded: Bool = false

    private var entities: [MovieMDB] = []

    override func loadView() {
        super.loadView()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.fillSuperview()

        fetchNextEntities()
    }

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    private func fetchNextEntities() {
        guard !allItemsLoaded else { return }
        if let genre = title {
            MovieBaseManager.shared.getMoviesFor(genre: genre, page: self.pagesFetched + 1) { [weak self] (movies) in
                guard let movies = movies else { self?.allItemsLoaded = true; return }

                guard let self = self else { return }


                var indexPaths: [IndexPath] = []
                (self.entities.count..<self.entities.count + movies.count).forEach { (index) in
                    indexPaths.append(IndexPath(row: index, section: 0))
                }


                if self.pagesFetched == 0 {
                    self.entities = movies
                } else {
                    self.entities.append(contentsOf: movies)

                    self.collectionView.performBatchUpdates {
                        self.collectionView.insertItems(at: indexPaths)
                    } completion: { (_) in
                    }
                }


                self.collectionView.reloadData()
                self.pagesFetched += 1
            }
        }
    }
}

extension MoviesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        entities.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath)

        if let genreCell = cell as? MovieCollectionViewCell,
           entities.count > indexPath.row {
            let model = MovieModel(id: entities[indexPath.row].id, title: entities[indexPath.row].title ?? "")
            genreCell.set(model: model)
        }

        if indexPath.row == entities.count - 1 {
            fetchNextEntities()
        }

        return cell
    }
}

extension MoviesViewController: UICollectionViewDelegate {}
