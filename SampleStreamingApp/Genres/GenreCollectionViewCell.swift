//
//  GenreCollectionViewCell.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 2.06.21.
//

import UIKit

class GenreCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: GenreCollectionViewCell.self)

    let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(title)
        title.fillSuperview(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
