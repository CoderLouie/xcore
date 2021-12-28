//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct DateCodingFormatStyle: CodingFormatStyle {
    private let calendar: Calendar
    private let formats: [Date.Format.Custom]

    init(
        calendar: Calendar = .defaultCoding,
        formats: [Date.Format.Custom] = [.iso8601, .iso8601Local, .yearMonthDayDash]
    ) {
        self.formats = formats
        self.calendar = calendar
    }

    public func decode(_ value: String) throws -> Date {
        for format in formats {
            if let date = Date(from: value, format: format, calendar: calendar) {
                return date
            }
        }

        throw CodingFormatStyleError.invalidValue
    }

    public func encode(_ value: Date) throws -> String {
        if let format = formats.first {
            return value.string(format: format, in: calendar)
        }

        throw CodingFormatStyleError.invalidValue
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == DateCodingFormatStyle {
    public static func date(
        calendar: Calendar = .defaultCoding,
        formats: [Date.Format.Custom] = [.iso8601, .iso8601Local, .yearMonthDayDash]
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }

    public static func date(
        calendar: Calendar = .defaultCoding,
        formats: Date.Format.Custom...
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }
}

extension EncodingFormatStyle where Self == DateCodingFormatStyle {
    public static func date(
        calendar: Calendar = .defaultCoding,
        formats: [Date.Format.Custom] = [.iso8601, .iso8601Local, .yearMonthDayDash]
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }

    public static func date(
        calendar: Calendar = .defaultCoding,
        formats: Date.Format.Custom...
    ) -> Self {
        .init(calendar: calendar, formats: formats)
    }
}
