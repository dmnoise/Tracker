//
//  Observable.swift
//  Tracker
//
//  Created by Dmitriy Noise on 10.07.2025.
//

final class Observable<T> {
    var value: T {
        didSet { listener?(value) }
    }
    private var listener: ((T) -> Void)?
    init(_ value: T) { self.value = value }
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}
