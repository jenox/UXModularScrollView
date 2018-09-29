//
//  FancyHeightFunction.swift
//  Modular
//
//  Created by Christian Schnorr on 28.09.18.
//  Copyright © 2018 Christian Schnorr. All rights reserved.
//

import UIKit


class FancyHeightFunction: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        let constraint = self.heightAnchor.constraint(equalToConstant: 0)
        constraint.isActive = true

        self.heightConstraint = constraint

        self.backgroundColor = .red

        self.updateHeightConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override var frame: CGRect {
        didSet {
            print("frame")
            if self.frame.width != oldValue.width {
                self.updateHeightConstraint()
            }
        }
    }

    override var bounds: CGRect {
        didSet {
            print("bounds")
            if self.bounds.width != oldValue.width {
                self.updateHeightConstraint()
            }
        }
    }

    func updateHeightConstraint() {
        self.heightConstraint?.constant = 100000 / self.bounds.width
    }

    var heightConstraint: NSLayoutConstraint! = nil
}
