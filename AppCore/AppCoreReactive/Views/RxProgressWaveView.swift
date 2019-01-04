//
//  RxProgressWaveView.swift
//  AppCoreReactive
//
//  Created by GEORGE QUENTIN on 04/01/2019.
//  Copyright © 2019 Geo Games. All rights reserved.
//

import AppCore
import RxCocoa
import RxSwift


extension Reactive where Base : ProgressWaveView {
    
    /// Bindable sink for `progress` property.
    public var progress: Binder<Double> {
        return Binder(self.base) { view, progress in
            view.progress = progress
        }
    }
}
