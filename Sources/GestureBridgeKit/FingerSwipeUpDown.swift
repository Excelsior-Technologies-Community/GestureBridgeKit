import SwiftUI
import UIKit

public enum AppGesture: Identifiable {
    case swipeLeft
    case swipeRight
    case swipeUp
    case swipeDown
    case doubleTap
    case longPress
    case twoFingerUp
    case twoFingerDown
    case threeFingerUp
    case threeFingerDown

    public var id: String { "\(self)" }
}
// MARK: - Public Gesture Enum (USED BY ContentView)
public enum GestureAction: Identifiable {
    case twoFingerUp
    case twoFingerDown
    case threeFingerUp
    case threeFingerDown
    case doubleTap
    case longPress

    public var id: String { "\(self)" }
}

// MARK: - SwiftUI Bridge (USED DIRECTLY IN ContentView)
public struct MultiFingerGestureView: UIViewRepresentable {

    public let longPressDuration: TimeInterval
    public let onGesture: (GestureAction) -> Void

    public init(
        longPressDuration: TimeInterval = 3,
        onGesture: @escaping (GestureAction) -> Void
    ) {
        self.longPressDuration = longPressDuration
        self.onGesture = onGesture
    }

    public func makeUIView(context: Context) -> UIView {
        let view = UpDownGestureHandler()
        view.onGesture = onGesture
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        (uiView as? UpDownGestureHandler)?.onGesture = onGesture
    }
}
