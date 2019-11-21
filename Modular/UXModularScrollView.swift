/*
 MIT License

 Copyright (c) 2018 Christian Schnorr

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit


/**
 * The `UXModularScrollView` class is a vertical scroll view that manages a
 * dynamic list of so-called modules that are laid out as a vertical stack.
 *
 * - Author: christian.schnorr@me.com
 */
public class UXModularScrollView<Module: UIView>: UIScrollView {

    // MARK: - Lifecycle

    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.contentView.layoutMargins = .zero
        self.alwaysBounceVertical = true

        self.establishSubviewHiearchy()
        self.createLayoutConstraints()
    }

    public convenience init(modules: [Module]) {
        self.init(frame: .null)

        for module in modules {
            self.appendModule(module)
        }
    }

    public required init?(coder: NSCoder) {
        fatalError()
    }

    deinit {
        self.isBeingDeallocated = true
    }

    fileprivate var isBeingDeallocated: Bool = false


    // MARK: - Configuration

    public let moduleLayoutGuide: UILayoutGuide = UILayoutGuide()

    public var moduleInsets: UIEdgeInsets {
        get { return self.contentView.layoutMargins }
        set { self.contentView.layoutMargins = newValue }
    }

    public var directionalModuleInsets: NSDirectionalEdgeInsets {
        get { return self.contentView.directionalLayoutMargins }
        set { self.contentView.directionalLayoutMargins = newValue }
    }

    public var verticalModuleSpacing: CGFloat = 0 {
        didSet { self.updateModuleSpacingConstraints() }
    }


    // MARK: - Module Management

    private(set) public var modules: [Module] = []

    private var verticalLayoutConstraints: [NSLayoutConstraint] = []

    public func insertModule(_ module: Module, at index: Int) {
        precondition(0 <= index && index <= self.modules.count)
        precondition(!self.modules.contains(module))

        self.modules.insert(module, at: index)
        self.addSubview(module)

        module.translatesAutoresizingMaskIntoConstraints = false
        module.leadingAnchor.constraint(equalTo: self.moduleLayoutGuide.leadingAnchor).isActive = true
        module.trailingAnchor.constraint(equalTo: self.moduleLayoutGuide.trailingAnchor).isActive = true

        self.removeVerticalLayoutConstraint(at: index)
        self.createVerticalLayoutConstraint(at: index)
        self.createVerticalLayoutConstraint(at: index + 1)
    }

    public func insertModule(_ module: Module, above other: Module) {
        let index = self.modules.firstIndex(of: other) ?? 0

        self.insertModule(module, at: index)
    }

    public func insertModule(_ module: Module, below other: Module) {
        let index = self.modules.firstIndex(of: other) ?? self.modules.count

        self.insertModule(module, at: index)
    }

    public func appendModule(_ module: Module) {
        self.insertModule(module, at: self.modules.count)
    }

    public func removeModule(at index: Int) {
        let module = self.modules.remove(at: index)
        module.removeFromSuperview()

        self.removeVerticalLayoutConstraint(at: index + 1)
        self.removeVerticalLayoutConstraint(at: index)
        self.createVerticalLayoutConstraint(at: index)
    }

    public func removeAllModules() {
        let modules = self.modules

        self.modules = []
        self.removeAllVerticalLayoutConstraints()
        self.createVerticalLayoutConstraint(at: 0)

        for module in modules {
            module.removeFromSuperview()
        }
    }

    fileprivate func createVerticalLayoutConstraint(at index: Int) {
        let upperModule = self.modules.prefix(index).last
        let lowerModule = self.modules.dropFirst(index).first
        let constraint: NSLayoutConstraint

        switch (upperModule, lowerModule) {
        case (.some(let upperModule), .some(let lowerModule)):
            constraint = lowerModule.topAnchor.constraint(equalTo: upperModule.bottomAnchor, constant: self.verticalModuleSpacing)
        case (.some(let upperModule), .none):
            constraint = self.moduleLayoutGuide.bottomAnchor.constraint(equalTo: upperModule.bottomAnchor)
        case (.none, .some(let lowerModule)):
            constraint = lowerModule.topAnchor.constraint(equalTo: self.moduleLayoutGuide.topAnchor)
        case (.none, .none):
            constraint = self.moduleLayoutGuide.bottomAnchor.constraint(equalTo: self.moduleLayoutGuide.topAnchor)
        }

        constraint.isActive = true

        self.verticalLayoutConstraints.insert(constraint, at: index)
    }

    fileprivate func removeVerticalLayoutConstraint(at index: Int) {
        let constraint = self.verticalLayoutConstraints.remove(at: index)
        constraint.isActive = false
    }

    fileprivate func removeAllVerticalLayoutConstraints() {
        NSLayoutConstraint.deactivate(self.verticalLayoutConstraints)

        self.verticalLayoutConstraints = []
    }

    fileprivate func updateModuleSpacingConstraints() {
        for constraint in self.verticalLayoutConstraints.dropFirst().dropLast() {
            constraint.constant = self.verticalModuleSpacing
        }
    }


    // MARK: - Subview Management

    fileprivate let contentView: UIView = UIView()

    fileprivate func establishSubviewHiearchy() {
        self.addSubview(self.contentView)
    }

    fileprivate func createLayoutConstraints() {
        self.addLayoutGuide(self.moduleLayoutGuide)

        self.createContentViewConstraints()
        self.createModuleLayoutGuideConstraints()

        self.createVerticalLayoutConstraint(at: 0)
    }

    private func createContentViewConstraints() {
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            self.contentView.topAnchor.constraint(equalTo: self.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.widthAnchor),
        ])
    }

    private func createModuleLayoutGuideConstraints() {
        let moduleWidthConstraint = self.moduleLayoutGuide.widthAnchor.constraint(equalTo: self.contentView.widthAnchor)
        moduleWidthConstraint.priority = UILayoutPriority(rawValue: 800)

        let moduleCenterConstraint = self.moduleLayoutGuide.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor)
        moduleCenterConstraint.priority = UILayoutPriority(rawValue: 800)

        let scrollViewHeightConstraint = self.heightAnchor.constraint(equalTo: self.contentView.heightAnchor)
        scrollViewHeightConstraint.priority = UILayoutPriority(rawValue: 100)

        NSLayoutConstraint.activate([
            self.moduleLayoutGuide.topAnchor.constraint(equalTo: self.contentView.layoutMarginsGuide.topAnchor),
            self.moduleLayoutGuide.leadingAnchor.constraint(greaterThanOrEqualTo: self.contentView.layoutMarginsGuide.leadingAnchor),
            self.contentView.layoutMarginsGuide.trailingAnchor.constraint(greaterThanOrEqualTo: self.moduleLayoutGuide.trailingAnchor),
            self.contentView.layoutMarginsGuide.bottomAnchor.constraint(equalTo: self.moduleLayoutGuide.bottomAnchor),
            moduleWidthConstraint,
            moduleCenterConstraint,
            scrollViewHeightConstraint,
        ])
    }

    public override func willRemoveSubview(_ subview: UIView) {
        super.willRemoveSubview(subview)

        guard !self.isBeingDeallocated else { return }

        if let index = self.modules.firstIndex(where: { $0 === subview }) {
            self.removeModule(at: index)
        }
    }
}
