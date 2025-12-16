import UIKit
import SwiftUI

final class UpDownGestureHandler: UIView {

    var onGesture: ((GestureAction) -> Void)?

    private let threshold: CGFloat = 60

    // Track only touches that started this gesture
    private var startPoints: [UITouch: CGPoint] = [:]
    private var didTrigger = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        backgroundColor = .clear
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isMultipleTouchEnabled = true
        backgroundColor = .clear
    }

    // MARK: - Touch Lifecycle

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        didTrigger = false

        for touch in touches {
            startPoints[touch] = touch.location(in: self)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        // ✅ Use ONLY touches that started together
        let activeTouches = startPoints.keys

        guard
            !didTrigger,
            activeTouches.count == 2 || activeTouches.count == 3
        else { return }

        var totalDeltaY: CGFloat = 0

        for touch in activeTouches {
            guard let start = startPoints[touch] else { continue }
            let current = touch.location(in: self)
            totalDeltaY += current.y - start.y
        }

        let avgDeltaY = totalDeltaY / CGFloat(activeTouches.count)

        guard abs(avgDeltaY) > threshold else { return }

        didTrigger = true

        // ✅ 2 FINGER UP / DOWN
        if activeTouches.count == 2 {
            onGesture?(avgDeltaY < 0 ? .twoFingerUp : .twoFingerDown)
        }

        // ✅ 3 FINGER UP / DOWN
        if activeTouches.count == 3 {
            onGesture?(avgDeltaY < 0 ? .threeFingerUp : .threeFingerDown)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        cleanup(touches)
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        cleanup(touches)
    }

    private func cleanup(_ touches: Set<UITouch>) {
        for touch in touches {
            startPoints.removeValue(forKey: touch)
        }
        didTrigger = false
    }

    // IMPORTANT: allow SwiftUI gestures to coexist
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true
    }
}
