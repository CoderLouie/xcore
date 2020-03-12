//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import ObjectiveC

public protocol TargetActionBlockRepresentable: class {
    associatedtype Sender

    /// Add action handler when the item is selected.
    ///
    /// - Parameter handler: The block to invoke when the item is selected.
    func addAction(_ handler: @escaping (_ sender: Sender) -> Void)

    /// Removes action handler from `self`.
    func removeAction()
}

@objcMembers
class ClosureWrapper: NSObject {
    var closure: (() -> Void)?

    init(_ closure: (() -> Void)?) {
        self.closure = closure
    }

    func invoke(_ sender: AnyObject) {
        closure?()
    }
}

@objcMembers
class SenderClosureWrapper: NSObject {
    var closure: ((_ sender: AnyObject) -> Void)?

    init(_ closure: ((_ sender: AnyObject) -> Void)?) {
        self.closure = closure
    }

    func invoke(_ sender: AnyObject) {
        closure?(sender)
    }
}
