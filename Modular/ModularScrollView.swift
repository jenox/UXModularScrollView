//
//  ModularScrollView.swift
//  Modular
//
//  Created by Christian Schnorr on 28.09.18.
//  Copyright © 2018 Christian Schnorr. All rights reserved.
//

import UIKit

class ModularScrollView<Module: UIView>: UIScrollView {

    // MARK: - Initialization

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.alwaysBounceVertical = true

        self.establishSubviewHiearchy()
        self.configureLayoutConstraints()
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }


    // MARK: - Module Management

    private let moduleSpacing: CGFloat = 10

    private(set) public var modules: [Module] = []

    // -> vertical layout constraints
    private var verticalSpacingConstraints: [NSLayoutConstraint] = []



    public func insertModule(_ module: Module, at index: Int) {
        precondition(0 <= index && index <= self.modules.count)
        precondition(!self.modules.contains(module))

        self.addSubview(module)

        module.translatesAutoresizingMaskIntoConstraints = false
        module.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor).isActive = true
        module.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor).isActive = true

        // Kill constraint connecting modules at indices `index - 1` and `index`
        self.verticalSpacingConstraints[index].isActive = false
        self.verticalSpacingConstraints.remove(at: index)

        let top: NSLayoutConstraint
        let bottom: NSLayoutConstraint

        if let previousModule = self.modules.prefix(index).last {
            top = module.topAnchor.constraint(equalTo: previousModule.bottomAnchor, constant: self.moduleSpacing)
        }
        else {
            top = module.topAnchor.constraint(equalTo: self.contentView.topAnchor)
        }

        if let nextModule = self.modules.dropFirst(index).first {
            bottom = nextModule.topAnchor.constraint(equalTo: module.bottomAnchor, constant: self.moduleSpacing)
        }
        else {
            bottom = self.contentView.bottomAnchor.constraint(equalTo: module.bottomAnchor)
        }

        NSLayoutConstraint.activate([
            top, bottom
        ])

        self.verticalSpacingConstraints.insert(top, at: index)
        self.verticalSpacingConstraints.insert(bottom, at: index + 1)

        self.modules.append(module)
    }

//    public func removeModule(at index: Int) {
//    }
//
//    public func insertModule(_ module: Module, above other: Module) {
//    }
//
//    public func insertModule(_ module: Module, below other: Module) {
//    }

    public func appendModule(_ module: Module) {
        self.insertModule(module, at: self.modules.count)
    }

//    public func removeAllModules() {
//    }



    // MARK: - Subview Management

    // replace with layout guide?
    fileprivate  let contentView: UIView = UIView()

    fileprivate func establishSubviewHiearchy() {
        self.addSubview(self.contentView)
    }

    fileprivate func configureLayoutConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true

        let constraint = self.contentView.topAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        constraint.isActive = true

        self.verticalSpacingConstraints = [constraint]

//        print(self.readableContentGuide.constraintsAffectingLayout(for: .horizontal))
//        let c = self.readableContentGuide.widthAnchor.constraint(lessThanOrEqualToConstant: 500)
//        c.priority = UILayoutPriority(1000)
//        c.isActive = true
//        print(self.readableContentGuide.constraintsAffectingLayout(for: .horizontal))
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        for module in self.modules {
            self.ensureIntegrity(of: module)
        }

        self.ensureIntegrity(of: self)
    }

    // observe subviews, so that if one is removed, we update constraints? (they get deactivated anyway but we'd keep reference)
    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)

//        if let module = subview as? Module, let index = self.modules.firstIndex(of: module) {
//            self.removeModule(at: index)
//        }
    }


    fileprivate func ensureIntegrity(of module: UIView) {
        if module.hasAmbiguousLayout {
            print("MODULE \(module) HAS AMBIGUOUS LAYOUT")
        }
    }
}
