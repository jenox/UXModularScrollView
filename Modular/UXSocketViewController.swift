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
 * A wrapper view controller managing a single child view controller that can be
 * removed or exchanged later.
 *
 * The socket view controller delegates most tasks to its content view
 * controller, such as interface rotation and status bar management. However, it
 * does not keep its own and its child's stored properties in sync, such as the
 * view controller's title or its navigation items.
 *
 * Use a `UXSocketViewController` when implementing custom container view
 * controllers with dynamic child view controllers. By having a static set of
 * direct child view controllers (sockets) managing their child view controller,
 * it is easy to get appearance callbacks right.
 *
 * - Author: christian.schnorr@me.com
 */
public class UXSocketViewController: UIViewController {

    // MARK: - Lifecycle

    public convenience init(contentViewController: UIViewController) {
        self.init(nibName: nil, bundle: nil)

        defer {
            self.contentViewController = contentViewController
        }
    }

    public override init(nibName: String?, bundle: Bundle?) {
        super.init(nibName: nibName, bundle: bundle)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    deinit {
        self.endObservingContentViewControllerView()
    }



    // MARK: - Content View Controller

    public var contentViewController: UIViewController? = nil {
        willSet {
            precondition(newValue !== self)

            if let oldValue = self.contentViewController, oldValue !== newValue {
                self.dismissChildViewController(oldValue)

                oldValue.willMove(toParent: nil)
                self.endObservingContentViewControllerView()
                self.socketViewIfLoaded?.contentView = nil
                oldValue.removeFromParent()
            }
        }
        didSet {
            if let newValue = self.contentViewController, newValue !== oldValue {
                self.addChild(newValue)
                self.socketViewIfLoaded?.contentView = newValue.view
                self.beginObservingContentViewControllerView()
                newValue.didMove(toParent: self)

                self.presentChildViewController(newValue)
            }

            if self.contentViewController !== oldValue {
                self.setNeedsStatusBarAppearanceUpdate()
                self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
                self.setNeedsUpdateOfHomeIndicatorAutoHidden()
            }
        }
    }

    private var contentViewControllerViewObserver: NSKeyValueObservation? = nil

    fileprivate func beginObservingContentViewControllerView() {
        guard let controller = self.contentViewController else { return }

        let observer = controller.observe(\.view, changeHandler: { [unowned self] _, _ in
            self.socketViewIfLoaded?.contentView = controller.view
        })

        self.contentViewControllerViewObserver = observer
    }

    fileprivate func endObservingContentViewControllerView() {
        self.contentViewControllerViewObserver = nil
    }



    // MARK: - View Management

    public override var view: UIView! {
        get { return super.view }
        set { fatalError() }
    }

    private var socketView: UXSocketView {
        return self.view as! UXSocketView
    }

    private var socketViewIfLoaded: UXSocketView? {
        return self.viewIfLoaded as! UXSocketView?
    }

    public override func loadView() {
        super.view = UXSocketView(frame: UIScreen.main.bounds)
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        self.socketView.contentView = self.contentViewController?.view
    }



    // MARK: - Appearance

    private enum Visibility {
        case appearing(Bool)
        case appeared
        case disappearing(Bool)
        case disappeared
    }

    private var visibility: Visibility = .disappeared

    public final override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        return false
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.visibility = .appearing(animated)

        self.contentViewController?.beginAppearanceTransition(true, animated: animated)
    }

    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        self.visibility = .appeared

        self.contentViewController?.endAppearanceTransition()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        self.visibility = .disappearing(animated)

        self.contentViewController?.beginAppearanceTransition(false, animated: animated)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        self.visibility = .disappeared

        self.contentViewController?.endAppearanceTransition()
    }

    fileprivate func presentChildViewController(_ newValue: UIViewController) {
        switch self.visibility {
        case .appearing(let animated):
            newValue.beginAppearanceTransition(true, animated: animated)
        case .appeared:
            newValue.beginAppearanceTransition(true, animated: false)
            newValue.endAppearanceTransition()
        case .disappearing(let animated):
            newValue.beginAppearanceTransition(true, animated: false)
            newValue.endAppearanceTransition()
            newValue.beginAppearanceTransition(false, animated: animated)
        case .disappeared:
            break
        }
    }

    fileprivate func dismissChildViewController(_ oldValue: UIViewController) {
        switch self.visibility {
        case .appearing:
            oldValue.beginAppearanceTransition(false, animated: false)
            oldValue.endAppearanceTransition()
        case .appeared:
            oldValue.beginAppearanceTransition(false, animated: false)
            oldValue.endAppearanceTransition()
        case .disappearing:
            oldValue.endAppearanceTransition()
        case .disappeared:
            break
        }
    }



    // MARK: - Interface Rotation

    public override var shouldAutorotate: Bool {
        guard let contentViewController = self.contentViewController else {
            return super.shouldAutorotate
        }

        return contentViewController.shouldAutorotate
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        guard let contentViewController = self.contentViewController else {
            return super.supportedInterfaceOrientations
        }

        return contentViewController.supportedInterfaceOrientations
    }

    public override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        guard let contentViewController = self.contentViewController else {
            return super.preferredInterfaceOrientationForPresentation
        }

        return contentViewController.preferredInterfaceOrientationForPresentation
    }



    // MARK: - Status Bar

    public override var childForStatusBarStyle: UIViewController? {
        return self.contentViewController
    }

    public override var childForStatusBarHidden: UIViewController? {
        return self.contentViewController
    }



    // MARK: - System Gestures

    public override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
        return self.contentViewController
    }

    public override var childForHomeIndicatorAutoHidden: UIViewController? {
        return self.contentViewController
    }
}
