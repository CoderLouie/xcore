//
// String+Mask.swift
//
// Copyright © 2017 Xcore
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

import Foundation

extension String {
    public enum MaskOptions {
        public enum MaskCharacterCount {
            /// Mask characters length is same as the input string length.
            case same

            /// Mask characters length is greater than or equal to `n`.
            case min(Int)

            /// Mask characters length is less than or equal to `n`.
            case max(Int)

            /// Mask characters length is equal to `n`.
            case equal(Int)

            fileprivate func length(basedOn count: Int) -> Int {
                switch self {
                    case .same:
                        return Swift.max(0, count)
                    case .min(let value):
                        return Swift.max(value, count)
                    case .max(let value):
                        return Swift.min(value, Swift.max(0, count))
                    case .equal(let value):
                        return value
                }
            }

            fileprivate func string(count: Int, separator: String, suffix: Bool) -> String {
                let length = self.length(basedOn: count)

                if case .equal = self { } else if length == 0 {
                    return ""
                }

                if suffix {
                    return String(repeating: .mask, count: length) + separator
                } else {
                    return separator + String(repeating: .mask, count: length)
                }
            }
        }

        /// Automatically detects a valid email address and apply email masking.
        ///
        /// ```swift
        /// print("hello@icloud.com".masked())
        /// // Prints "h•••@icloud.com"
        ///
        /// print("hello@icloud.com".masked(options: .automatic(maskCount: .same)))
        /// // Prints "h••••@icloud.com"
        ///
        /// print("Hello World".masked())
        /// // Prints "•••••••••••"
        /// ```
        case automatic(maskCount: MaskCharacterCount? = nil)

        /// Mask all except the first `n` characters.
        ///
        /// ```swift
        /// print("0123456789".masked(options: .allExceptFirst(4))
        /// // Prints "0123••••••"
        ///
        /// print("0123456789".masked(options: .allExceptFirst(4, separator: " ")))
        /// // Prints "0123 ••••••"
        ///
        /// print("0123456789".masked(options: .allExceptFirst(4, maskCount: .equal(4), separator: " ")))
        /// // Prints "0123 ••••"
        /// ```
        case allExceptFirst(Int, maskCount: MaskCharacterCount = .same, separator: String = "")

        /// Mask all except the last `n` characters.
        ///
        /// ```swift
        /// print("0123456789".masked(options: .allExceptLast(4))
        /// // Prints "••••••6789"
        ///
        /// print("0123456789".masked(options: .allExceptLast(4, separator: " ")))
        /// // Prints "•••••• 6789"
        ///
        /// print("0123456789".masked(options: .allExceptLast(4, maskCount: .equal(4), separator: " ")))
        /// // Prints "•••• 6789"
        ///
        /// print("0123456789".masked(options: .accountNumber))
        /// // Prints "•••• 6789"
        /// ```
        case allExceptLast(Int, maskCount: MaskCharacterCount = .same, separator: String = "")

        /// Mask with account number options.
        ///
        /// ```swift
        /// print("0123456789".masked(options: .accountNumber))
        /// // Prints "•••• 6789"
        /// ```
        public static var accountNumber: Self {
            allExceptLast(4, maskCount: .equal(4), separator: " ")
        }
    }

    public func masked(options: MaskOptions = .automatic()) -> String {
        guard !isEmpty else {
            return self
        }

        switch options {
            case .allExceptFirst(let (maxLength, maskCount, separator)):
                return prefix(maxLength) + maskCount.string(count: count - maxLength, separator: separator, suffix: false)
            case .allExceptLast(let (maxLength, maskCount, separator)):
                return maskCount.string(count: count - maxLength, separator: separator, suffix: true) + suffix(maxLength)
            case .automatic(let maskCount):
                guard
                    validate(rule: .email),
                    let firstIndex = index(from: 1),
                    let lastIndex = lastIndex(of: "@")
                else {
                    let length = (maskCount ?? .same).length(basedOn: count)
                    return String(repeating: .mask, count: length)
                }

                var string = self
                let range = firstIndex..<lastIndex
                let count = (maskCount ?? .equal(3)).length(basedOn: distance(from: range.lowerBound, to: range.upperBound))
                string.replaceSubrange(range, with: String(repeating: .mask, count: count))
                return string
        }
    }
}
