//
//  Observable.swift
//  weather
//
//  Created by Ekaterina Abramova on 01.01.2021.
//

import Foundation

class Observable<T> {

    var value: T {
        didSet {
            listener?(value)
        }
    }

    private var listener: ((T) -> ())?

    init(_ value: T) {
        self.value = value
    }

    func bind(_ handler: @escaping ((T) -> ())) {
        listener = handler
    }
}
