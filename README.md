# UIKitTest

A small Objective-C iOS app with a XIB-backed interface and four hosted XCTest tests for basic UIKit functionality. The project uses Automatic Reference Counting (ARC) and has no Swift source files or external dependencies.

## Requirements

- macOS with Xcode and an installed iOS simulator runtime.
- iOS 15.0 or later (the project's deployment target).

The project was verified with Xcode 26.3 on an iPhone 17 Pro simulator running iOS 26.2: all four tests passed.

## Run the app

1. Open `UIKitTest.xcodeproj` in Xcode.
2. Select the `UIKitTest` scheme and an iOS simulator.
3. Press **Command-R**.
4. Enter a name and tap **Say Hello**. The label displays a personalized greeting. Empty or whitespace-only input restores `Hello, UIKit!`.

## Run the tests

In Xcode, select the `UIKitTest` scheme and an iOS simulator, then press **Command-U**.

Alternatively, run this command from the project directory:

```sh
xcodebuild test \
  -project UIKitTest.xcodeproj \
  -scheme UIKitTest \
  -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=26.2' \
  CODE_SIGNING_ALLOWED=NO
```

If that simulator is not installed, list the available destinations and substitute one in the command:

```sh
xcodebuild -showdestinations -project UIKitTest.xcodeproj -scheme UIKitTest
```

Simulator runs do not require a development team. To run on a physical device, configure signing for the app and test targets in Xcode.

## Project structure

```text
UIKitTest.xcodeproj/                   Xcode project and shared UIKitTest scheme
UIKitTest/
  main.m                              Application entry point
  AppDelegate.h / AppDelegate.m        Window and root view controller setup
  BasicViewController.h / .m           Outlets and greeting action
  BasicViewController.xib              Interface Builder layout and connections
UIKitTestTests/
  BasicViewControllerTests.m           Hosted XCTest suite
```

## XIB interface

`BasicViewController` loads `BasicViewController.xib` from the app bundle. The XIB's **File's Owner** is `BasicViewController`, with these outlet connections:

| Outlet | Interface element |
| --- | --- |
| `view` | Root view |
| `greetingLabel` | Label initially displaying `Hello, UIKit!` |
| `nameTextField` | Text field with the placeholder `Enter your name` |
| `greetButton` | Button titled `Say Hello` |

The button's **Touch Up Inside** event connects to `greet:`. The action trims leading and trailing whitespace from the input, updates the label, and resigns the text field's first-responder status.

The controls sit in a vertical stack view with 16-point spacing. Auto Layout positions the stack 24 points from the safe area's horizontal edges and 32 points below its top, with a 44-point button height. Open the XIB in Interface Builder to inspect or edit the layout and connections.

## Test coverage

| Test | Behavior verified |
| --- | --- |
| `testXIBLoadsOutletsAndInitialValues` | XIB loading, outlet connections, view hierarchy, initial text, and enabled button state |
| `testButtonActionUsesTextFieldInput` | The XIB-wired button action updates the greeting, trims input, and handles a subsequent name change |
| `testEmptyInputRestoresDefaultGreeting` | Empty and whitespace-only input restore the default greeting after a personalized greeting |
| `testAutoLayoutPlacesControlsInsideViewAtDifferentSizes` | Controls have nonzero sizes, unambiguous layout, no overlap, correct horizontal margins, and the expected button height at 320 × 568 and 852 × 393 points |

Each test creates a fresh controller and loads its view. These are hosted unit tests: button events are dispatched through `UIControl` programmatically, and layout sizes are assigned directly. They do not simulate physical taps, keyboard interaction, or device rotation.
