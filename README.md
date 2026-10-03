# UIKitTest

A small Objective-C iOS app with a XIB-backed interface and a searchable UIKit object gallery with hosted XCTest tests for UIKit controls, layout, tables, and view controller interactions. The project uses manual reference counting and has no Swift source files or external dependencies on iOS.

## Requirements

- macOS with Xcode and an installed iOS simulator runtime.
- iOS 15.0 or later (the project's deployment target).

The project targets iOS 15 and later. The calendar preview requires iOS 16; older systems display its availability requirement. Before the additional examples were added, all 20 hosted tests passed on the iPhone 17 Pro simulator running iOS 26.2 with Xcode 26.3.

## Objective-C compatibility and memory management

The app and tests use manual `retain` / `release` memory management. ARC, zeroing-weak support, and Clang modules are disabled in both Debug and Release configurations. Frameworks are linked explicitly.

Source code uses explicit instance variables and `@synthesize`, `retain` properties, balanced releases for allocated objects, and `dealloc` methods that call `[super dealloc]`. The application entry point uses `NSAutoreleasePool`. Retained outlets are released during controller teardown after clearing delegates and data sources.

The source avoids ARC ownership qualifiers, automatic property synthesis, object subscripting, collection/number literals, and lightweight generics. Ordinary Objective-C properties, dot syntax, protocols, and fast enumeration remain. Menu actions and drop completion handlers use blocks, so the compiler/runtime must support them.

This keeps the language usage conservative for Clang-based Objective-C toolchains on Linux. It does **not** provide a Linux port of Apple's frameworks: a Linux build still requires compatible Objective-C runtime, Foundation, UIKit, XIB loading, and (for tests) XCTest implementations, plus platform-specific build configuration. The supplied project builds with Xcode; The GNUstep build has been verified with libs-uikit and buildtool; it uses the installed UIKit framework without a project-specific buildtool.plist.

## Run the app

1. Open `UIKitTest.xcodeproj` in Xcode.
2. Select the `UIKitTest` scheme and an iOS simulator.
3. Press **Command-R**.
4. Enter a name and tap **Say Hello** (or press the keyboard's Done key). Each greeting appears at the top of the history table.
5. Try the **Use name in greeting** switch, **Hello / Welcome** selector, progress slider, and font-size stepper.
6. Tap a history row to open its detail screen; use Back to return. Swipe left on a row to delete it.
7. Scroll down to **About this playground** to display an alert.
8. Tap **Widgets** in the navigation bar to browse the UIKit object gallery. Switch between **Live widgets** and **All objects**, or search by class, category, or header name.

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

## Additional desktop examples

The gallery includes color wells, paste controls, standalone search fields, configured list cells, reusable headers, empty/loading content, button/context/edit menus, document and image selection, dictionary lookup, text formatting, glass/background effects, text drag and drop, pointer hover and tooltips. Search by class name in **Widgets → Live widgets**.

On GNUstep, menus and file panels use native AppKit interfaces. Right-click opens context menus. File selection reports the selected name; image selection updates a preview. Text formatting changes the preview's point size and bold face. Drag text from the teal source to the gray destination, or drop text from another desktop application.

Desktop limits are explicit: image selection uses files rather than an OS photo library; camera capture is unavailable. The offline dictionary contains a small technical glossary, extensible with `UIKitDictionary.plist`, rather than a full language dictionary. Glass uses softened snapshots and translucent highlighting rather than Apple's compositor. Drag/drop currently supports text through the native pasteboard; general NSItemProvider loading is unavailable in GNUstep Base. Newer examples show availability messages on older iOS releases; the added source requires the iOS 26 SDK when building with Xcode. The added examples have not been run on an iOS simulator.

## UIKit object gallery

The gallery adds **73 live examples** and **524 reference entries** derived from named Objective-C class declarations in the public UIKit headers of the iOS 26.2 SDK. This defines the inventory precisely: it includes deprecated and platform-specific declarations, but excludes categories, protocols, forward declarations, and Swift-only APIs. It is not a claim that every UIKit API is an instantiable widget or available on iOS 15.

Live examples cover labels, buttons, text entry, switches, sliders, steppers, segmented controls, progress, activity indicators, images, date and option pickers, calendar selection, page controls, search, scrolling, stacks, tables and cells, collections and cells, bars and bar items, blur, refresh, gestures, alerts and action sheets, sharing, color and font pickers, and controller containers. Interaction feedback appears above each preview. Controller examples open on demand and can be dismissed; action sheets and sharing anchor their popovers on iPad.

Every inventoried class has a reference card showing its superclass, declaring header, category, and availability annotations from the SDK. Classes without a curated demo are never dynamically instantiated. The SDK snapshot is bundled, so browsing works offline and does not enumerate private runtime classes. The list uses reusable table cells and creates only the selected preview.

- `UIKitCatalogViewController.h / .m`: searchable catalog and live/all scope selector.
- `UIKitDemoViewController.h / .m`: curated previews and reference cards.
- `UIKitCatalog.json`: checked-in public-header inventory.
- `Scripts/generate_uikit_catalog.py`: regenerates the inventory from the installed simulator SDK. Run `python3 Scripts/generate_uikit_catalog.py` after intentionally upgrading the snapshot; update the SDK labels in the gallery and this document if the version changes.

Additional hosted tests check catalog loading, unique entries, search and scope filtering, empty results, every live preview at narrow and landscape sizes, progress interaction, reference-card behavior, navigation from the Widgets button, and presentation/dismissal of every controller example. Existing greeting tests remain in place.
