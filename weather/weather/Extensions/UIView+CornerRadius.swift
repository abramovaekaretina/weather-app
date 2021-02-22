//
//  UIView+CornerRadius.swift
//  weather
//
//  Created by Ekaterina Abramova on 18.02.2021.
//

import Foundation
import UIKit

extension UIView {
    func setRadius(_ value: CGFloat) {
        self.layer.cornerRadius = value
    }
}
