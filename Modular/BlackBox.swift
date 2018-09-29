//
//  BlackBox.swift
//  Modular
//
//  Created by Christian Schnorr on 28.09.18.
//  Copyright © 2018 Christian Schnorr. All rights reserved.
//

import UIKit

//class BlackBox: UIView {
//
//    init(contentView: UIView) {
//        let frame = CGRect(origin: .zero, size: contentView.bounds.size)
//
//        super.init(frame: frame)
//
//        let constraint = self.heightAnchor.constraint(equalToConstant: 0)
//        constraint.priority = .defaultHigh
//        constraint.isActive = true
//
//        self.heightConstraint = constraint
//
//        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
//        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
//        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//    }
//
//    public override var frame: CGRect {
//        didSet {
//            print("frame changed")
//            if self.frame.width != oldValue.width {
//                self.effectiveWidthDidChange()
//            }
//        }
//    }
//
//    public override var bounds: CGRect {
//        didSet {
//            print("bounds changed")
//            if self.bounds.width != oldValue.width {
//                self.effectiveWidthDidChange()
//            }
//        }
//    }
//
//    private func effectiveWidthDidChange() {
//        let contentView = UIView()
//        let targetSize = CGSize(width: self.bounds.width, height: 0)
//        let preferredSize = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
//
//        // frame != alignment rect
//
//        self.heightConstraint.constant = preferredSize.height
//    }
//
//    var heightConstraint: NSLayoutConstraint! = nil
//}
