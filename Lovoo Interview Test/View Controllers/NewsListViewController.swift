//
//  NewsListViewController.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 12/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class NewsListViewController: UIViewController {

    // Mark: - Constants
    enum Constants {
        static let columns: CGFloat = 1
        static let itemSpacing: CGFloat = 10
        static let itemHeight: CGFloat = 150
        static let cellName = "NewsCell"
    }

    // MARK: - Private properties
    private let viewModel: NewsListViewModelType
    private let disposeBag = DisposeBag()

    // MARK: - Initializers
    init(viewModel: NewsListViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components
    private lazy var collectionViewFlowLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        return layout
    }()

    private lazy var newsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(NewsCell.self, forCellWithReuseIdentifier: Constants.cellName)
        collectionView.backgroundColor = .white
        return collectionView
    }()

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .gray)
        spinner.startAnimating()
        return spinner
    }()

    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()

        setupCollectionView()

        collectionViewRxItems()

        collectionViewRxModelSelected()

        collectionViewRxWillDisplayCell()

        activityIndicatorRxIsAnimating()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        var filterButton = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: nil)
        filterButton.rx.action = viewModel.inputs.navigateToFilter
        navigationController?.navigationBar.topItem?.rightBarButtonItem = filterButton
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "News"
    }
}

// MARK: - Constraint Setup
private extension NewsListViewController {
    func setupUI() {
        view.addSubview(newsCollectionView)
        newsCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - CollectionView setup
private extension NewsListViewController {
    var collectionViewItemWidth: CGFloat {
        let viewWidth: CGFloat = view.frame.size.width
        let totalSpacing: CGFloat = (Constants.columns - 1) * Constants.itemSpacing

        return (viewWidth - totalSpacing) / Constants.columns
    }

    func setupCollectionView() {
        collectionViewFlowLayout.itemSize = CGSize(width: collectionViewItemWidth, height: collectionViewItemWidth)
        newsCollectionView.collectionViewLayout = collectionViewFlowLayout
        newsCollectionView.backgroundView = activityIndicator
    }

    func collectionViewRxModelSelected() {
        newsCollectionView.rx
            .itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                guard let self = self else { return }
                let item = self.viewModel.outputs.articles.value[indexPath.row]
                self.viewModel.inputs.navigateToDetail.execute(item)
            }).disposed(by: disposeBag)
    }

    func collectionViewRxWillDisplayCell() {
        newsCollectionView.rx
            .willDisplayCell
            .subscribe(onNext: { [weak self] cell, indexPath in
                guard let self = self else { return }
                let maxIndex = self.viewModel.outputs.articles.value.count - 1
                let currentIndex = indexPath.row
                guard maxIndex == currentIndex else { return }
                let pageSize = self.viewModel.inputs.pageSize.value + 5
                guard pageSize <= 20 else { return }
                self.viewModel.inputs.pageSize.accept(pageSize)
            })
            .disposed(by: disposeBag)
    }

    func collectionViewRxItems() {
        viewModel.outputs.articles
            .bind(to: newsCollectionView.rx.items(cellIdentifier: Constants.cellName, cellType: NewsCell.self))
            { [weak self] _, article, cell in
                self?.viewModel.outputs.spinnerActive.accept(false)
                cell.configure(with: article)
            }
            .disposed(by: disposeBag)
    }
}

// MARK: - Activty Indicator Rx
private extension NewsListViewController {
    func activityIndicatorRxIsAnimating() {
        viewModel.outputs.spinnerActive
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
    }
}
