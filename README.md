# UIKitTest

A small Objective-C iOS app with a XIB-backed interface and 14 hosted XCTest tests for UIKit controls, layout, tables, and view controller interactions. The project uses manual reference counting and has no Swift source files or external dependencies on iOS.

## Requirements

- macOS with Xcode and an installed iOS simulator runtime.
- iOS 15.0 or later (the project's deployment target).

The project was verified with Xcode 26.3 on an iPhone 17 Pro simulator running iOS 26.2: all 14 tests passed.

## Objective-C compatibility and memory management

The app and tests use manual `retain` / `release` memory management. ARC, zeroing-weak support, and Clang modules are disabled in both Debug and Release configurations. Frameworks are linked explicitly.

Source code uses explicit instance variables and `@synthesize`, `retain` properties, balanced releases for allocated objects, and `dealloc` methods that call `[super dealloc]`. The application entry point uses `NSAutoreleasePool`. Retained outlets are released during controller teardown after clearing delegates and data sources.

The source avoids ARC ownership qualifiers, automatic property synthesis, block literals, object subscripting, collection/number literals, and lightweight generics. Ordinary Objective-C properties, dot syntax, protocols, and fast enumeration remain.

This keeps the language usage conservative for Clang-based Objective-C toolchains on Linux. It does **not** provide a Linux port of Apple's frameworks: a Linux build still requires compatible Objective-C runtime, Foundation, UIKit, XIB loading, and (for tests) XCTest implementations, plus platform-specific build configuration. The supplied project builds with Xcode; Linux compilation has not been verified.

## Run the app

1. Open `UIKitTest.xcodeproj` in Xcode.
2. Select the `UIKitTest` scheme and an iOS simulator.
3. Press **Command-R**.
4. Enter a name and tap **Say Hello** (or press the keyboard's Done key). Each greeting appears at the top of the history table.
5. Try the **Use name in greeting** switch, **Hello / Welcome** selector, progress slider, and font-size stepper.
6. Tap a history row to open its detail screen; use Back to return. Swipe left on a row to delete it.
7. Scroll down to **About this playground** to display an alert.

Empty or whitespace-only input uses `UIKit` as the recipient. Turning personalization off disables the text field while preserving its contents. Changing controls updates the preview; sending a greeting adds a history row.

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
  AppDelegate.h / AppDelegate.m        Window and navigation controller setup
  BasicViewController.h / .m           Control actions, table data source, and navigation
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
| `scrollView` / `contentStack` | Scrollable vertical layout |
| `personalizationSwitch` | Enables or disables name input |
| `greetingStyleControl` | Selects Hello or Welcome |
| `progressSlider` / `progressView` / `progressLabel` | Slider, progress bar, and percentage readout |
| `fontSizeStepper` / `fontSizeLabel` | Greeting font size from 16 to 32 points in steps of 2 |
| `historyTableView` | Greeting history with selection and deletion |
| `infoButton` | Presents the playground information alert |

The button's **Touch Up Inside** event connects to `greet:`. The action trims leading and trailing whitespace from the input, updates the label and history table, and resigns the text field's first-responder status.

The controls sit in a vertical stack view with 16-point spacing inside a scroll view pinned to the safe area. Content and frame layout guides constrain its width and scrolling height, with 24-point horizontal margins, 32-point top padding, and 24-point bottom padding. Buttons are 44 points high; the history table is 176 points high and scrolls independently. All control actions and the table's delegate/data source connections are wired in the XIB. The text-field delegate is assigned in `viewDidLoad`. Open the XIB in Interface Builder to inspect or edit the layout and connections.

## Test coverage

| Test | Behavior verified |
| --- | --- |
| `testXIBLoadsOutletsAndInitialValues` | XIB loading, outlet connections, view hierarchy, initial text, and enabled button state |
| `testButtonActionUsesTextFieldInput` | The XIB-wired button action updates the greeting, trims input, and handles a subsequent name change |
| `testEmptyInputRestoresDefaultGreeting` | Empty and whitespace-only input restore the default greeting after a personalized greeting |
| `testAutoLayoutPlacesControlsInsideViewAtDifferentSizes` | Controls have nonzero sizes, unambiguous layout, no overlap, correct horizontal margins, and the expected button height at 320 × 568 and 852 × 393 points |
| `testAdditionalXIBControlsAndConnections` | Additional outlets, initial state, and delegate/data source connections |
| `testSwitchDisablesPersonalizationAndRestoresEnteredName` | Disabling name input and restoring personalization without losing entered text |
| `testSliderUpdatesProgressIncludingBounds` | Progress bar and percentage updates at zero, midpoint, maximum, and out-of-range values |
| `testStepperUpdatesFontAndLabel` | Stepper configuration, actual label font size, and size readout |
| `testSegmentedControlChangesGreetingWithoutAddingHistory` | Greeting style selection and preview versus history behavior |
| `testHistoryRendersNewestFirstAndSupportsDeletion` | Visible table cells, newest-first ordering, deletion through empty state, and insertion afterward |
| `testHistorySelectionPushesDetailAndCanReturn` | Navigation push/pop, detail content, selection clearing, and preserved history |
| `testInfoButtonPresentsDismissibleAlert` | Alert presentation, action configuration, and programmatic dismissal |
| `testReturnKeyDelegateSendsGreetingAndResignsFirstResponder` | Actual text-field focus, return-key delegate behavior, and focus resignation |
| `testScrollViewMakesBottomControlsReachableAtDifferentSizes` | Scroll content sizing, stack layout, and bottom-button reachability in portrait and landscape sizes |

Each test creates a fresh controller and loads its XIB. Tests for presentation, navigation, table rendering, and focus host that controller in a temporary window and restore the app window afterward.

These are hosted unit tests. Control events are dispatched through `UIControl`; table selection/deletion and keyboard Return callbacks are invoked through delegates. Alert dismissal is programmatic. Layout sizes are assigned directly. The suite does not simulate physical taps, swipe gestures, keyboard typing, or device rotation.
