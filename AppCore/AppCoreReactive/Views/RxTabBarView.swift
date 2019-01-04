//
//  RxTabBarView.swift
//  AppCoreReactive
//
//  Created by GEORGE QUENTIN on 03/01/2019.
//  Copyright © 2019 Geo Games. All rights reserved.
//

import AppCore
import RxCocoa
import RxSwift

public extension Reactive where Base: TabBarView {
 
    /// Bindable sink for `profileEmogi` property.
    public var profileEmogi: Binder<String> {
        return Binder(self.base) { view, emoji in
        view.profileEmogi = emoji
        }
    }
 }

