//
//  MovieCollectionViewCell.swift
//  SampleStreamingApp
//
//  Created by Vadim Zhuk on 3.06.21.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = String(describing: MovieCollectionViewCell.self)

    private var model: MovieModel?

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        imageView.fillSuperview()
        contentView.addSubview(title)
        title.fillSuperview(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        title.addShadow()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if imageView.image != nil {
            imageView.image = nil
        }

        model = nil
    }

    func set(model: MovieModel) {
        self.model = model
        self.title.text = model.name

        model.loadImage { (image) in
            self.imageView.image = image
        }
    }
}

private extension UILabel {
    func addShadow() {
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1.0
        layer.masksToBounds = false
        layer.shouldRasterize = true
        layer.shadowColor = UIColor.white.cgColor
        layer.shadowRadius = 5
    }
}
