//
// XCScrollViewController.swift
//
// Copyright © 2015 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

public class XCScrollViewController: UIViewController {
    public let contentView = UIScrollView(frame: UIScreen.mainScreen().bounds)

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }

    private func setupContentView() {
        self.view.addSubview(contentView)
        self.view.addConstraints(NSLayoutConstraint.constraintsForViewToFillSuperview(contentView))
        resolveContentSize()
    }

    private func resolveContentSize() {
        let scrollViewWidthResolver = UIView()
        scrollViewWidthResolver.hidden = true
        self.contentView.addSubview(scrollViewWidthResolver)
        self.contentView.addConstraints(NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(scrollViewWidthResolver))
        self.contentView.addConstraint(NSLayoutConstraint(item: scrollViewWidthResolver, attribute: .Top, relatedBy: .Equal, toItem: self.contentView, attribute: .Top, multiplier: 1, constant: 0))
        scrollViewWidthResolver.addConstraint(NSLayoutConstraint(item: scrollViewWidthResolver, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 1))

        // Now the important part
        // Setting the `scrollViewWidthResolver` width to `self.view` width correctly defines the content width of the scroll view
        self.view.addConstraint(NSLayoutConstraint(item: scrollViewWidthResolver, attribute: .Width, relatedBy: .Equal, toItem: self.view, attribute: .Width, multiplier: 1, constant: 0))
    }
}
