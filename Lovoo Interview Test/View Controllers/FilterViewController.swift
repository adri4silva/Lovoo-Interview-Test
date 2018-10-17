//
//  FilterViewController.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 16/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Action

enum CellType: Int {
    case country
    case category
    case date
}

class FilterViewController: UIViewController {

    // MARK: - Private properties
    private let disposeBag = DisposeBag()
    private var viewModel: FilterViewModelType

    // MARK: - Initializers
    init(viewModel: FilterViewModelType) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UI Components
    private lazy var countryPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    private lazy var categoryPicker: UIPickerView = {
        let picker = UIPickerView()
        return picker
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Select country:"
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var countryTextField: UITextField = {
        let textField = UITextField()
        textField.inputView = countryPicker
        textField.placeholder = "United States"
        textField.tintColor = .clear
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        textField.textAlignment = .right
        return textField
    }()

    private lazy var countryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [countryLabel, countryTextField])
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()

    private lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "Select category:"
        label.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return label
    }()

    private lazy var categoryTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "general"
        textField.inputView = categoryPicker
        textField.tintColor = .clear
        textField.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        textField.textAlignment = .right
        return textField
    }()

    private lazy var categoryStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryLabel, categoryTextField])
        stack.axis = .horizontal
        return stack
    }()

    private lazy var selectablesStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [countryStackView, categoryStackView])
        stack.axis = .vertical
        stack.spacing = 3
        stack.distribution = .equalSpacing
        return stack
    }()

    // MARK: - View lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        title = "Filter"

        setupUI()

        pickerViewRx()

        populatePicker()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        var backButton = UIBarButtonItem(image: UIImage.fontAwesomeIcon(name: .angleDown, style: .solid, textColor: .white, size: CGSize(width: 50, height: 50)), style: .done, target: self, action: nil)
        backButton.rx.action = viewModel.inputs.back
        navigationController?.navigationBar.topItem?.leftBarButtonItem = backButton
    }

}

// MARK: - UI Setups
private extension FilterViewController {
    func setupUI() {
        view.addSubview(selectablesStackView)
        selectablesStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(view.safeAreaLayoutGuide).inset(60)
            make.height.equalTo(100)
        }
    }
}

// MARK: - PickerView Setup
private extension FilterViewController {
    func pickerViewRx() {
        countryPicker.rx
            .modelSelected(String.self)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                guard let country = Locale.current.localizedString(forRegionCode: value[0]) else { return }
                self.viewModel.inputs.selectedCountry(value[0])
                self.countryTextField.text = country
            })
            .disposed(by: disposeBag)

        categoryPicker.rx
            .modelSelected(String.self)
            .subscribe(onNext: { [weak self] value in
                guard let self = self else { return }
                let category = value[0]
                self.viewModel.inputs.selectedCategory(category)
                self.categoryTextField.text = category
            })
            .disposed(by: disposeBag)

    }

    func populatePicker() {
        viewModel.outputs.countries
            .bind(to: countryPicker.rx.itemTitles) { row, country in
                return Locale.current.localizedString(forRegionCode: country)
            }
            .disposed(by: disposeBag)

        viewModel.outputs.categories
            .bind(to: categoryPicker.rx.itemTitles) { row, category in
                return category
            }
            .disposed(by: disposeBag)
    }

}
