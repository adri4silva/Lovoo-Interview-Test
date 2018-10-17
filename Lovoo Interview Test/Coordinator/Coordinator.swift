//
//  Coordinator.swift
//  Lovoo Interview Test
//
//  Created by Adrián Silva on 16/10/2018.
//  Copyright © 2018 Adrián Silva. All rights reserved.
//

import RxSwift
import RxCocoa
import UIKit

class Coordinator {

    private var window: UIWindow

    private var currentViewController: UIViewController

    private var disposeBag = DisposeBag()

    static func actualViewController(for viewController: UIViewController) -> UIViewController {
        if let navigationController = viewController as? UINavigationController {
            return navigationController.viewControllers.first!
        } else {
            return viewController
        }
    }

    init(window: UIWindow) {
        self.window = window
        self.currentViewController = self.window.rootViewController!
    }

    @discardableResult
    func transition(to scene: UIViewController, type: SceneTransitionType) -> Completable {
        let subject = PublishSubject<Void>()
        switch type {
        case .modal(let animated):
            currentViewController.present(scene, animated: animated) {
                subject.onCompleted()
            }
            currentViewController = Coordinator.actualViewController(for: scene)

        case .push:
            guard let navigationController = currentViewController.navigationController else {
                fatalError("Can't push a view controller without a current navigation controller")
            }
            _ = navigationController.rx.delegate
                .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                .map { _ in }
                .bind(to: subject)
            navigationController.pushViewController(scene, animated: true)
            currentViewController = Coordinator.actualViewController(for: scene)

        case .root:
            currentViewController = Coordinator.actualViewController(for: scene)
            window.rootViewController = scene
            subject.onCompleted()
        }

        return subject
            .asObservable()
            .take(1)
            .ignoreElements()
    }

    @discardableResult
    func pop(animated: Bool) -> Observable<Void> {

        return Observable.create { [weak self] observer in
            guard let self = self else {
                observer.onCompleted()
                return Disposables.create()
            }
            if let presenter = self.currentViewController.presentingViewController {
                // dismiss a modal controller
                self.currentViewController.dismiss(animated: animated) {
                    self.currentViewController = Coordinator.actualViewController(for: presenter)
                    observer.onNext(())
                    observer.onCompleted()
                }
            } else if let navigationController = self.currentViewController.navigationController {
                // navigate up the stack
                // one-off subscription to be notified when pop complete
                _ = navigationController.rx.delegate
                    .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
                    .map { _ in }
                    .bind(to: observer)
                guard navigationController.popViewController(animated: animated) != nil else {
                    fatalError("can't navigate back from \(self.currentViewController)")
                }
                self.currentViewController = navigationController.viewControllers.last!
            } else {
                fatalError("Not a modal, no navigation controller: can't navigate back from \(self.currentViewController)")
            }
            return Disposables.create()
        }

    }
}
