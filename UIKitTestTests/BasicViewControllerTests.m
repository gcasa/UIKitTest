#import <XCTest/XCTest.h>
#import "BasicViewController.h"

@interface BasicViewControllerTests : XCTestCase {
@private
    BasicViewController *_controller;
    UIWindow *_testWindow;
    UIWindow *_previousKeyWindow;
}
@property (retain, nonatomic) BasicViewController *controller;
@property (retain, nonatomic) UIWindow *testWindow;
@property (retain, nonatomic) UIWindow *previousKeyWindow;
@end

@implementation BasicViewControllerTests
@synthesize controller = _controller;
@synthesize testWindow = _testWindow;
@synthesize previousKeyWindow = _previousKeyWindow;

- (void)setUp {
    [super setUp];
    // Hosted UIKit tests run on the main thread.
    XCTAssertTrue([NSThread isMainThread]);
    BasicViewController *controller = [[BasicViewController alloc] init];
    self.controller = controller;
    [controller release];
    [self.controller loadViewIfNeeded];
}

- (void)tearDown {
    [self.testWindow endEditing:YES];
    self.testWindow.hidden = YES;
    self.testWindow.rootViewController = nil;
    self.testWindow = nil;
    [self.previousKeyWindow makeKeyWindow];
    self.previousKeyWindow = nil;
    self.controller = nil;
    [super tearDown];
}

- (void)testXIBLoadsOutletsAndInitialValues {
    XCTAssertNotNil(self.controller.greetingLabel);
    XCTAssertNotNil(self.controller.nameTextField);
    XCTAssertNotNil(self.controller.greetButton);
    XCTAssertTrue([self.controller.greetingLabel isDescendantOfView:self.controller.view]);
    XCTAssertTrue([self.controller.nameTextField isDescendantOfView:self.controller.view]);
    XCTAssertTrue([self.controller.greetButton isDescendantOfView:self.controller.view]);
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, UIKit!");
    XCTAssertEqualObjects(self.controller.nameTextField.placeholder, @"Enter your name");
    XCTAssertEqualObjects([self.controller.greetButton titleForState:UIControlStateNormal], @"Say Hello");
    XCTAssertTrue(self.controller.greetButton.enabled);
}

- (void)testButtonActionUsesTextFieldInput {
    self.controller.nameTextField.text = @"  Taylor \n";
    // Dispatch through UIControl so a missing XIB action connection fails the test.
    [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, Taylor!");

    self.controller.nameTextField.text = @"Sam";
    [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, Sam!");
}

- (void)testEmptyInputRestoresDefaultGreeting {
    for (NSString *input in [NSArray arrayWithObjects:@"", @" \n ", nil]) {
        self.controller.nameTextField.text = @"Taylor";
        [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, Taylor!");
        self.controller.nameTextField.text = input;
        [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, UIKit!");
    }
}

- (void)testAutoLayoutPlacesControlsInsideViewAtDifferentSizes {
    NSArray *sizes = [NSArray arrayWithObjects:
        [NSValue valueWithCGSize:CGSizeMake(320, 568)],
        [NSValue valueWithCGSize:CGSizeMake(852, 393)]
    , nil];
    // Assert outlets before constructing an array (which cannot contain nil).
    XCTAssertNotNil(self.controller.greetingLabel);
    XCTAssertNotNil(self.controller.nameTextField);
    XCTAssertNotNil(self.controller.greetButton);
    if (!self.controller.greetingLabel || !self.controller.nameTextField || !self.controller.greetButton) {
        return;
    }
    UIView *view = self.controller.view;
    for (NSValue *value in sizes) {
        CGSize size = value.CGSizeValue;
        view.frame = (CGRect){CGPointZero, size};
        [view setNeedsLayout];
        [view layoutIfNeeded];
        for (UIView *control in [NSArray arrayWithObjects:self.controller.greetingLabel, self.controller.nameTextField, self.controller.greetButton, nil]) {
            XCTAssertFalse(control.hasAmbiguousLayout);
            CGRect frame = [control convertRect:control.bounds toView:view];
            XCTAssertGreaterThan(CGRectGetWidth(frame), 0);
            XCTAssertGreaterThan(CGRectGetHeight(frame), 0);
            XCTAssertTrue(CGRectContainsRect(view.bounds, frame));
        }
        CGRect label = [self.controller.greetingLabel convertRect:self.controller.greetingLabel.bounds toView:view];
        CGRect field = [self.controller.nameTextField convertRect:self.controller.nameTextField.bounds toView:view];
        CGRect button = [self.controller.greetButton convertRect:self.controller.greetButton.bounds toView:view];
        XCTAssertLessThan(CGRectGetMaxY(label), CGRectGetMinY(field));
        XCTAssertLessThan(CGRectGetMaxY(field), CGRectGetMinY(button));
        XCTAssertEqualWithAccuracy(CGRectGetHeight(button), 44, 0.5);
        XCTAssertEqualWithAccuracy(CGRectGetMinX(field), 24, 0.5);
        XCTAssertEqualWithAccuracy(CGRectGetMaxX(field), size.width - 24, 0.5);
    }
}

- (void)testAdditionalXIBControlsAndConnections {
    XCTAssertNotNil(self.controller.scrollView);
    XCTAssertNotNil(self.controller.contentStack);
    XCTAssertNotNil(self.controller.personalizationSwitch);
    XCTAssertNotNil(self.controller.progressSlider);
    XCTAssertNotNil(self.controller.progressView);
    XCTAssertNotNil(self.controller.progressLabel);
    XCTAssertNotNil(self.controller.fontSizeStepper);
    XCTAssertNotNil(self.controller.fontSizeLabel);
    XCTAssertNotNil(self.controller.greetingStyleControl);
    XCTAssertNotNil(self.controller.historyTableView);
    XCTAssertNotNil(self.controller.infoButton);
    XCTAssertEqual(self.controller.historyTableView.dataSource, self.controller);
    XCTAssertEqual(self.controller.historyTableView.delegate, self.controller);
    XCTAssertEqual(self.controller.nameTextField.delegate, self.controller);
    XCTAssertTrue(self.controller.personalizationSwitch.on);
    XCTAssertEqualWithAccuracy(self.controller.progressView.progress, 0.25, 0.001);
    XCTAssertEqualObjects(self.controller.progressLabel.text, @"Progress: 25%");
    XCTAssertEqual(self.controller.greetingStyleControl.numberOfSegments, 2);
    XCTAssertEqual(self.controller.greetingStyleControl.selectedSegmentIndex, 0);
    XCTAssertEqual([self.controller.historyTableView numberOfRowsInSection:0], 0);
}

- (void)testSwitchDisablesPersonalizationAndRestoresEnteredName {
    self.controller.nameTextField.text = @"Taylor";
    [self.controller.personalizationSwitch setOn:NO animated:NO];
    [self.controller.personalizationSwitch sendActionsForControlEvents:UIControlEventValueChanged];
    XCTAssertFalse(self.controller.nameTextField.enabled);
    [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, UIKit!");
    XCTAssertEqualObjects(self.controller.nameTextField.text, @"Taylor");

    [self.controller.personalizationSwitch setOn:YES animated:NO];
    [self.controller.personalizationSwitch sendActionsForControlEvents:UIControlEventValueChanged];
    XCTAssertTrue(self.controller.nameTextField.enabled);
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, Taylor!");
}

- (void)testSliderUpdatesProgressIncludingBounds {
    for (NSNumber *value in [NSArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithDouble:0.5], [NSNumber numberWithInt:1], nil]) {
        self.controller.progressSlider.value = value.floatValue;
        [self.controller.progressSlider sendActionsForControlEvents:UIControlEventValueChanged];
        XCTAssertEqualWithAccuracy(self.controller.progressView.progress, value.floatValue, 0.001);
        XCTAssertEqualObjects(self.controller.progressLabel.text,
            ([NSString stringWithFormat:@"Progress: %.0f%%", value.floatValue * 100]));
    }
    self.controller.progressSlider.value = 2;
    [self.controller.progressSlider sendActionsForControlEvents:UIControlEventValueChanged];
    XCTAssertEqualWithAccuracy(self.controller.progressView.progress, 1, 0.001);
    self.controller.progressSlider.value = -1;
    [self.controller.progressSlider sendActionsForControlEvents:UIControlEventValueChanged];
    XCTAssertEqualWithAccuracy(self.controller.progressView.progress, 0, 0.001);
}

- (void)testStepperUpdatesFontAndLabel {
    XCTAssertEqualWithAccuracy(self.controller.fontSizeStepper.minimumValue, 16, 0.001);
    XCTAssertEqualWithAccuracy(self.controller.fontSizeStepper.maximumValue, 32, 0.001);
    XCTAssertEqualWithAccuracy(self.controller.fontSizeStepper.stepValue, 2, 0.001);
    for (NSNumber *value in [NSArray arrayWithObjects:[NSNumber numberWithInt:16], [NSNumber numberWithInt:22], [NSNumber numberWithInt:32], nil]) {
        self.controller.fontSizeStepper.value = value.doubleValue;
        [self.controller.fontSizeStepper sendActionsForControlEvents:UIControlEventValueChanged];
        XCTAssertEqualWithAccuracy(self.controller.greetingLabel.font.pointSize, value.doubleValue, 0.001);
        XCTAssertEqualObjects(self.controller.fontSizeLabel.text,
            ([NSString stringWithFormat:@"Greeting font: %@ pt", value]));
    }
}

- (void)testSegmentedControlChangesGreetingWithoutAddingHistory {
    self.controller.nameTextField.text = @"Taylor";
    self.controller.greetingStyleControl.selectedSegmentIndex = 1;
    [self.controller.greetingStyleControl sendActionsForControlEvents:UIControlEventValueChanged];
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Welcome, Taylor!");
    XCTAssertEqual([self.controller.historyTableView numberOfRowsInSection:0], 0);
    [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Welcome, Taylor!");
    XCTAssertEqual([self.controller.historyTableView numberOfRowsInSection:0], 1);
    self.controller.greetingStyleControl.selectedSegmentIndex = 0;
    [self.controller.greetingStyleControl sendActionsForControlEvents:UIControlEventValueChanged];
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, Taylor!");
}

- (void)testHistoryRendersNewestFirstAndSupportsDeletion {
    [self hostControllerInWindow];
    UITableView *table = self.controller.historyTableView;
    for (NSString *name in [NSArray arrayWithObjects:@"Taylor", @"Sam", @"Alex", nil]) {
        self.controller.nameTextField.text = name;
        [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    [table layoutIfNeeded];
    XCTAssertEqual([table numberOfRowsInSection:0], 3);
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    NSIndexPath *second = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [table cellForRowAtIndexPath:first];
    XCTAssertNotNil(cell);
    XCTAssertEqualObjects(cell.textLabel.text, @"Hello, Alex!");
    XCTAssertEqual(cell.accessoryType, UITableViewCellAccessoryDisclosureIndicator);
    XCTAssertEqualObjects([table cellForRowAtIndexPath:second].textLabel.text, @"Hello, Sam!");

    // Exercise the data source callback used by UITableView's swipe-to-delete UI.
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [table.dataSource tableView:table commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:second];
    [table layoutIfNeeded];
    [UIView setAnimationsEnabled:animationsEnabled];
    XCTAssertEqual([table numberOfRowsInSection:0], 2);
    XCTAssertEqualObjects([table cellForRowAtIndexPath:second].textLabel.text, @"Hello, Taylor!");
    [UIView setAnimationsEnabled:NO];
    [table.dataSource tableView:table commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:first];
    [table.dataSource tableView:table commitEditingStyle:UITableViewCellEditingStyleDelete forRowAtIndexPath:first];
    [table layoutIfNeeded];
    [UIView setAnimationsEnabled:animationsEnabled];
    XCTAssertEqual([table numberOfRowsInSection:0], 0);
    [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    XCTAssertEqual([table numberOfRowsInSection:0], 1);
}

- (void)hostControllerInWindow {
    self.previousKeyWindow = [[[UIApplication sharedApplication] delegate] window];
    UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.controller];
    window.rootViewController = navigation;
    self.testWindow = window;
    [navigation release];
    [window release];
    [self.testWindow makeKeyAndVisible];
    [self.testWindow layoutIfNeeded];
    [self.controller.view layoutIfNeeded];
}

- (void)testHistorySelectionPushesDetailAndCanReturn {
    [self hostControllerInWindow];
    self.controller.nameTextField.text = @"Taylor";
    [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    UITableView *table = self.controller.historyTableView;
    UINavigationController *navigation = self.controller.navigationController;
    NSIndexPath *first = [NSIndexPath indexPathForRow:0 inSection:0];
    [table selectRowAtIndexPath:first animated:NO scrollPosition:UITableViewScrollPositionNone];
    // Programmatic selection doesn't invoke the delegate, so dispatch it explicitly.
    [table.delegate tableView:table didSelectRowAtIndexPath:first];
    NSPredicate *finished = [NSPredicate predicateWithFormat:
        @"topViewController != %@ AND transitionCoordinator == nil", self.controller];
    [self expectationForPredicate:finished evaluatedWithObject:navigation handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
    XCTAssertEqual(navigation.viewControllers.count, 2);
    UIViewController *detail = navigation.topViewController;
    XCTAssertEqualObjects(detail.title, @"Greeting Detail");
    UILabel *greeting = nil;
    for (UIView *view in detail.view.subviews) {
        if ([view.accessibilityIdentifier isEqualToString:@"detailGreeting"] && [view isKindOfClass:[UILabel class]]) {
            greeting = (UILabel *)view;
        }
    }
    XCTAssertNotNil(greeting);
    XCTAssertEqualObjects(greeting.text, @"Hello, Taylor!");
    XCTAssertNil(table.indexPathForSelectedRow);
    [navigation popViewControllerAnimated:NO];
    XCTAssertEqual(navigation.topViewController, self.controller);
    XCTAssertEqual([table numberOfRowsInSection:0], 1);
}

- (void)testInfoButtonPresentsDismissibleAlert {
    [self hostControllerInWindow];
    [self.controller.infoButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    NSPredicate *presented = [NSPredicate predicateWithFormat:
        @"presentedViewController != nil AND presentedViewController.transitionCoordinator == nil"];
    [self expectationForPredicate:presented evaluatedWithObject:self.controller handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
    UIViewController *presentedController = self.controller.presentedViewController;
    XCTAssertTrue([presentedController isKindOfClass:[UIAlertController class]]);
    if (![presentedController isKindOfClass:[UIAlertController class]]) { return; }
    UIAlertController *alert = (UIAlertController *)presentedController;
    XCTAssertEqualObjects(alert.title, @"UIKit Playground");
    XCTAssertEqual(alert.preferredStyle, UIAlertControllerStyleAlert);
    XCTAssertEqual(alert.actions.count, 1);
    XCTAssertEqualObjects(alert.actions.firstObject.title, @"OK");
    XCTAssertTrue(alert.actions.firstObject.enabled);
    [self.controller dismissViewControllerAnimated:NO completion:nil];
    NSPredicate *dismissed = [NSPredicate predicateWithFormat:@"presentedViewController == nil"];
    [self expectationForPredicate:dismissed evaluatedWithObject:self.controller handler:nil];
    [self waitForExpectationsWithTimeout:3 handler:nil];
    XCTAssertNil(self.controller.presentedViewController);
}

- (void)testReturnKeyDelegateSendsGreetingAndResignsFirstResponder {
    [self hostControllerInWindow];
    XCTAssertTrue([self.controller.nameTextField becomeFirstResponder]);
    XCTAssertTrue(self.controller.nameTextField.isFirstResponder);
    self.controller.nameTextField.text = @"Taylor";
    XCTAssertTrue([self.controller.nameTextField.delegate textFieldShouldReturn:self.controller.nameTextField]);
    XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, Taylor!");
    XCTAssertFalse(self.controller.nameTextField.isFirstResponder);
    XCTAssertEqual([self.controller.historyTableView numberOfRowsInSection:0], 1);
}

- (void)testScrollViewMakesBottomControlsReachableAtDifferentSizes {
    for (NSValue *value in [NSArray arrayWithObjects:[NSValue valueWithCGSize:CGSizeMake(320, 568)],
                             [NSValue valueWithCGSize:CGSizeMake(852, 393)], nil]) {
        self.controller.view.frame = (CGRect){CGPointZero, value.CGSizeValue};
        [self.controller.view setNeedsLayout];
        [self.controller.view layoutIfNeeded];
        UIScrollView *scroll = self.controller.scrollView;
        XCTAssertFalse(scroll.hasAmbiguousLayout);
        XCTAssertFalse(self.controller.contentStack.hasAmbiguousLayout);
        XCTAssertGreaterThan(scroll.contentSize.height, scroll.bounds.size.height);
        XCTAssertEqualWithAccuracy(scroll.contentSize.width, scroll.bounds.size.width, 0.5);
        CGFloat previousBottom = -CGFLOAT_MAX;
        for (UIView *control in self.controller.contentStack.arrangedSubviews) {
            XCTAssertFalse(control.hasAmbiguousLayout);
            XCTAssertGreaterThan(control.bounds.size.height, 0);
            XCTAssertGreaterThanOrEqual(CGRectGetMinY(control.frame), previousBottom);
            previousBottom = CGRectGetMaxY(control.frame);
        }
        CGRect buttonRect = [self.controller.infoButton convertRect:self.controller.infoButton.bounds toView:scroll];
        [scroll scrollRectToVisible:buttonRect animated:NO];
        XCTAssertGreaterThan(scroll.contentOffset.y, 0);
        XCTAssertTrue(CGRectContainsRect(scroll.bounds, buttonRect));
        [scroll setContentOffset:CGPointZero animated:NO];
    }
}

- (void)dealloc {
    [_controller release];
    [_testWindow release];
    [_previousKeyWindow release];
    [super dealloc];
}
@end
