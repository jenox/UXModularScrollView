// https://stackoverflow.com/a/25565798/796103

import UIKit

class TraitOverride: UIViewController {

    var forcedTraitCollection: UITraitCollection? {
        didSet {
            updateForcedTraitCollection()
        }
    }

//    override func viewDidLoad() {
//        setForcedTraitForSize(view.bounds.size)
//    }

    var viewController: UIViewController? {
        willSet {
            if let previousVC = viewController {
                if newValue !== previousVC {
                    previousVC.willMove(toParent: nil)
                    setOverrideTraitCollection(nil, forChild: previousVC)
                    previousVC.view.removeFromSuperview()
                    previousVC.removeFromParent()
                }
            }
        }

        didSet {
            if let vc = viewController {
                addChild(vc)
                view.addSubview(vc.view)
                vc.didMove(toParent: self)
                updateForcedTraitCollection()
            }
        }
    }

//    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator!) {
//        setForcedTraitForSize(size)
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//    }

//    func setForcedTraitForSize (size: CGSize) {
//
//        let device = traitCollection.userInterfaceIdiom
//        var portrait: Bool {
//            if device == .Phone {
//                return size.width > 320
//            } else {
//                return size.width > 768
//            }
//        }
//
//        switch (device, portrait) {
//        case (.Phone, true):
//            forcedTraitCollection = UITraitCollection(horizontalSizeClass: .Regular)
//        case (.Pad, false):
//            forcedTraitCollection = UITraitCollection(horizontalSizeClass: .Compact)
//        default:
//            forcedTraitCollection = nil
//        }
//    }

    func updateForcedTraitCollection() {
        if let vc = viewController {
            setOverrideTraitCollection(self.forcedTraitCollection, forChild: vc)
        }
    }
}
