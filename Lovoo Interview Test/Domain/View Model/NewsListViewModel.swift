//
//  NewsListViewModel.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 15/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

// MARK: - Protocols
protocol NewsListViewModelInputs {
    var navigateToDetail: Action<Article, Void> { get }
    var navigateToFilter: CocoaAction { get }
    var pageSize: BehaviorRelay<Int> { get }
}

protocol NewsListViewModelOutputs {
    var articles: BehaviorRelay<[Article]> { get }
    var spinnerActive: BehaviorRelay<Bool> { get }
} 

protocol NewsListViewModelType {
    var inputs: NewsListViewModelInputs { get }
    var outputs: NewsListViewModelOutputs { get }
}

final class NewsListViewModel {

    // MARK: - Public properties
    let articles: BehaviorRelay<[Article]> = BehaviorRelay(value: [])

    // MARK: - Private properties
    var pageSize = BehaviorRelay(value: 5)
    var spinnerActive: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    private let disposeBag = DisposeBag()
    private let client: NewsClient
    private let coordinator: Coordinator
    private let country = BehaviorRelay(value: "us")
    private let category = BehaviorRelay(value: "")

    // MARK: - Initializer
    init(coordinator: Coordinator, client: NewsClient) {
        self.client = client
        self.coordinator = coordinator

        Observable.combineLatest(country, category, pageSize)
            .distinctUntilChanged { $0 == $1 }
            .debounce(2, scheduler: MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.spinnerActive.accept(true) })
            .map { ArticlesRequest(country: $0, category: $1, pageSize: String($2)) }
            .flatMap { client.send(request: $0) }
            .map { $0.articles! }
            .bind(to: articles)
            .disposed(by: disposeBag)
    }
}

// MARK: - NewsListViewModel Type
extension NewsListViewModel: NewsListViewModelType {
    var inputs: NewsListViewModelInputs { return self }
    var outputs: NewsListViewModelOutputs { return self }
}

// MARK: - NewsListViewModel Inputs
extension NewsListViewModel: NewsListViewModelInputs {
    var navigateToFilter: CocoaAction {
        return CocoaAction {
            let settingsViewModel = FilterViewModel(coordinator: self.coordinator, category: self.category, country: self.country)
            let settingsViewController = FilterViewController(viewModel: settingsViewModel)
            let navigationController = UINavigationController(rootViewController: settingsViewController)
            return self.coordinator.transition(to: navigationController, type: .modal(true))
                .asObservable()
                .map { _ in }
        }
    }

    var navigateToDetail: Action<Article, Void> {
        return Action<Article, Void> { [weak self] article in
            guard let self = self else { return Observable.just(())}
            let detailViewModel = ArticleDetailViewModel(coordinator: self.coordinator, model: article)
            let detailViewController = ArticleDetailViewController(viewModel: detailViewModel)
            let navigationController = UINavigationController(rootViewController: detailViewController)
            return self.coordinator.transition(to: navigationController, type: .modal(true))
                .asObservable()
                .map { _ in }
        }
    }
}

// MARK: - NewsListViewModel Outputs
extension NewsListViewModel: NewsListViewModelOutputs {}
