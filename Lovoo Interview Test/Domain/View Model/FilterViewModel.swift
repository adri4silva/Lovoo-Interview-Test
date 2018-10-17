//
//  FilterViewModel.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 16/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

// MARK: Protocols
protocol FilterViewModelInputs {
    var back: CocoaAction { get }
    func selectedCountry(_ country: String)
    func selectedCategory(_ category: String)
}

protocol FilterViewModelOutputs {
    var countries: BehaviorRelay<[String]> { get }
    var categories: BehaviorRelay<[String]> { get }
}

protocol FilterViewModelType {
    var inputs: FilterViewModelInputs { get }
    var outputs: FilterViewModelOutputs { get }
}

final class FilterViewModel {

    var countries = BehaviorRelay(value: ["ae", "ar", "at", "au", "be", "bg", "br", "ca", "ch", "cn", "co", "cu", "cz", "de", "eg", "fr", "gb", "gr", "hk", "hu", "id", "ie", "il", "in", "it", "jp", "kr", "lt", "lv", "ma", "mx", "my", "ng", "nl", "no", "nz", "ph", "pl", "pt", "ro", "rs", "ru", "sa", "se", "sg", "si", "sk", "th", "tr", "tw", "ua", "us", "ve", "za"])

    var categories = BehaviorRelay(value: ["business", "entertainment", "general", "health", "science", "sports", "technology"])

    private var country: BehaviorRelay<String>
    private var category: BehaviorRelay<String>

    private let coordinator: Coordinator

    init(coordinator: Coordinator, category: BehaviorRelay<String>, country: BehaviorRelay<String>) {
        self.coordinator = coordinator
        self.country = country
        self.category = category
    }

}

// MARK: - FilterViewModel Type
extension FilterViewModel: FilterViewModelType {
    var inputs: FilterViewModelInputs { return self }
    var outputs: FilterViewModelOutputs { return self }
}

// MARK: - FilterViewModel Inputs
extension FilterViewModel: FilterViewModelInputs {
    func selectedCountry(_ country: String) {
        self.country.accept(country)
    }

    func selectedCategory(_ category: String) {
        self.category.accept(category)
    }

    var back: CocoaAction {
        return CocoaAction {
            return self.coordinator.pop(animated: true)
                .asObservable()
                .map { _ in }
        }
    }
}

// MARK: - FilterViewModel Outputs
extension FilterViewModel: FilterViewModelOutputs {}
