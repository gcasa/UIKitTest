#import "UIKitDemoViewController.h"

@interface UIKitDemoViewController (ExtendedSamples)
- (BOOL)buildExtendedSample:(NSString *)name;
- (BOOL)openExtendedController;
@end

@implementation UIKitDemoViewController

+ (NSArray *)liveClassNames {
    return [NSArray arrayWithObjects:@"UIView", @"UILabel", @"UIButton", @"UITextField", @"UITextView",
        @"UISwitch", @"UISlider", @"UIStepper", @"UISegmentedControl", @"UIProgressView",
        @"UIActivityIndicatorView", @"UIImageView", @"UIDatePicker", @"UIPickerView", @"UIPageControl",
        @"UISearchBar", @"UIScrollView", @"UIStackView", @"UITableView", @"UITableViewCell",
        @"UICollectionView", @"UICollectionViewCell", @"UIToolbar", @"UIBarButtonItem", @"UINavigationBar",
        @"UINavigationItem", @"UITabBar", @"UITabBarItem", @"UIVisualEffectView", @"UIBlurEffect",
        @"UIRefreshControl", @"UIAlertController", @"UIActivityViewController", @"UIColorPickerViewController",
        @"UIFontPickerViewController", @"UIViewController", @"UINavigationController", @"UITabBarController",
        @"UIPageViewController", @"UISplitViewController", @"UITableViewController", @"UICollectionViewController",
        @"UITapGestureRecognizer", @"UILongPressGestureRecognizer", @"UIPanGestureRecognizer",
        @"UIPinchGestureRecognizer", @"UIRotationGestureRecognizer", @"UISwipeGestureRecognizer",
        @"UICalendarView", @"UIColorWell", @"UIPasteControl", @"UISearchTextField", @"UICollectionViewListCell", @"UITableViewHeaderFooterView", @"UIContentUnavailableView", @"UIMenu", @"UIAction", @"UICommand", @"UIContextMenuInteraction", @"UIEditMenuInteraction", @"UIDocumentPickerViewController", @"UIDocumentBrowserViewController", @"UIImagePickerController", @"UIReferenceLibraryViewController", @"UITextFormattingViewController", @"UIGlassEffect", @"UIGlassContainerEffect", @"UIBackgroundExtensionView", @"UIDragInteraction", @"UIDropInteraction", @"UIHoverGestureRecognizer", @"UIPointerInteraction", @"UIToolTipInteraction", nil];
}

- (id)initWithEntry:(NSDictionary *)entry {
    self = [super initWithNibName:nil bundle:nil];
    if (self) _entry = [entry copy];
    return self;
}

- (UILabel *)label:(NSString *)text style:(UIFontTextStyle)style {
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.text = text;
    label.numberOfLines = 0;
    label.font = [UIFont preferredFontForTextStyle:style];
    label.adjustsFontForContentSizeCategory = YES;
    return label;
}

- (UIButton *)button:(NSString *)title action:(SEL)action {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    button.titleLabel.adjustsFontForContentSizeCategory = YES;
    button.titleLabel.numberOfLines = 0;
    [button.heightAnchor constraintGreaterThanOrEqualToConstant:44].active = YES;
    [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)addSample:(UIView *)sample height:(CGFloat)height {
    _sample = [sample retain];
    sample.accessibilityIdentifier = @"liveSample";
    [_stack addArrangedSubview:sample];
    if (height > 0) [sample.heightAnchor constraintEqualToConstant:height].active = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *name = [_entry objectForKey:@"name"];
    self.title = name;
    self.view.backgroundColor = [UIColor systemGroupedBackgroundColor];
    UIScrollView *scroll = [[[UIScrollView alloc] init] autorelease];
    scroll.translatesAutoresizingMaskIntoConstraints = NO;
    scroll.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:scroll];
    _stack = [[UIStackView alloc] init];
    _stack.axis = UILayoutConstraintAxisVertical;
    _stack.spacing = 20;
    _stack.translatesAutoresizingMaskIntoConstraints = NO;
    [scroll addSubview:_stack];
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
        [scroll.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [scroll.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [scroll.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor],
        [scroll.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor],
        [_stack.topAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.topAnchor constant:24],
        [_stack.bottomAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.bottomAnchor constant:-24],
        [_stack.leadingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.leadingAnchor constant:20],
        [_stack.trailingAnchor constraintEqualToAnchor:scroll.contentLayoutGuide.trailingAnchor constant:-20],
        [_stack.widthAnchor constraintEqualToAnchor:scroll.frameLayoutGuide.widthAnchor constant:-40], nil]];
    [_stack addArrangedSubview:[self label:name style:UIFontTextStyleTitle1]];
    [_stack addArrangedSubview:[self label:[NSString stringWithFormat:@"%@\nInherits from %@\nDeclared in %@",
        [_entry objectForKey:@"category"], [_entry objectForKey:@"superclass"], [_entry objectForKey:@"header"]]
        style:UIFontTextStyleSubheadline]];
    _feedback = [[self label:@"Interact with the example below." style:UIFontTextStyleBody] retain];
    _feedback.accessibilityIdentifier = @"demoFeedback";
    [_stack addArrangedSubview:_feedback];
    if ([[[self class] liveClassNames] containsObject:name]) {
        [self buildSample:name];
    } else {
        _feedback.text = @"Reference object. This class has no standalone live example in this gallery. It may support layout, data, events, rendering, or a platform-specific interface.";
    }
    NSString *availability = [_entry objectForKey:@"availability"];
    if (availability.length) {
        [_stack addArrangedSubview:[self label:@"SDK availability declarations" style:UIFontTextStyleHeadline]];
        [_stack addArrangedSubview:[self label:availability style:UIFontTextStyleCaption1]];
    }
    [_stack addArrangedSubview:[self label:@"This catalog reflects public Objective-C declarations in the iOS 26.2 SDK. Availability and deprecation declarations apply; a reference card does not imply support on this device." style:UIFontTextStyleFootnote]];
}

- (void)buildSample:(NSString *)name {
    if ([self buildExtendedSample:name]) return;
    if ([name isEqualToString:@"UILabel"]) {
        [self addSample:[self label:@"Hello, UIKit!\nLabels support multiple lines and Dynamic Type." style:UIFontTextStyleTitle2] height:0];
    } else if ([name isEqualToString:@"UIButton"]) {
        [self addSample:[self button:@"Tap me" action:@selector(tapped:)] height:0];
        UIButton *menuButton=[UIButton buttonWithType:UIButtonTypeSystem]; [menuButton setTitle:@"Button menu" forState:UIControlStateNormal]; menuButton.menu=[self exampleMenu]; menuButton.showsMenuAsPrimaryAction=YES; [_stack addArrangedSubview:menuButton];
    } else if ([name isEqualToString:@"UITextField"]) {
        UITextField *field = [[[UITextField alloc] init] autorelease];
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.placeholder = @"Type something";
        field.accessibilityLabel = @"Example text field";
        [field addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [field addTarget:field action:@selector(resignFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
        [self addSample:field height:48];
    } else if ([name isEqualToString:@"UITextView"]) {
        UITextView *text = [[[UITextView alloc] init] autorelease];
        text.text = @"An editable, scrollable text view. Tap here to write multiple lines.";
        text.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        text.adjustsFontForContentSizeCategory = YES;
        text.accessibilityLabel = @"Example text view";
        [self addSample:text height:180];
    } else if ([name isEqualToString:@"UISwitch"]) {
        UISwitch *control = [[[UISwitch alloc] init] autorelease];
        control.accessibilityLabel = @"Example switch";
        [control addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSample:control height:0];
    } else if ([name isEqualToString:@"UISlider"] || [name isEqualToString:@"UIProgressView"]) {
        UISlider *slider = [[[UISlider alloc] init] autorelease];
        slider.value = 0.5;
        slider.accessibilityLabel = @"Example progress";
        [slider addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        if ([name isEqualToString:@"UIProgressView"]) {
            UIProgressView *progress = [[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault] autorelease];
            progress.progress = slider.value;
            [self addSample:progress height:0];
            [_stack addArrangedSubview:slider];
        } else [self addSample:slider height:0];
    } else if ([name isEqualToString:@"UIStepper"]) {
        UIStepper *stepper = [[[UIStepper alloc] init] autorelease];
        stepper.maximumValue = 10;
        stepper.accessibilityLabel = @"Example count";
        [stepper addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSample:stepper height:0];
    } else if ([name isEqualToString:@"UISegmentedControl"]) {
        UISegmentedControl *segments = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"First", @"Second", @"Third", nil]] autorelease];
        segments.selectedSegmentIndex = 0;
        [segments addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSample:segments height:0];
    } else if ([name isEqualToString:@"UIActivityIndicatorView"]) {
        UIActivityIndicatorView *spinner = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge] autorelease];
        spinner.hidesWhenStopped = NO;
        [spinner startAnimating];
        [self addSample:spinner height:60];
        [_stack addArrangedSubview:[self button:@"Start / stop" action:@selector(toggleSpinner:)]];
    } else if ([name isEqualToString:@"UIImageView"]) {
        UIImageView *image = [[[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"photo.artframe"]] autorelease];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.isAccessibilityElement = YES;
        image.accessibilityLabel = @"Example framed photograph symbol";
        [self addSample:image height:150];
    } else if ([name isEqualToString:@"UIDatePicker"]) {
        UIDatePicker *picker = [[[UIDatePicker alloc] init] autorelease];
        picker.datePickerMode = UIDatePickerModeDateAndTime;
        picker.preferredDatePickerStyle = UIDatePickerStyleCompact;
        [picker addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSample:picker height:50];
    } else if ([name isEqualToString:@"UIPickerView"]) {
        UIPickerView *picker = [[[UIPickerView alloc] init] autorelease];
        picker.dataSource = self;
        picker.delegate = self;
        [self addSample:picker height:180];
    } else if ([name isEqualToString:@"UICalendarView"]) {
        if (@available(iOS 16.0, *)) {
            UICalendarView *calendar = [[[UICalendarView alloc] init] autorelease];
            calendar.selectionBehavior = [[[UICalendarSelectionSingleDate alloc] initWithDelegate:nil] autorelease];
            [self addSample:calendar height:0];
        } else _feedback.text = @"UICalendarView requires iOS 16 or later.";
    } else if ([name isEqualToString:@"UIPageControl"]) {
        UIPageControl *pages = [[[UIPageControl alloc] init] autorelease];
        pages.numberOfPages = 5;
        pages.pageIndicatorTintColor = [UIColor systemGrayColor];
        pages.currentPageIndicatorTintColor = [UIColor systemBlueColor];
        [pages addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSample:pages height:44];
    } else if ([name isEqualToString:@"UISearchBar"]) {
        UISearchBar *search = [[[UISearchBar alloc] init] autorelease];
        search.placeholder = @"Search example";
        search.delegate = self;
        [self addSample:search height:56];
    } else if ([name isEqualToString:@"UITableView"] || [name isEqualToString:@"UITableViewCell"] || [name isEqualToString:@"UIRefreshControl"]) {
        UITableView *table = [[[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain] autorelease];
        table.dataSource = self;
        table.delegate = self;
        table.rowHeight = 52;
        if ([name isEqualToString:@"UIRefreshControl"]) {
            UIRefreshControl *refresh = [[[UIRefreshControl alloc] init] autorelease];
            [refresh addTarget:self action:@selector(refreshed:) forControlEvents:UIControlEventValueChanged];
            table.refreshControl = refresh;
            _feedback.text = @"Pull the list down to refresh.";
        }
        [self addSample:table height:220];
    } else if ([name isEqualToString:@"UICollectionView"] || [name isEqualToString:@"UICollectionViewCell"]) {
        [self addSample:[self collection] height:230];
    } else if ([name isEqualToString:@"UIToolbar"] || [name isEqualToString:@"UIBarButtonItem"]) {
        UIToolbar *toolbar = [[[UIToolbar alloc] init] autorelease];
        toolbar.items = [NSArray arrayWithObjects:
            [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapped:)] autorelease],
            [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease],
            [[[UIBarButtonItem alloc] initWithTitle:@"Action" style:UIBarButtonItemStylePlain target:self action:@selector(tapped:)] autorelease], nil];
        [self addSample:toolbar height:44];
    } else if ([name isEqualToString:@"UINavigationBar"] || [name isEqualToString:@"UINavigationItem"]) {
        UINavigationBar *bar = [[[UINavigationBar alloc] init] autorelease];
        UINavigationItem *item = [[[UINavigationItem alloc] initWithTitle:@"Navigation title"] autorelease];
        item.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapped:)] autorelease];
        [bar setItems:[NSArray arrayWithObject:item]];
        [self addSample:bar height:44];
    } else if ([name isEqualToString:@"UITabBar"] || [name isEqualToString:@"UITabBarItem"]) {
        UITabBar *bar = [[[UITabBar alloc] init] autorelease];
        bar.items = [NSArray arrayWithObjects:
            [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0] autorelease],
            [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1] autorelease], nil];
        bar.selectedItem = bar.items.firstObject;
        bar.delegate = self;
        [self addSample:bar height:60];
    } else if ([name isEqualToString:@"UIVisualEffectView"] || [name isEqualToString:@"UIBlurEffect"]) {
        UIView *backdrop = [[[UIView alloc] init] autorelease];
        backdrop.backgroundColor = [UIColor systemTealColor];
        UILabel *label = [self label:@"Material blur" style:UIFontTextStyleLargeTitle];
        label.frame = CGRectMake(12, 24, 240, 60);
        [backdrop addSubview:label];
        UIVisualEffectView *effect = [[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemMaterial]] autorelease];
        effect.frame = CGRectMake(0, 65, 1000, 75);
        [backdrop addSubview:effect];
        backdrop.clipsToBounds = YES;
        [self addSample:backdrop height:140];
    } else if ([name isEqualToString:@"UIStackView"]) {
        UIStackView *stack = [[[UIStackView alloc] init] autorelease];
        stack.axis = UILayoutConstraintAxisVertical;
        stack.spacing = 12;
        for (NSString *text in [NSArray arrayWithObjects:@"First arranged view", @"Second arranged view", @"Third arranged view", nil]) {
            UILabel *label = [self label:text style:UIFontTextStyleBody];
            label.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
            [stack addArrangedSubview:label];
        }
        [self addSample:stack height:0];
    } else if ([name isEqualToString:@"UIScrollView"]) {
        UIScrollView *scroll = [[[UIScrollView alloc] init] autorelease];
        scroll.contentSize = CGSizeMake(900, 140);
        for (NSInteger i = 0; i < 6; i++) {
            UILabel *label = [self label:[NSString stringWithFormat:@"Page %ld", (long)i + 1] style:UIFontTextStyleHeadline];
            label.frame = CGRectMake(i * 150, 0, 140, 140);
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
            [scroll addSubview:label];
        }
        _feedback.text = @"Swipe horizontally to reveal more content.";
        [self addSample:scroll height:155];
    } else if ([name hasSuffix:@"Controller"]) {
        [self addSample:[self button:@"Open example" action:@selector(openController:)] height:0];
        if ([name isEqualToString:@"UIAlertController"]) [_stack addArrangedSubview:[self button:@"Open action sheet" action:@selector(openActionSheet:)]];
    } else {
        UIView *view = [[[UIView alloc] init] autorelease];
        view.backgroundColor = [UIColor systemTealColor];
        view.layer.cornerRadius = 16;
        [self addSample:view height:160];
        if ([name hasSuffix:@"GestureRecognizer"]) {
            Class gestureClass = NSClassFromString(name);
            UIGestureRecognizer *gesture = [[[gestureClass alloc] initWithTarget:self action:@selector(gestureChanged:)] autorelease];
            [view addGestureRecognizer:gesture];
            _feedback.text = [NSString stringWithFormat:@"Try %@ on the colored view.", name];
            view.isAccessibilityElement = YES;
            view.accessibilityLabel = @"Gesture demonstration area";
            view.accessibilityHint = _feedback.text;
        }
    }
}

- (void)tapped:(id)sender { _feedback.text = [NSString stringWithFormat:@"Tapped %ld times", (long)++_tapCount]; }
- (void)textChanged:(UITextField *)sender { _feedback.text = sender.text.length ? sender.text : @"Type something below."; }
- (void)toggleSpinner:(id)sender {
    UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)_sample;
    if (spinner.isAnimating) [spinner stopAnimating]; else [spinner startAnimating];
    _feedback.text = spinner.isAnimating ? @"Animating" : @"Stopped";
}
- (void)valueChanged:(id)sender {
    if ([sender isKindOfClass:[UISwitch class]]) _feedback.text = [sender isOn] ? @"On" : @"Off";
    else if ([sender isKindOfClass:[UISlider class]]) {
        float value = [(UISlider *)sender value];
        _feedback.text = [NSString stringWithFormat:@"Progress: %.0f%%", value * 100];
        if ([_sample isKindOfClass:[UIProgressView class]]) [(UIProgressView *)_sample setProgress:value];
    } else if ([sender isKindOfClass:[UIStepper class]]) _feedback.text = [NSString stringWithFormat:@"Count: %.0f", [(UIStepper *)sender value]];
    else if ([sender isKindOfClass:[UISegmentedControl class]]) _feedback.text = [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]];
    else if ([sender isKindOfClass:[UIPageControl class]]) _feedback.text = [NSString stringWithFormat:@"Page %ld of 5", (long)[sender currentPage] + 1];
    else if ([sender isKindOfClass:[UIDatePicker class]]) _feedback.text = [NSDateFormatter localizedStringFromDate:[sender date] dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
}
- (void)refreshed:(UIRefreshControl *)sender {
    _feedback.text = [NSString stringWithFormat:@"Refreshed %ld times", (long)++_tapCount];
    [sender endRefreshing];
}
- (void)gestureChanged:(UIGestureRecognizer *)sender {
    _feedback.text = [NSString stringWithFormat:@"%@ recognized (state %ld)", NSStringFromClass([sender class]), (long)sender.state];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText { _feedback.text = [NSString stringWithFormat:@"Search: %@", searchText]; }
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar { [searchBar resignFirstResponder]; }
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item { _feedback.text = [NSString stringWithFormat:@"Selected %@", item.title]; }
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView { return 1; }
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component { return 5; }
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component { return [NSString stringWithFormat:@"Option %ld", (long)row + 1]; }
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component { _feedback.text = [self pickerView:pickerView titleForRow:row forComponent:component]; }
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return 8; }
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Sample"];
    if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Sample"] autorelease];
    cell.textLabel.text = [NSString stringWithFormat:@"Example row %ld", (long)indexPath.row + 1];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _feedback.text = [NSString stringWithFormat:@"Selected row %ld", (long)indexPath.row + 1];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (UICollectionView *)collection {
    UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
    layout.itemSize = CGSizeMake(88, 88);
    UICollectionView *collection = [[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout] autorelease];
    collection.backgroundColor = [UIColor clearColor];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Tile"];
    collection.dataSource = self;
    collection.delegate = self;
    return collection;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section { return 12; }
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Tile" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:1];
    if (!label) {
        label = [self label:@"" style:UIFontTextStyleHeadline];
        label.tag = 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.frame = cell.contentView.bounds;
        label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [cell.contentView addSubview:label];
    }
    label.text = [NSString stringWithFormat:@"%ld", (long)indexPath.item + 1];
    cell.backgroundColor = [UIColor tertiarySystemFillColor];
    cell.layer.cornerRadius = 12;
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _feedback.text = [NSString stringWithFormat:@"Selected tile %ld", (long)indexPath.item + 1];
}

- (UIViewController *)plainController:(NSString *)title {
    UIViewController *controller = [[[UIViewController alloc] init] autorelease];
    controller.title = title;
    controller.view.backgroundColor = [UIColor systemBackgroundColor];
    UILabel *label = [self label:title style:UIFontTextStyleTitle1];
    label.textAlignment = NSTextAlignmentCenter;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [controller.view addSubview:label];
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
        [label.centerYAnchor constraintEqualToAnchor:controller.view.centerYAnchor],
        [label.leadingAnchor constraintEqualToAnchor:controller.view.leadingAnchor constant:24],
        [label.trailingAnchor constraintEqualToAnchor:controller.view.trailingAnchor constant:-24], nil]];
    return controller;
}
- (void)dismissExample:(id)sender { [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)nextPage:(id)sender {
    UINavigationController *navigation = (UINavigationController *)self.presentedViewController;
    UIPageViewController *pages = (UIPageViewController *)navigation.topViewController;
    _tapCount = (_tapCount + 1) % 3;
    [pages setViewControllers:[NSArray arrayWithObject:[self plainController:[NSString stringWithFormat:@"Page %ld of 3", (long)_tapCount + 1]]]
        direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
}
- (void)openActionSheet:(UIButton *)sender { [self showAlertStyle:UIAlertControllerStyleActionSheet sender:sender]; }
- (void)showAlertStyle:(UIAlertControllerStyle)style sender:(UIView *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"UIKit example" message:@"A system presentation with a dismissible action." preferredStyle:style];
    [alert addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
    alert.popoverPresentationController.sourceView = sender;
    alert.popoverPresentationController.sourceRect = sender.bounds;
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)openController:(UIButton *)sender {
    if ([self openExtendedController]) return;
    NSString *name = [_entry objectForKey:@"name"];
    if ([name isEqualToString:@"UIAlertController"]) { [self showAlertStyle:UIAlertControllerStyleAlert sender:sender]; return; }
    if ([name isEqualToString:@"UIActivityViewController"]) {
        UIActivityViewController *activity = [[[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObject:@"Hello from UIKit Playground!"] applicationActivities:nil] autorelease];
        activity.popoverPresentationController.sourceView = sender;
        activity.popoverPresentationController.sourceRect = sender.bounds;
        [self presentViewController:activity animated:YES completion:nil];
        return;
    }
    UIViewController *controller = nil;
    if ([name isEqualToString:@"UIColorPickerViewController"]) controller = [[[UIColorPickerViewController alloc] init] autorelease];
    else if ([name isEqualToString:@"UIFontPickerViewController"]) controller = [[[UIFontPickerViewController alloc] initWithConfiguration:[[[UIFontPickerViewControllerConfiguration alloc] init] autorelease]] autorelease];
    else if ([name isEqualToString:@"UITabBarController"]) {
        UITabBarController *tabs = [[[UITabBarController alloc] init] autorelease];
        UIViewController *first = [self plainController:@"First tab"];
        first.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0] autorelease];
        UIViewController *second = [self plainController:@"Second tab"];
        second.tabBarItem = [[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1] autorelease];
        tabs.viewControllers = [NSArray arrayWithObjects:first, second, nil];
        controller = tabs;
    } else if ([name isEqualToString:@"UIPageViewController"]) {
        UIPageViewController *pages = [[[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil] autorelease];
        _tapCount = 0;
        [pages setViewControllers:[NSArray arrayWithObject:[self plainController:@"Page 1 of 3"]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        pages.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextPage:)] autorelease];
        controller = pages;
    } else if ([name isEqualToString:@"UISplitViewController"]) {
        UISplitViewController *split = [[[UISplitViewController alloc] initWithStyle:UISplitViewControllerStyleDoubleColumn] autorelease];
        UIViewController *primary = [self plainController:@"Primary column"];
        UIViewController *secondary = [self plainController:@"Secondary column"];
        for (UIViewController *column in [NSArray arrayWithObjects:primary, secondary, nil]) {
            column.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissExample:)] autorelease];
        }
        secondary.navigationItem.leftBarButtonItem = split.displayModeButtonItem;
        [split setViewController:[[[UINavigationController alloc] initWithRootViewController:primary] autorelease] forColumn:UISplitViewControllerColumnPrimary];
        [split setViewController:[[[UINavigationController alloc] initWithRootViewController:secondary] autorelease] forColumn:UISplitViewControllerColumnSecondary];
        split.preferredDisplayMode = UISplitViewControllerDisplayModeOneBesideSecondary;
        split.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:split animated:YES completion:nil];
        return;
    } else if ([name isEqualToString:@"UITableViewController"]) {
        UITableViewController *table = [[[UITableViewController alloc] initWithStyle:UITableViewStyleInsetGrouped] autorelease];
        table.tableView.dataSource = self;
        table.tableView.delegate = self;
        controller = table;
    } else if ([name isEqualToString:@"UICollectionViewController"]) {
        UICollectionViewFlowLayout *layout = [[[UICollectionViewFlowLayout alloc] init] autorelease];
        layout.itemSize = CGSizeMake(88, 88);
        UICollectionViewController *collection = [[[UICollectionViewController alloc] initWithCollectionViewLayout:layout] autorelease];
        [collection.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Tile"];
        collection.collectionView.dataSource = self;
        collection.collectionView.delegate = self;
        controller = collection;
    } else controller = [self plainController:@"A view controller owns this screen."];
    controller.title = name;
    controller.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissExample:)] autorelease];
    UINavigationController *navigation = [[[UINavigationController alloc] initWithRootViewController:controller] autorelease];
    [self presentViewController:navigation animated:YES completion:nil];
}


- (UIMenu *)exampleMenu {
    UILabel *feedback = _feedback;
    UIAction *hello = [UIAction actionWithTitle:@"Say hello" image:nil identifier:nil handler:^(UIAction *action) { feedback.text = @"Hello from the menu!"; }];
    UIAction *copy = [UIAction actionWithTitle:@"Copy sample text" image:nil identifier:nil handler:^(UIAction *action) { [UIPasteboard generalPasteboard].string = @"Copied from the UIKit menu"; feedback.text = @"Copied sample text to the clipboard."; }];
    UICommand *command = [UICommand commandWithTitle:@"Count an action" image:nil action:@selector(tapped:) propertyList:nil];
    return [UIMenu menuWithTitle:@"Example actions" children:[NSArray arrayWithObjects:hello, copy, command, nil]];
}

- (BOOL)buildExtendedSample:(NSString *)name {
#if !GNUSTEP
    BOOL available=YES;
    if ([name isEqualToString:@"UIPasteControl"] || [name isEqualToString:@"UIEditMenuInteraction"]) {
        if (@available(iOS 16.0, *)) {} else available=NO;
    }
    if ([name isEqualToString:@"UIContentUnavailableView"] || [name isEqualToString:@"UIToolTipInteraction"]) {
        if (@available(iOS 17.0, *)) {} else available=NO;
    }
    if ([name isEqualToString:@"UITextFormattingViewController"]) {
        if (@available(iOS 18.0, *)) {} else available=NO;
    }
    if ([name isEqualToString:@"UIGlassEffect"] || [name isEqualToString:@"UIGlassContainerEffect"] || [name isEqualToString:@"UIBackgroundExtensionView"]) {
        if (@available(iOS 26.0, *)) {} else available=NO;
    }
    if (!available) { [self addSample:[self label:@"This example requires a newer iOS version; see the availability information below." style:UIFontTextStyleBody] height:120]; return YES; }
#endif
    if ([name isEqualToString:@"UIColorWell"]) {
        UIColorWell *well = [[[UIColorWell alloc] init] autorelease];
        well.selectedColor = [UIColor systemBlueColor];
        [well addTarget:self action:@selector(colorWellChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSample:well height:64];
        _feedback.text = @"Click the color well and choose a color.";
    } else if ([name isEqualToString:@"UISearchTextField"]) {
        UISearchTextField *field = [[[UISearchTextField alloc] init] autorelease];
        field.placeholder = @"Standalone search field";
        [field addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSample:field height:44];
    } else if ([name isEqualToString:@"UIPasteControl"]) {
        UITextView *text = [[[UITextView alloc] init] autorelease]; text.text = @"Paste text here: "; text.font = [UIFont systemFontOfSize:17];
        _secondarySample = [text retain]; [_stack addArrangedSubview:text]; [text.heightAnchor constraintEqualToConstant:100].active = YES;
        UIPasteControl *paste = [[[UIPasteControl alloc] initWithConfiguration:[[[UIPasteControlConfiguration alloc] init] autorelease]] autorelease]; paste.target = text;
        [self addSample:paste height:44];
        [_stack addArrangedSubview:[self button:@"Copy example text" action:@selector(copyExample:)]];
        _feedback.text = @"Copy the example or text from another app, then press Paste.";
    } else if ([name isEqualToString:@"UICollectionViewListCell"]) {
        UICollectionViewListCell *cell = [[[UICollectionViewListCell alloc] init] autorelease];
        UIListContentConfiguration *configuration = [cell defaultContentConfiguration]; configuration.text = @"A configured list cell"; configuration.secondaryText = @"Title, subtitle and image supplied by a content configuration"; configuration.image = [UIImage systemImageNamed:@"doc.text"]; cell.contentConfiguration = configuration;
        [self addSample:cell height:100]; [_stack addArrangedSubview:[self button:@"Update content" action:@selector(updateContentExample:)]];
    } else if ([name isEqualToString:@"UITableViewHeaderFooterView"]) {
        UITableViewHeaderFooterView *header = [[[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"ExampleHeader"] autorelease];
        header.textLabel.text = @"Section heading"; header.detailTextLabel.text = @"Reusable header or footer content";
        [self addSample:header height:80]; [_stack addArrangedSubview:[self button:@"Update heading" action:@selector(updateContentExample:)]];
    } else if ([name isEqualToString:@"UIContentUnavailableView"]) {
        UIContentUnavailableConfiguration *configuration = [UIContentUnavailableConfiguration searchConfiguration];
        UIContentUnavailableView *view = [[[UIContentUnavailableView alloc] initWithConfiguration:configuration] autorelease];
        [self addSample:view height:160]; [_stack addArrangedSubview:[self button:@"Toggle empty / loading" action:@selector(updateContentExample:)]];
    } else if ([name isEqualToString:@"UIMenu"] || [name isEqualToString:@"UIAction"] || [name isEqualToString:@"UICommand"]) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem]; [button setTitle:@"Open actions menu" forState:UIControlStateNormal]; button.menu = [self exampleMenu]; button.showsMenuAsPrimaryAction = YES; [self addSample:button height:48];
    } else if ([name isEqualToString:@"UIContextMenuInteraction"]) {
        UILabel *label = [self label:@"Open the context menu here (right-click on desktop)" style:UIFontTextStyleHeadline]; label.userInteractionEnabled = YES; label.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
        [label addInteraction:[[[UIContextMenuInteraction alloc] initWithDelegate:self] autorelease]]; [self addSample:label height:140];
    } else if ([name isEqualToString:@"UIEditMenuInteraction"]) {
        UIButton *button = [self button:@"Show edit menu" action:@selector(showEditExample:)];
        _extraInteraction = [[UIEditMenuInteraction alloc] initWithDelegate:self]; [button addInteraction:_extraInteraction]; [self addSample:button height:48];
    } else if ([name isEqualToString:@"UIHoverGestureRecognizer"] || [name isEqualToString:@"UIPointerInteraction"] || [name isEqualToString:@"UIToolTipInteraction"]) {
        UIView *area = [[[UIView alloc] init] autorelease]; area.backgroundColor = [UIColor systemTealColor];
        [area addGestureRecognizer:[[[UIHoverGestureRecognizer alloc] initWithTarget:self action:@selector(hoverExample:)] autorelease]];
        [area addInteraction:[[[UIPointerInteraction alloc] initWithDelegate:nil] autorelease]];
        [area addInteraction:[[[UIToolTipInteraction alloc] initWithDefaultToolTip:@"This is a UIKit tooltip. Move the pointer away to dismiss it."] autorelease]];
        [self addSample:area height:140]; _feedback.text = @"Hover over the colored area; pause to see its tooltip.";
    } else if ([name isEqualToString:@"UIDragInteraction"] || [name isEqualToString:@"UIDropInteraction"]) {
        UIView *source = [[[UIView alloc] init] autorelease]; source.backgroundColor = [UIColor systemTealColor];
        [source addInteraction:[[[UIDragInteraction alloc] initWithDelegate:self] autorelease]];
        [self addSample:source height:90];
        UIView *target = [[[UIView alloc] init] autorelease]; target.backgroundColor = [UIColor secondarySystemGroupedBackgroundColor];
        [target addInteraction:[[[UIDropInteraction alloc] initWithDelegate:self] autorelease]];
        _secondarySample = [target retain]; [_stack addArrangedSubview:target]; [target.heightAnchor constraintEqualToConstant:110].active = YES;
        _feedback.text = @"Drag the teal source onto the gray destination. You can also drop text from another app.";
    } else if ([name isEqualToString:@"UIGlassEffect"] || [name isEqualToString:@"UIGlassContainerEffect"]) {
        UIView *backdrop = [[[UIView alloc] initWithFrame:CGRectMake(0,0,360,180)] autorelease];
        NSArray *colors = [NSArray arrayWithObjects:[UIColor systemBlueColor], [UIColor systemTealColor], [UIColor redColor], nil];
        UIStackView *bands=[[[UIStackView alloc] initWithFrame:backdrop.bounds] autorelease]; bands.axis=UILayoutConstraintAxisHorizontal; bands.distribution=UIStackViewDistributionFillEqually; bands.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        for (NSInteger i=0; i<3; i++) { UILabel *stripe = [self label:[NSString stringWithFormat:@"Color %ld",(long)i+1] style:UIFontTextStyleTitle2]; stripe.backgroundColor=[colors objectAtIndex:i]; [bands addArrangedSubview:stripe]; } [backdrop addSubview:bands];
        UIGlassEffect *glass = [UIGlassEffect effectWithStyle:UIGlassEffectStyleRegular]; glass.interactive = YES;
        UIVisualEffectView *effect = [[[UIVisualEffectView alloc] initWithEffect:glass] autorelease]; effect.frame=CGRectMake(20,45,320,90); effect.autoresizingMask=UIViewAutoresizingFlexibleWidth;
        UILabel *label=[self label:@"Glass over colored content" style:UIFontTextStyleHeadline]; label.frame=CGRectMake(12,16,296,60); label.autoresizingMask=UIViewAutoresizingFlexibleWidth; [effect.contentView addSubview:label]; [backdrop addSubview:effect];
        if ([name isEqualToString:@"UIGlassContainerEffect"]) { UIGlassContainerEffect *container = [[[UIGlassContainerEffect alloc] init] autorelease]; container.spacing=20; effect.effect=container; }
        _secondarySample=[effect retain]; [self addSample:backdrop height:180]; [_stack addArrangedSubview:[self button:@"Change tint" action:@selector(changeGlassExample:)]];
#if GNUSTEP
        _feedback.text=@"Desktop approximation: softened backdrop snapshots and a translucent highlight. Apple compositor animations are not reproduced.";
#endif
    } else if ([name isEqualToString:@"UIBackgroundExtensionView"]) {
        UIBackgroundExtensionView *extension = [[[UIBackgroundExtensionView alloc] initWithFrame:CGRectMake(0,0,360,180)] autorelease]; extension.automaticallyPlacesContentView=NO;
        UILabel *content=[self label:@"Content\nwith extended background" style:UIFontTextStyleTitle2]; content.frame=CGRectMake(90,20,180,140); content.backgroundColor=[UIColor systemTealColor]; content.autoresizingMask=UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        extension.contentView=content; [self addSample:extension height:180]; [_stack addArrangedSubview:[self button:@"Change background" action:@selector(changeGlassExample:)]];
    } else if ([name isEqualToString:@"UIDocumentPickerViewController"] || [name isEqualToString:@"UIDocumentBrowserViewController"] || [name isEqualToString:@"UIImagePickerController"] || [name isEqualToString:@"UIReferenceLibraryViewController"] || [name isEqualToString:@"UITextFormattingViewController"]) {
        if ([name isEqualToString:@"UIImagePickerController"]) { UIImageView *preview=[[[UIImageView alloc] init] autorelease]; preview.contentMode=UIViewContentModeScaleAspectFit; _secondarySample=[preview retain]; [_stack addArrangedSubview:preview]; [preview.heightAnchor constraintEqualToConstant:160].active=YES; }
        if ([name isEqualToString:@"UITextFormattingViewController"]) { UILabel *preview=[self label:@"Formatting changes update this text." style:UIFontTextStyleBody]; _secondarySample=[preview retain]; [_stack addArrangedSubview:preview]; }
        [self addSample:[self button:@"Open example" action:@selector(openController:)] height:48];
#if GNUSTEP
        if ([name isEqualToString:@"UIReferenceLibraryViewController"]) _feedback.text=@"Look up ‘interface’ in the bundled technical glossary. This is not a complete language dictionary.";
#endif
    } else return NO;
    return YES;
}
- (void)colorWellChanged:(UIColorWell *)sender { _feedback.text=@"Selected color updated."; _feedback.backgroundColor=sender.selectedColor; }
- (void)copyExample:(id)sender { [UIPasteboard generalPasteboard].string=@"Hello from UIPasteControl!"; _feedback.text=@"Copied. Press Paste to insert the text."; }
- (void)updateContentExample:(id)sender {
    _tapCount++;
    if ([_sample isKindOfClass:[UICollectionViewListCell class]]) { UIListContentConfiguration *c=[(UICollectionViewListCell *)_sample defaultContentConfiguration]; c.text=[NSString stringWithFormat:@"Updated row %ld",(long)_tapCount]; c.secondaryText=@"Configuration replaced without replacing the cell."; [(UICollectionViewListCell *)_sample setContentConfiguration:c]; }
    else if ([_sample isKindOfClass:[UITableViewHeaderFooterView class]]) [(UITableViewHeaderFooterView *)_sample textLabel].text=[NSString stringWithFormat:@"Section %ld",(long)_tapCount];
    else [(UIContentUnavailableView *)_sample setConfiguration:_tapCount%2 ? [UIContentUnavailableConfiguration loadingConfiguration] : [UIContentUnavailableConfiguration searchConfiguration]];
    _feedback.text=@"Content updated.";
}
- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction configurationForMenuAtLocation:(CGPoint)location {
    UIMenu *menu=[self exampleMenu];
    return [UIContextMenuConfiguration configurationWithIdentifier:nil previewProvider:nil actionProvider:^UIMenu *(NSArray *suggested) { return menu; }];
}
- (UIMenu *)editMenuInteraction:(UIEditMenuInteraction *)interaction menuForConfiguration:(UIEditMenuConfiguration *)configuration suggestedActions:(NSArray *)actions { return [self exampleMenu]; }
- (void)showEditExample:(id)sender { [(UIEditMenuInteraction *)_extraInteraction presentEditMenuWithConfiguration:[UIEditMenuConfiguration configurationWithIdentifier:nil sourcePoint:CGPointMake(20,20)]]; }
- (void)hoverExample:(UIHoverGestureRecognizer *)gesture { _feedback.text=gesture.state==UIGestureRecognizerStateEnded ? @"Pointer left the example." : @"Pointer is over the example."; }
- (NSArray *)dragInteraction:(UIDragInteraction *)interaction itemsForBeginningSession:(id<UIDragSession>)session {
#if GNUSTEP
    // GNUstep Base currently has no working NSItemProvider. The desktop bridge
    // exports this local string through the native drag pasteboard.
    UIDragItem *item=[[[UIDragItem alloc] initWithItemProvider:nil] autorelease];
#else
    NSItemProvider *provider=[[[NSItemProvider alloc] initWithObject:@"Dragged text from UIKit"] autorelease];
    UIDragItem *item=[[[UIDragItem alloc] initWithItemProvider:provider] autorelease];
#endif
    item.localObject=@"Dragged text from UIKit"; return [NSArray arrayWithObject:item];
}
- (BOOL)dropInteraction:(UIDropInteraction *)interaction canHandleSession:(id<UIDropSession>)session { return [session hasItemsConformingToTypeIdentifiers:[NSArray arrayWithObject:@"public.text"]]; }
- (UIDropProposal *)dropInteraction:(UIDropInteraction *)interaction sessionDidUpdate:(id<UIDropSession>)session { return [[[UIDropProposal alloc] initWithDropOperation:UIDropOperationCopy] autorelease]; }
- (void)dropInteraction:(UIDropInteraction *)interaction performDrop:(id<UIDropSession>)session {
    UILabel *feedback=_feedback;
    [session loadObjectsOfClass:[NSString class] completion:^(NSArray *objects) { feedback.text=[NSString stringWithFormat:@"Dropped: %@",[objects componentsJoinedByString:@", "]]; }];
}
- (void)changeGlassExample:(id)sender {
    _tapCount++;
    UIColor *color=_tapCount%2 ? [UIColor colorWithRed:0.2 green:0.6 blue:1 alpha:0.3] : [UIColor colorWithWhite:1 alpha:0.2];
    if ([_secondarySample isKindOfClass:[UIVisualEffectView class]]) { UIGlassEffect *effect=[UIGlassEffect effectWithStyle:UIGlassEffectStyleRegular]; effect.tintColor=color; [(UIVisualEffectView *)_secondarySample setEffect:effect]; }
    else { UIBackgroundExtensionView *extension=(UIBackgroundExtensionView *)_sample; extension.contentView.backgroundColor=_tapCount%2 ? [UIColor systemBlueColor] : [UIColor systemTealColor]; [extension setNeedsDisplay]; }
}
- (BOOL)openExtendedController {
    NSString *name=[_entry objectForKey:@"name"]; UIViewController *controller=nil;
    if ([name isEqualToString:@"UIDocumentPickerViewController"]) { UIDocumentPickerViewController *picker=[[[UIDocumentPickerViewController alloc] initWithDocumentTypes:[NSArray arrayWithObject:@"public.data"] inMode:UIDocumentPickerModeOpen] autorelease]; picker.delegate=self; controller=picker; }
    else if ([name isEqualToString:@"UIDocumentBrowserViewController"]) { UIDocumentBrowserViewController *browser=[[[UIDocumentBrowserViewController alloc] initForOpeningFilesWithContentTypes:[NSArray arrayWithObject:@"public.data"]] autorelease]; browser.delegate=self; controller=browser; }
    else if ([name isEqualToString:@"UIImagePickerController"]) { UIImagePickerController *picker=[[[UIImagePickerController alloc] init] autorelease]; picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary; picker.delegate=(id)self; controller=picker; }
    else if ([name isEqualToString:@"UIReferenceLibraryViewController"]) controller=[[[UIReferenceLibraryViewController alloc] initWithTerm:@"interface"] autorelease];
    else if ([name isEqualToString:@"UITextFormattingViewController"]) { UITextFormattingViewController *format=[[[UITextFormattingViewController alloc] initWithConfiguration:[[[UITextFormattingViewControllerConfiguration alloc] init] autorelease]] autorelease]; format.delegate=self; controller=format; }
    else return NO;
    controller.title=name;
    controller.navigationItem.leftBarButtonItem=[[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissExample:)] autorelease];
#if GNUSTEP
    [self presentViewController:[[[UINavigationController alloc] initWithRootViewController:controller] autorelease] animated:YES completion:nil];
#else
    // Image pickers are themselves navigation controllers on iOS.
    if ([controller isKindOfClass:[UIImagePickerController class]]) [self presentViewController:controller animated:YES completion:nil];
    else [self presentViewController:[[[UINavigationController alloc] initWithRootViewController:controller] autorelease] animated:YES completion:nil];
#endif
    return YES;
}
- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray *)URLs { _feedback.text=[NSString stringWithFormat:@"Selected: %@",[[URLs firstObject] lastPathComponent]]; [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller { _feedback.text=@"Document selection cancelled."; [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentsAtURLs:(NSArray *)URLs { _feedback.text=[NSString stringWithFormat:@"Opened: %@",[[URLs firstObject] lastPathComponent]]; [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info { [(UIImageView *)_secondarySample setImage:[info objectForKey:UIImagePickerControllerOriginalImage]]; _feedback.text=@"Selected image shown below."; [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { _feedback.text=@"Image selection cancelled."; [self dismissViewControllerAnimated:YES completion:nil]; }
- (void)textFormattingViewController:(UITextFormattingViewController *)controller didChangeValue:(UITextFormattingViewControllerChangeValue *)change {
    UILabel *preview=(UILabel *)_secondarySample;
    if (change.font) preview.font=change.font;
    else if (change.numberValue) preview.font=[UIFont systemFontOfSize:change.numberValue.doubleValue];
    _feedback.text=[NSString stringWithFormat:@"Preview font: %.0f pt",preview.font.pointSize];
}

- (void)dealloc {
    if ([_sample isKindOfClass:[UITableView class]]) { [(UITableView *)_sample setDelegate:nil]; [(UITableView *)_sample setDataSource:nil]; }
    if ([_sample isKindOfClass:[UICollectionView class]]) { [(UICollectionView *)_sample setDelegate:nil]; [(UICollectionView *)_sample setDataSource:nil]; }
    if ([_sample isKindOfClass:[UIPickerView class]]) { [(UIPickerView *)_sample setDelegate:nil]; [(UIPickerView *)_sample setDataSource:nil]; }
    if ([_sample isKindOfClass:[UISearchBar class]]) [(UISearchBar *)_sample setDelegate:nil];
    if ([_sample isKindOfClass:[UITabBar class]]) [(UITabBar *)_sample setDelegate:nil];
    [_secondarySample release];
    [_extraInteraction release];
    [_entry release];
    [_stack release];
    [_feedback release];
    [_sample release];
    [super dealloc];
}
@end
