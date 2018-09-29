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
        self.view = ModularScrollView(frame: UIScreen.main.bounds)
    }

    var scrollView: ModularScrollView<UIView> {
        return self.view as! ModularScrollView
    }

    let headerView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self
        self.view.backgroundColor = .white

        self.headerView.backgroundColor = .red
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

        self.scrollView.padding = UIEdgeInsets(top: 110, left: 10, bottom: 10, right: 10)
        self.scrollView.moduleLayoutGuide.widthAnchor.constraint(lessThanOrEqualToConstant: 500).isActive = true
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let dy = scrollView.contentOffset.y + scrollView.adjustedContentInset.top

        self.headerView.frame = CGRect(x: 2, y: 2 + dy, width: self.view.bounds.width - 4, height: fmax(96 - dy, 0))
    }
}

class WrappedLabel: UIView {

    let label = UILabel()
    let marker = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.label)
        self.addSubview(self.marker)

        self.label.font = UIFont.systemFont(ofSize: 25.0, weight: .regular)
//        self.label.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: UIFont.systemFont(ofSize: 20, weight: .regular))
        self.label.numberOfLines = 0
        self.label.adjustsFontForContentSizeCategory = true

        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.label.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
        self.label.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        self.label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true

        self.marker.translatesAutoresizingMaskIntoConstraints = false
        self.marker.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor).isActive = true
        self.marker.leadingAnchor.constraint(equalTo: self.layoutMarginsGuide.leadingAnchor).isActive = true
        self.marker.trailingAnchor.constraint(equalTo: self.layoutMarginsGuide.trailingAnchor).isActive = true
        self.marker.bottomAnchor.constraint(equalTo: self.layoutMarginsGuide.bottomAnchor).isActive = true
        self.marker.layer.cornerRadius = 2
        self.marker.layer.borderWidth = 0.5
        self.marker.layer.borderColor = UIColor.red.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    var text: String? {
        get { return self.label.text }
        set { self.label.text = newValue }
    }
}
