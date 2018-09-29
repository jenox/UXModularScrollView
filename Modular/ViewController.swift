//
//  ViewController.swift
//  Modular
//
//  Created by Christian Schnorr on 28.09.18.
//  Copyright © 2018 Christian Schnorr. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        self.view = ModularScrollView(frame: UIScreen.main.bounds)
    }

    var scrollView: ModularScrollView<UIView> {
        return self.view as! ModularScrollView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white

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

        let marker = UIView()
        marker.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.view.addSubview(marker)
        marker.translatesAutoresizingMaskIntoConstraints = false
        marker.topAnchor.constraint(equalTo: self.view.readableContentGuide.topAnchor).isActive = true
        marker.leadingAnchor.constraint(equalTo: self.view.readableContentGuide.leadingAnchor).isActive = true
        marker.trailingAnchor.constraint(equalTo: self.view.readableContentGuide.trailingAnchor).isActive = true
        marker.bottomAnchor.constraint(equalTo: self.view.readableContentGuide.bottomAnchor).isActive = true
    }


}

class WrappedLabel: UIView {

    let label = UILabel()
    let marker = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(self.label)
        self.addSubview(self.marker)

        self.label.font = UIFont.systemFont(ofSize: 30.0, weight: .regular)
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

    override var backgroundColor: UIColor? {
        get { return self.label.backgroundColor }
        set { self.label.backgroundColor = newValue }
    }
}

