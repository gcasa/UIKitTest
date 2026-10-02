#import "UIKitDemoViewController.h"

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
        @"UICalendarView", nil];
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
    if ([name isEqualToString:@"UILabel"]) {
        [self addSample:[self label:@"Hello, UIKit!\nLabels support multiple lines and Dynamic Type." style:UIFontTextStyleTitle2] height:0];
    } else if ([name isEqualToString:@"UIButton"]) {
        [self addSample:[self button:@"Tap me" action:@selector(tapped:)] height:0];
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

- (void)dealloc {
    if ([_sample isKindOfClass:[UITableView class]]) { [(UITableView *)_sample setDelegate:nil]; [(UITableView *)_sample setDataSource:nil]; }
    if ([_sample isKindOfClass:[UICollectionView class]]) { [(UICollectionView *)_sample setDelegate:nil]; [(UICollectionView *)_sample setDataSource:nil]; }
    if ([_sample isKindOfClass:[UIPickerView class]]) { [(UIPickerView *)_sample setDelegate:nil]; [(UIPickerView *)_sample setDataSource:nil]; }
    if ([_sample isKindOfClass:[UISearchBar class]]) [(UISearchBar *)_sample setDelegate:nil];
    if ([_sample isKindOfClass:[UITabBar class]]) [(UITabBar *)_sample setDelegate:nil];
    [_entry release];
    [_stack release];
    [_feedback release];
    [_sample release];
    [super dealloc];
}
@end
