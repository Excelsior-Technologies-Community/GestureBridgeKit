import SwiftUI
import UIKit

public enum GestureAction: Identifiable {
    case twoFingerUp
    case twoFingerDown
    case threeFingerUp
    case threeFingerDown
    case doubleTap
    case longPress 

    public var id: String {
        switch self {
        case .twoFingerUp: return "2up"
        case .twoFingerDown: return "2down"
        case .threeFingerUp: return "3up"
        case .threeFingerDown: return "3down"
        case .doubleTap: return "doubleTap"
        case .longPress: return "longPress"
        }
    }
}


// MARK: - UIKit Gesture Handler
private final class MultiFingerGestureHandler: UIView {

    var onGesture: ((GestureAction) -> Void)?

    private var longPressDuration: TimeInterval
    private var longPressRecognizer: UILongPressGestureRecognizer?

    init(longPressDuration: TimeInterval) {
        self.longPressDuration = longPressDuration
        super.init(frame: .zero)
        setupGestures()
    }

    required init?(coder: NSCoder) {
        self.longPressDuration = 3
        super.init(coder: coder)
        setupGestures()
    }
    private func setupGestures() {

        // ✅ Double Tap
        let doubleTap = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap)
        )
        doubleTap.numberOfTapsRequired = 2
        doubleTap.cancelsTouchesInView = false   // 🔥 IMPORTANT
        addGestureRecognizer(doubleTap)

        // ✅ Long Press
        let longPress = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPress(_:))
        )
        longPress.minimumPressDuration = longPressDuration
        longPress.cancelsTouchesInView = false   // 🔥 IMPORTANT
        addGestureRecognizer(longPress)
        self.longPressRecognizer = longPress

        func addSwipe(
            fingers: Int,
            direction: UISwipeGestureRecognizer.Direction,
            action: Selector
        ) {
            let swipe = UISwipeGestureRecognizer(target: self, action: action)
            swipe.numberOfTouchesRequired = fingers
            swipe.direction = direction
            swipe.cancelsTouchesInView = false   // 🔥 IMPORTANT
            addGestureRecognizer(swipe)
        }

        addSwipe(fingers: 2, direction: .up, action: #selector(twoUp))
        addSwipe(fingers: 2, direction: .down, action: #selector(twoDown))
        addSwipe(fingers: 3, direction: .up, action: #selector(threeUp))
        addSwipe(fingers: 3, direction: .down, action: #selector(threeDown))
    }


    func updateLongPressDuration(_ duration: TimeInterval) {
        longPressDuration = duration
        longPressRecognizer?.minimumPressDuration = duration
    }

    // MARK: - Gesture Handlers

    @objc private func handleDoubleTap() {
        onGesture?(.doubleTap)
    }

    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            onGesture?(.longPress)
        }
    }

    @objc private func twoUp() {
        onGesture?(.twoFingerUp)
    }

    @objc private func twoDown() {
        onGesture?(.twoFingerDown)
    }

    @objc private func threeUp() {
        onGesture?(.threeFingerUp)
    }

    @objc private func threeDown() {
        onGesture?(.threeFingerDown)
    }
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let touches = event?.allTouches else {
            return true
        }
        // Only handle gestures when more than 1 finger is touching
        return touches.count > 1
    }

} // ✅ CLASS CLOSED PROPERLY

// MARK: - SwiftUI Wrapper
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
        let view = MultiFingerGestureHandler(
            longPressDuration: longPressDuration
        )
        view.backgroundColor = .clear
        view.onGesture = onGesture
        return view
    }

    public func updateUIView(_ uiView: UIView, context: Context) {
        (uiView as? MultiFingerGestureHandler)?.updateLongPressDuration(longPressDuration)
        (uiView as? MultiFingerGestureHandler)?.onGesture = onGesture
    }
}
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
