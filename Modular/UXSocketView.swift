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
 * A simple wrapper view, keeping its content view at full width and height
 * within itself.
 *
 * - Author: christian.schnorr@me.com
 */
public class UXSocketView: UIView {

    // MARK: - Lifecycle

    public init(contentView: UIView) {
        super.init(frame: .null)

        self.bounds.size = contentView.bounds.size
        self.center = contentView.center

        defer {
            self.contentView = contentView
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }



    // MARK: - Content View

    public var contentView: UIView? = nil {
        willSet {
            precondition(newValue !== self)

            if let oldValue = self.contentView, oldValue !== newValue {
                if oldValue.superview === self {
                    oldValue.removeFromSuperview()
                }
            }
        }
        didSet {
            if let newValue = self.contentView, newValue !== oldValue {
                self.addSubview(newValue)
            }
        }
    }

    public var contentViewIfAttached: UIView? {
        if let contentView = self.contentView, contentView.superview === self {
            return contentView
        }
        else {
            return nil
        }
    }



    // MARK: - Sizing & Layout

    public override var frame: CGRect {
        didSet { self.layoutContentViewIfAttached() }
    }

    public override var bounds: CGRect {
        didSet { self.layoutContentViewIfAttached() }
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
        guard let contentView = self.contentView else { return .zero }

        return contentView.sizeThatFits(size)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        self.layoutContentViewIfAttached()
    }

    private func layoutContentViewIfAttached() {
        if let contentView = self.contentViewIfAttached {
            let frame = CGRect(origin: .zero, size: self.bounds.size)

            contentView.bounds.size = frame.size
            contentView.center = CGPoint(x: frame.midX, y: frame.midY)
        }
    }

    public override func didAddSubview(_ subview: UIView) {
        super.didAddSubview(subview)

        if subview === self.contentView {
            self.layoutContentViewIfAttached()
        }
    }



    // MARK: - Alignment

    public override var alignmentRectInsets: UIEdgeInsets {
        guard let contentView = self.contentView else { return .zero }

        return contentView.alignmentRectInsets
    }

    public override func alignmentRect(forFrame frame: CGRect) -> CGRect {
        guard let contentView = self.contentView else { return frame }

        return contentView.alignmentRect(forFrame: frame)
    }

    public override func frame(forAlignmentRect rect: CGRect) -> CGRect {
        guard let contentView = self.contentView else { return rect }

        return contentView.frame(forAlignmentRect: rect)
    }
}
