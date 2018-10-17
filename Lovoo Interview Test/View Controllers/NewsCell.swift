//
//  NewsCell.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 15/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit

final class NewsCell: UICollectionViewCell {

    // MARK: - UI Components
    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.placeholder())
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .white
        label.backgroundColor = .clear
        label.numberOfLines = 3
        return label
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 14)
        label.textColor = .gray
        label.backgroundColor = .clear
        return label
    }()

    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, authorLabel])
        stack.axis = .vertical
        stack.spacing = 2
        return stack
    }()

    private lazy var titleContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.7
        return view
    }()

    private lazy var cellContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = .gray
        return view
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleImageView.image = nil
        titleLabel.text = nil
        authorLabel.text = nil
    }
}

// MARK: - Setup UI
private extension NewsCell {
    func setupUI() {
        addSubview(cellContainerView)
        cellContainerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }

        cellContainerView.addSubview(titleImageView)
        titleImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        cellContainerView.addSubview(titleContainerView)
        titleContainerView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(12)
            make.height.equalTo(75)
        }

        titleContainerView.addSubview(titleStack)
        titleStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
    }
}

// MARK: - Configure cell with model
extension NewsCell {
    func configure(with model: Article) {
        let modelUnwrapped = ArticleUnwrapped(model: model)
        titleImageView.downloadedFrom(url: modelUnwrapped.imageUrl())
        titleLabel.text = modelUnwrapped.title()
        authorLabel.text = modelUnwrapped.author()
    }
}
