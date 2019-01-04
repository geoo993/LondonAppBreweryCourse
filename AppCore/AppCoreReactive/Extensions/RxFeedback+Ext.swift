//
//  RxFeedback+Ext.swift
//  StoryView
//
//  Created by Daniel Asher on 20/03/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//

import RxFeedback
import RxSwift

typealias Feedback<State, Event> = (ObservableSchedulerContext<State>) -> Observable<Event>
