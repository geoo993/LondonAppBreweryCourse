//
//  RxUIPageViewController+Ext.swift
//  StoryView
//
//  Created by Daniel Asher on 28/06/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import RxCocoa
import RxSwift

public extension Reactive where Base: UIPageViewController {

    /// Rx observable, on UINavigationController that triggers when topViewcontroller has changed.
    func setViewControllers(
        _ controllers: [UIViewController],
        direction: UIPageViewController.NavigationDirection = .forward,
        animated: Bool = true)
        -> Completable {
        return Completable.create { completable in
            self.base.setViewControllers(
                controllers, direction: direction, animated: animated, completion: { success in
                    completable(CompletableEvent.completed)
                }
            )
            return Disposables.create()
        }
    }
    func setViewController(_
        controller: UIViewController,
        direction: UIPageViewController.NavigationDirection = .forward,
        animated: Bool = true)
        -> Completable {
        return self.base.rx.setViewControllers([controller], direction: direction, animated: animated)
    }
}
