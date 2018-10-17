//
//  ArticleDetailViewModel.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 16/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import RxCocoa
import Action
import RxSwift

// MARK: - Protocols
protocol ArticleDetailViewModelInputs {
    var back: CocoaAction { get }
}

protocol ArticleDetailViewModelOutputs {
    var title: String { get }
    var author: String { get }
    var imageUrl: URL { get }
    var content: String { get }
    var date: String { get }
}

protocol ArticleDetailViewModelType {
    var inputs: ArticleDetailViewModelInputs { get }
    var outputs: ArticleDetailViewModelOutputs { get }
}

// MARK: - ViewModel
final class ArticleDetailViewModel {

    private let coordinator: Coordinator
    private let unwrappedModel: ArticleUnwrapped

    init(coordinator: Coordinator, model: Article) {
        self.coordinator = coordinator
        self.unwrappedModel = ArticleUnwrapped(model: model)
    }
}

// MARK: - ArticleDetailViewModel type
extension ArticleDetailViewModel: ArticleDetailViewModelType {
    var inputs: ArticleDetailViewModelInputs { return self }
    var outputs: ArticleDetailViewModelOutputs { return self }
}

// MARK: - ArticleDetailViewModel outputs
extension ArticleDetailViewModel: ArticleDetailViewModelOutputs {
    var title: String {
        return unwrappedModel.title()
    }

    var author: String {
        return unwrappedModel.author()
    }

    var imageUrl: URL {
        return unwrappedModel.imageUrl()
    }

    var content: String {
        return unwrappedModel.content()
    }

    var date: String {
        return unwrappedModel.date()
    }
}

// MARK: - ArticleDetailViewModel inputs
extension ArticleDetailViewModel: ArticleDetailViewModelInputs {
    var back: CocoaAction {
        return CocoaAction { [weak self] in
            guard let self = self else { return Observable.just(())}
            return self.coordinator.pop(animated: true)
                .asObservable()
                .map { _ in }
        }
    }


}


