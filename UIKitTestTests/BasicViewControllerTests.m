#import <XCTest/XCTest.h>
#import "BasicViewController.h"

@interface BasicViewControllerTests : XCTestCase
@property (strong, nonatomic) BasicViewController *controller;
@end

@implementation BasicViewControllerTests
- (void)setUp {
    [super setUp];
    // Hosted UIKit tests run on the main thread.
    XCTAssertTrue(NSThread.isMainThread);
    self.controller = [[BasicViewController alloc] init];
    [self.controller loadViewIfNeeded];
}

- (void)tearDown {
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
    for (NSString *input in @[@"", @" \n "]) {
        self.controller.nameTextField.text = @"Taylor";
        [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, Taylor!");
        self.controller.nameTextField.text = input;
        [self.controller.greetButton sendActionsForControlEvents:UIControlEventTouchUpInside];
        XCTAssertEqualObjects(self.controller.greetingLabel.text, @"Hello, UIKit!");
    }
}

- (void)testAutoLayoutPlacesControlsInsideViewAtDifferentSizes {
    NSArray<NSValue *> *sizes = @[
        [NSValue valueWithCGSize:CGSizeMake(320, 568)],
        [NSValue valueWithCGSize:CGSizeMake(852, 393)]
    ];
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
        for (UIView *control in @[self.controller.greetingLabel, self.controller.nameTextField, self.controller.greetButton]) {
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
@end
