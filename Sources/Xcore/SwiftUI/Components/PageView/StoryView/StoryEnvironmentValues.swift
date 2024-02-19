//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Progress Indicator Color

extension EnvironmentValues {
    private enum StoryProgressIndicatorColorKey: EnvironmentKey {
        static let defaultValue: Color = .accentColor
    }

    var storyProgressIndicatorColor: Color {
        get { self[StoryProgressIndicatorColorKey.self] }
        set { self[StoryProgressIndicatorColorKey.self] = newValue }
    }
}

// MARK: - Progress Indicator Insets

extension EnvironmentValues {
    private enum StoryProgressIndicatorInsetsKey: EnvironmentKey {
        static let defaultValue = EdgeInsets(horizontal: .defaultSpacing)
    }

    var storyProgressIndicatorInsets: EdgeInsets {
        get { self[StoryProgressIndicatorInsetsKey.self] }
        set { self[StoryProgressIndicatorInsetsKey.self] = newValue }
    }
}

// MARK: - View Helpers

extension View {
    public func storyProgressIndicatorColor(_ color: Color) -> some View {
        environment(\.storyProgressIndicatorColor, color)
    }

    public func storyProgressIndicatorInsets(_ insets: EdgeInsets) -> some View {
        environment(\.storyProgressIndicatorInsets, insets)
    }
}
