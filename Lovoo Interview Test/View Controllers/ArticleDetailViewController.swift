//
//  ArticleDetailViewController.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 16/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import FontAwesome

class ArticleDetailViewController: UIViewController {

    // MARK: - Private properties
    private let viewModel: ArticleDetailViewModelType

    // MARK: - Initializers
    init(viewModel: ArticleDetailViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components
    private lazy var articleImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage.placeholder())
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .black
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

    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.light)
        label.textColor = .black
        label.backgroundColor = .clear
        return label
    }()

    private lazy var titleDescriptionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorLabel, dateLabel])
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    private lazy var titleStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [titleLabel, titleDescriptionStackView])
        stack.axis = .vertical
        return stack
    }()

    private lazy var contentTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .justified
        textView.dataDetectorTypes = .link
        textView.isSelectable = false
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        return textView
    }()

    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        bindModelWithView()

        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let backImage = UIImage.fontAwesomeIcon(name: .angleDown, style: .solid, textColor: .white, size: CGSize(width: 50, height: 50))
        var backButton = UIBarButtonItem(image: backImage, style: .done, target: self, action: nil)
        backButton.rx.action = viewModel.inputs.back
        navigationController?.navigationBar.topItem?.leftBarButtonItem = backButton
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.view.backgroundColor = .clear
    }
}

// MARK: - UI Setup
private extension ArticleDetailViewController {
    func setupUI() {
        view.addSubview(articleImageView)
        articleImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
        }

        view.addSubview(titleStackView)
        titleStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(articleImageView.snp.bottom).offset(16)
            make.height.equalTo(105)
        }

        view.addSubview(contentTextView)
        contentTextView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(16)
            make.top.equalTo(titleStackView.snp.bottom).offset(50)
        }
    }
}

// MARK: - ViewModel Bindings
private extension ArticleDetailViewController {
    func bindModelWithView() {
        articleImageView.downloadedFrom(url: viewModel.outputs.imageUrl)
        titleLabel.text = viewModel.outputs.title
        authorLabel.text = viewModel.outputs.author
        contentTextView.text = viewModel.outputs.content
        dateLabel.text = viewModel.outputs.date
    }
}
