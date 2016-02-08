//
// IconLabelView.swift
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
import TZStackView

public class IconLabelView: UIView {
    public enum Style { case TopBottom, LeftRight }

    private var imagePaddingConstraints: [NSLayoutConstraint] = []
    private var imageSizeConstraints: (width: NSLayoutConstraint?,  height: NSLayoutConstraint?)
    private var labelsWidthConstraints: [NSLayoutConstraint] = []

    // MARK: Subviews

    private let stackView          = TZStackView()
    private let imageViewContainer = UIView()
    public let imageView           = UIImageView()
    public let titleLabel          = UILabel()
    public let subtitleLabel       = UILabel()

    /// The default value is `.TopBottom`.
    public var style = Style.TopBottom {
        didSet {
            guard oldValue != style else { return }
            updateStyle(style)
        }
    }

    /// The default size is `55,55`.
    public var imageSize = CGSize(width: 55, height: 55) {
        didSet {
            imageSizeConstraints.width?.constant  = imageSize.width
            imageSizeConstraints.height?.constant = imageSize.height
        }
    }

    /// The default value is `0` which means size to fit.
    public var labelsWidth: CGFloat = 0 {
        didSet {
            guard oldValue != labelsWidth else { return }
            if labelsWidth == 0 {
                guard !labelsWidthConstraints.isEmpty else { return }
                labelsWidthConstraints.deactivate()
            } else {
                if labelsWidthConstraints.isEmpty {
                    labelsWidthConstraints.append(NSLayoutConstraint(item: titleLabel,    width: labelsWidth))
                    labelsWidthConstraints.append(NSLayoutConstraint(item: subtitleLabel, width: labelsWidth))
                }
                labelsWidthConstraints.activate()
            }
        }
    }

    /// The default value is `8`.
    public var imagePadding: CGFloat = 8 {
        didSet {
            imagePaddingConstraints.forEach { $0.constant = imagePadding }
            imageView.cornerRadius = imageCornerRadius - imagePadding
        }
    }

    /// The default value is `13`.
    public var imageCornerRadius: CGFloat = 13 {
        didSet {
            imageViewContainer.cornerRadius = imageCornerRadius
        }
    }

    /// The default value is `false`.
    public var isRoundImageView = false {
        didSet {
            imageCornerRadius = isRoundImageView ? imageSize.height / 2 : 0
        }
    }

    /// The default color is white.
    public var imageBackgroundColor = UIColor.whiteColor() {
        didSet {
            imageViewContainer.backgroundColor = imageBackgroundColor
        }
    }

    /// The default value is `false`.
    public var subtitleLabelVisible: Bool = false {
        didSet {
            guard oldValue != subtitleLabelVisible else { return }
            if subtitleLabelVisible {
                stackView.addArrangedSubview(subtitleLabel)
            } else {
                stackView.removeArrangedSubview(subtitleLabel)
                subtitleLabel.removeFromSuperview()
            }
        }
    }

    /// The default value is `false`.
    public var isImageViewHidden: Bool = false {
        didSet {
            guard oldValue != isImageViewHidden else { return }
            if isImageViewHidden {
                stackView.removeArrangedSubview(imageViewContainer)
                imageViewContainer.removeFromSuperview()
            } else {
                stackView.insertArrangedSubview(imageViewContainer, atIndex: 0)
            }
        }
    }

    /// The default value is `.Vertical`.
    private var axis: UILayoutConstraintAxis {
        get { return stackView.axis }
        set { stackView.axis = newValue }
    }

    /// The default value is `.Fill`.
    private var distribution: TZStackViewDistribution {
        get { return stackView.distribution }
        set { stackView.distribution = newValue }
    }

    /// The default value is `.Center`.
    private var alignment: TZStackViewAlignment {
        get { return stackView.alignment }
        set { stackView.alignment = newValue }
    }

    /// The default value is `5`.
    public var spacing: CGFloat {
        get { return stackView.spacing }
        set { stackView.spacing = newValue }
    }

    // MARK: Init Methods

    public convenience init() {
        self.init(frame: .zero)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubviews()
    }

    // MARK: Setters

    public func setData(imageUrl: String = "", title: String, subtitle: String? = nil) {
        setData(imageUrl, title: title, subtitle: subtitle)
    }

    public func setData(image: ImageRepresentable = "", title: StringRepresentable, subtitle: StringRepresentable? = nil) {
        imageView.setImage(image)
        titleLabel.setText(title)
        subtitleLabel.setText(subtitle)
        subtitleLabelVisible = subtitle != nil
    }

    public func setData(data: ImageTitleDisplayable) {
        setData(data.image, title: data.title, subtitle: data.subtitle)
    }

    // MARK: Setup Methods

    private func setupSubviews() {
        addSubview(stackView)
        NSLayoutConstraint.constraintsForViewToFillSuperview(stackView).activate()

        axis         = .Vertical
        distribution = .Fill
        alignment    = .Center
        spacing      = 5

        stackView.addArrangedSubview(imageViewContainer)
        stackView.addArrangedSubview(titleLabel)

        titleLabel.font          = UIFont.systemFont(UIFont.Size.Small)
        titleLabel.textAlignment = .Center
        titleLabel.textColor     = UIColor.whiteColor()
        titleLabel.numberOfLines = 2
        titleLabel.sizeToFit()

        subtitleLabel.font          = UIFont.systemFont(UIFont.Size.Small)
        subtitleLabel.textAlignment = .Center
        subtitleLabel.textColor     = UIColor.whiteColor()
        subtitleLabel.numberOfLines = 1
        subtitleLabel.sizeToFit()

        imageViewContainer.backgroundColor = UIColor.whiteColor()
        imageViewContainer.cornerRadius    = imageCornerRadius
        imageViewContainer.addSubview(imageView)
        let size = NSLayoutConstraint.size(imageViewContainer, size: imageSize).activate()
        imageSizeConstraints.width  = size[0]
        imageSizeConstraints.height = size[1]
        imagePaddingConstraints = NSLayoutConstraint.constraintsForViewToFillSuperview(imageView, padding: UIEdgeInsets(all: imagePadding)).activate()

        // Ensures smooth scaling quality
        imageView.layer.minificationFilter = kCAFilterTrilinear

        imageView.contentMode = .ScaleAspectFill
    }

    private func updateStyle(style: Style) {
        switch style {
            case .TopBottom:
                axis = .Vertical
            case .LeftRight:
                axis = .Horizontal
        }
    }
}
