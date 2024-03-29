//
//  ViewController.swift
//  Modular
//
//  Created by Christian Schnorr on 28.09.18.
//  Copyright © 2018 Christian Schnorr. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    override func loadView() {
        self.view = DebugModularScrollView(frame: UIScreen.main.bounds)
    }

    var scrollView: UXModularScrollView<UIView> {
        return self.view as! UXModularScrollView
    }

    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self
        self.view.backgroundColor = .white

        self.headerView.backgroundColor = UIColor.purple.withAlphaComponent(0.2)
        self.scrollView.addSubview(self.headerView)

        let label1 = WrappedLabel()
        label1.backgroundColor = UIColor.red.withAlphaComponent(0.2)
        label1.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aliquam euismod quis lectus a efficitur. Etiam quis mi at mauris porta mattis. Nam a ex ex."

        let label2 = WrappedLabel()
        label2.backgroundColor = UIColor.green.withAlphaComponent(0.2)
        label2.text = "Aliquam erat volutpat. Morbi pretium elit neque, ac sodales elit suscipit vitae. Mauris dolor nibh, aliquet ac rhoncus eget, maximus et nulla. Sed eget hendrerit enim."

        let label3 = WrappedLabel()
        label3.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        label3.text = "Vestibulum dignissim tempor enim consectetur venenatis. Aenean pharetra ac elit ultricies euismod. Ut egestas erat justo, vitae tincidunt sapien venenatis quis. Phasellus porttitor at arcu vitae egestas."

        self.scrollView.appendModule(label1)
        self.scrollView.appendModule(label2)
        self.scrollView.insertModule(label3, at: 1)

        self.scrollView.moduleLayoutGuide.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
        self.scrollView.moduleInsets.top = 100

        label2.preservesSuperviewLayoutMargins = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            UIView.animate(withDuration: 0.3, animations: {
                self.scrollView.verticalModuleSpacing = 10
                self.scrollView.removeModule(at: 1)
                self.scrollView.layoutIfNeeded()
            })
        })
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard #available(iOS 11.0, *) else { fatalError() }

        let dy = scrollView.contentOffset.y + scrollView.adjustedContentInset.top

        self.headerView.frame = CGRect(x: 2, y: 2 + dy, width: self.view.bounds.width - 4, height: fmax(96 - dy, 0))
    }
}

class WrappedLabel: UIView {

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.label)

        self.label.font = UIFont.systemFont(ofSize: 25.0, weight: .regular)
        self.label.numberOfLines = 0

        if #available(iOS 10.0, *) {
            self.label.adjustsFontForContentSizeCategory = true
        }

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    var text: String? {
        get { return self.label.text }
        set { self.label.text = newValue }
    }
}

class DebugModularScrollView<Module: UIView>: UXModularScrollView<Module> {
    public override var contentSize: CGSize {
        didSet { self.contentSizeDidChange() }
    }

    private func contentSizeDidChange() {
        for module in self.modules {
            self.ensureIntegrity(of: module)
        }

        self.ensureIntegrity(of: self)
    }

    private func ensureIntegrity(of module: UIView) {
        _ = module.hasAmbiguousLayout
    }
}
