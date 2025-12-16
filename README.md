
# GestureBridgeKit

GestureBridgeKit is a Swift package that adds **advanced gesture support** to SwiftUI.

It bridges SwiftUI and UIKit internally to provide gesture capabilities that SwiftUI does not support out of the box, while keeping the **usage API clean and SwiftUI-friendly**.

---

## Supported Gestures

GestureBridgeKit supports the following gestures:

* Double tap
* Long press (with configurable duration)
* Single-finger swipe

  * Up
  * Down
  * Left
  * Right
* Two-finger swipe

  * Up
  * Down
* Three-finger swipe

  * Up
  * Down

Each gesture can be used to:

* Open your own SwiftUI view
* Run your own business logic
* Trigger animations, API calls, or state updates

---

## Requirements

* iOS 14+
* Swift 5.7+
* SwiftUI

---

## Installation (Swift Package Manager)

### Step 1: Add the package

1. Open your Xcode project
2. Go to **File → Add Packages…**
3. Paste the repository URL:

```
https://github.com/Excelsior-Technologies-Community/GestureBridgeKit
```

4. Select the latest version
5. Add the package to your app target

---

### Step 2: Import the package

In any SwiftUI file where you want to use gestures:

```swift
import GestureBridgeKit
```

---

## 1. Double Tap

Double tap is handled using native SwiftUI.

### Minimal usage

```swift
TapGesture(count: 2)
    .onEnded {
        // Handle double tap
    }
```

### Example in a view

```swift
Text("Double Tap Here")
    .simultaneousGesture(
        TapGesture(count: 2)
            .onEnded {
                // Open a view or run logic
            }
    )
```

---

## 2. Long Press (Configurable Duration)

You can control how many seconds the user must press.

### Minimal usage

```swift
LongPressGesture(minimumDuration: 3)
    .onEnded { _ in
        // Trigger after 3 seconds
    }
```

You can change the duration freely:

```swift
minimumDuration: 1.5
minimumDuration: 5
```

---

## 3. Single-Finger Swipe (Up, Down, Left, Right)

Single-finger swipe is implemented using `DragGesture`.

### Minimal example

```swift
DragGesture()
    .onEnded { value in
        let h = value.translation.width
        let v = value.translation.height

        if abs(h) > abs(v) {
            if h > 0 {
                // Swipe Right
            } else {
                // Swipe Left
            }
        } else {
            if v > 0 {
                // Swipe Down
            } else {
                // Swipe Up
            }
        }
    }
```

You can adjust swipe sensitivity using a threshold value.

---

## 4. Two-Finger and Three-Finger Swipe (Up / Down)

SwiftUI does not support finger-count detection.

GestureBridgeKit provides `MultiFingerGestureView` to handle this.

### Basic usage

Place `MultiFingerGestureView` inside a `ZStack` so it overlays your UI.

```swift
MultiFingerGestureView(longPressDuration: 3) { gesture in
    switch gesture {
    case .twoFingerUp:
        // Handle 2-finger up
    case .twoFingerDown:
        // Handle 2-finger down
    case .threeFingerUp:
        // Handle 3-finger up
    case .threeFingerDown:
        // Handle 3-finger down
    case .doubleTap:
        // Handle double tap
    case .longPress:
        // Handle long press
    }
}
```

The `longPressDuration` parameter controls how many seconds are required for a long press.

---

## 5. Opening Your Own Views

The recommended pattern is:

1. Detect a gesture
2. Store it in a `@State` variable
3. Open your own SwiftUI view using `.sheet` or `.fullScreenCover`

You are **not limited** to showing text or alerts.

---

## 6. Using Your Own Functionality (Important)

GestureBridgeKit **does not force navigation**.

Inside the `switch`, you can:

* Open a view
* Call APIs
* Update a ViewModel
* Trigger animations
* Play sounds
* Execute any business logic

### Example: Opening Views

```swift
case .twoFingerUp:
    TwoFingerUpSheetView()

case .doubleTap:
    DoubleTapSheetView()
```

---

### Example: Running Logic Only

```swift
case .twoFingerUp:
    viewModel.refreshData()

case .threeFingerDown:
    decreaseFontSize()
```

---

### Example: Mixed Approach

```swift
case .twoFingerUp:
    analytics.track("two_finger_up")
    activeGesture = .twoFingerUp
```

---

## 7. Full Final Example (Production Ready)

Below is a **complete working `ContentView`** using all gestures and opening **custom SwiftUI views**.

```swift
import SwiftUI
import GestureBridgeKit

struct ContentView: View {

    private let swipeThreshold: CGFloat = 80
    private let longPressDuration: Double = 3

    @State private var activeGesture: AppGesture?

    var body: some View {
        ZStack {

            Color.white.ignoresSafeArea()

            Text("Gesture Demo")
                .font(.title)

            MultiFingerGestureView(longPressDuration: longPressDuration) { gesture in
                switch gesture {
                case .twoFingerUp:
                    activeGesture = .twoFingerUp
                case .twoFingerDown:
                    activeGesture = .twoFingerDown
                case .threeFingerUp:
                    activeGesture = .threeFingerUp
                case .threeFingerDown:
                    activeGesture = .threeFingerDown
                case .doubleTap:
                    activeGesture = .doubleTap
                case .longPress:
                    activeGesture = .longPress
                }
            }
        }

        .gesture(
            DragGesture()
                .onEnded { value in
                    let h = value.translation.width
                    let v = value.translation.height

                    if abs(h) > abs(v) {
                        if h > swipeThreshold {
                            activeGesture = .swipeRight
                        } else if h < -swipeThreshold {
                            activeGesture = .swipeLeft
                        }
                    } else {
                        if v > swipeThreshold {
                            activeGesture = .swipeDown
                        } else if v < -swipeThreshold {
                            activeGesture = .swipeUp
                        }
                    }
                }
        )

        .simultaneousGesture(
            TapGesture(count: 2)
                .onEnded {
                    activeGesture = .doubleTap
                }
        )

        .simultaneousGesture(
            LongPressGesture(minimumDuration: longPressDuration)
                .onEnded { _ in
                    activeGesture = .longPress
                }
        )

        .sheet(item: $activeGesture) { action in
            switch action {

            case .twoFingerUp:
                TwoFingerUpSheetView()

            case .twoFingerDown:
                TwoFingerDownSheetView()

            case .threeFingerUp:
                ThreeFingerUpSheetView()

            case .threeFingerDown:
                ThreeFingerDownSheetView()

            case .doubleTap:
                DoubleTapSheetView()

            case .longPress:
                LongPressSheetView()

            case .swipeLeft:
                swipeLeft()

            case .swipeRight:
                swipeRight()

            case .swipeUp:
                swipeUp()

            case .swipeDown:
                swipeDown()
            }
        }
    }
}
```

---

## Notes

* You can replace `.sheet` with `.fullScreenCover`
* GestureBridgeKit only detects gestures
* All navigation and logic decisions are yours
* No UIKit code is required in your app

--- 
## 8. Create Your Own Gesture Views (Important)

GestureBridgeKit **only detects gestures**.
It does **not** create or manage UI screens for you.

When you route gestures using `.sheet`, `.fullScreenCover`, or navigation, you **must create your own SwiftUI views** for each gesture.

Below is an example set of simple views you can create in your project.
You can customize these views with your own UI, logic, animations, or data.

---

### Example Gesture Views

```swift
struct swipeRight: View {
    var body: some View {
        Text("swipeRight")
    }
}

struct swipeLeft: View {
    var body: some View {
        Text("swipeLeft")
    }
}

struct swipeUp: View {
    var body: some View {
        Text("swipeUp")
    }
}

struct swipeDown: View {
    var body: some View {
        Text("swipeDown")
    }
}
```

---

### Two-Finger Gesture Views

```swift
struct TwoFingerUpSheetView: View {
    var body: some View {
        Text("2 finger up!")
    }
}

struct TwoFingerDownSheetView: View {
    var body: some View {
        Text("TwoFingerDownSheetView")
    }
}
```

---

### Three-Finger Gesture Views

```swift
struct ThreeFingerUpSheetView: View {
    var body: some View {
        Text("ThreeFingerUpSheetView")
    }
}

struct ThreeFingerDownSheetView: View {
    var body: some View {
        Text("ThreeFingerDownSheetView")
    }
}
```

---

### Double Tap and Long Press Views

```swift
struct DoubleTapSheetView: View {
    var body: some View {
        Text("DoubleTapSheetView")
    }
}

struct LongPressSheetView: View {
    var body: some View {
        Text("LongPressSheetView")
    }
}
```

---

## Final Notes

* You are free to rename these views
* You can replace `Text` with any complex UI
* You can pass data into these views
* You can use `.sheet`, `.fullScreenCover`, or navigation
* GestureBridgeKit does not limit how you handle gestures

 