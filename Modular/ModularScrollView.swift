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

    // TODO: header, footer view

    fileprivate var paddingAtTopEdgeConstraint: NSLayoutConstraint! = nil
    fileprivate var paddingAtLeadingEdgeConstraint: NSLayoutConstraint! = nil
    fileprivate var paddingAtTrailingEdgeConstraint: NSLayoutConstraint! = nil
    fileprivate var paddingAtBottomEdgeConstraint: NSLayoutConstraint! = nil

//    let top = self.paddingAtTopEdgeConstraint.constant
//    let left = self.paddingAtLeadingEdgeConstraint.constant
//    let right = self.paddingAtTrailingEdgeConstraint.constant
//    let bottom = self.paddingAtBottomEdgeConstraint.constant
//
//    return UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)

    public var padding: UIEdgeInsets = .zero {
        didSet {
            self.paddingAtTopEdgeConstraint.constant = fmax(self.padding.top, 0)
            self.paddingAtLeadingEdgeConstraint.constant = fmax(self.padding.left, 0)
            self.paddingAtTrailingEdgeConstraint.constant = fmax(self.padding.right, 0)
            self.paddingAtBottomEdgeConstraint.constant = fmax(self.padding.bottom, 0)
        }
    }

    public var maximumModuleWidth: CGFloat? = nil {
        didSet {}
    }

    private let moduleSpacing: CGFloat = 10

    private(set) public var modules: [Module] = []

    // -> vertical layout constraints
    private var verticalSpacingConstraints: [NSLayoutConstraint] = []



    public func insertModule(_ module: Module, at index: Int) {
        precondition(0 <= index && index <= self.modules.count)
        precondition(!self.modules.contains(module))

        self.contentView.addSubview(module)

        module.translatesAutoresizingMaskIntoConstraints = false
        module.leadingAnchor.constraint(equalTo: self.moduleLayoutGuide.leadingAnchor).isActive = true
        module.trailingAnchor.constraint(equalTo: self.moduleLayoutGuide.trailingAnchor).isActive = true

        // Kill constraint connecting modules at indices `index - 1` and `index`
        self.verticalSpacingConstraints[index].isActive = false
        self.verticalSpacingConstraints.remove(at: index)

        let top: NSLayoutConstraint
        let bottom: NSLayoutConstraint

        if let previousModule = self.modules.prefix(index).last {
            top = module.topAnchor.constraint(equalTo: previousModule.bottomAnchor, constant: self.moduleSpacing)
        }
        else {
            top = module.topAnchor.constraint(equalTo: self.moduleLayoutGuide.topAnchor)
        }

        if let nextModule = self.modules.dropFirst(index).first {
            bottom = nextModule.topAnchor.constraint(equalTo: module.bottomAnchor, constant: self.moduleSpacing)
        }
        else {
            bottom = self.moduleLayoutGuide.bottomAnchor.constraint(equalTo: module.bottomAnchor)
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

    public let contentView: UIView = UIView()
    public let moduleLayoutGuide: UILayoutGuide = UILayoutGuide()

    fileprivate func establishSubviewHiearchy() {
        self.addSubview(self.contentView)
        self.addLayoutGuide(self.moduleLayoutGuide)
    }

    fileprivate func configureLayoutConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        self.contentView.backgroundColor = UIColor.yellow

        NSLayoutConstraint.activate([
            self.moduleLayoutGuide.topAnchor.constraint(equalTo: self.contentView.topAnchor).save(to: &self.paddingAtTopEdgeConstraint),
            self.moduleLayoutGuide.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.leadingAnchor).save(to: &self.paddingAtLeadingEdgeConstraint),
            self.contentView.trailingAnchor.constraint(greaterThanOrEqualTo: self.moduleLayoutGuide.trailingAnchor).save(to: &self.paddingAtTrailingEdgeConstraint),
            self.contentView.bottomAnchor.constraint(equalTo: self.moduleLayoutGuide.bottomAnchor).save(to: &self.paddingAtBottomEdgeConstraint),
            self.moduleLayoutGuide.widthAnchor.constraint(equalTo: self.contentView.widthAnchor).priority(.defaultHigh),
            self.moduleLayoutGuide.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).priority(.defaultHigh),
        ])

        let constraint = self.contentView.topAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        constraint.isActive = true

        self.verticalSpacingConstraints = [constraint]
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

extension NSLayoutConstraint {

    @discardableResult
    func priority(_ priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority
        return self
    }

    @discardableResult
    func save(to constraint: inout NSLayoutConstraint!) -> NSLayoutConstraint {
        constraint = self
        return self
    }
}
