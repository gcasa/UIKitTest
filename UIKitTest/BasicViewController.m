#import "BasicViewController.h"
#import "UIKitCatalogViewController.h"

@interface BasicViewController ()
@property (retain, nonatomic) NSMutableArray *greetings;
@end

@implementation BasicViewController
@synthesize scrollView = _scrollView;
@synthesize contentStack = _contentStack;
@synthesize greetingLabel = _greetingLabel;
@synthesize nameTextField = _nameTextField;
@synthesize greetButton = _greetButton;
@synthesize personalizationSwitch = _personalizationSwitch;
@synthesize progressSlider = _progressSlider;
@synthesize progressView = _progressView;
@synthesize progressLabel = _progressLabel;
@synthesize fontSizeStepper = _fontSizeStepper;
@synthesize fontSizeLabel = _fontSizeLabel;
@synthesize greetingStyleControl = _greetingStyleControl;
@synthesize historyTableView = _historyTableView;
@synthesize infoButton = _infoButton;
@synthesize greetings = _greetings;

- (id)init {
    return [super initWithNibName:@"BasicViewController" bundle:[NSBundle bundleForClass:[self class]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIKit Playground";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Widgets"
        style:UIBarButtonItemStylePlain target:self action:@selector(showCatalog:)] autorelease];
    self.greetings = [NSMutableArray array];
    self.nameTextField.delegate = self;
    [self.historyTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"GreetingCell"];
    self.historyTableView.rowHeight = 44;
    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    self.historyTableView.tableFooterView = footer;
    [footer release];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.personalizationSwitch.accessibilityLabel = @"Use name in greeting";
    self.progressSlider.accessibilityLabel = @"Progress";
    self.fontSizeStepper.accessibilityLabel = @"Greeting font size";
    [self progressChanged:self.progressSlider];
    [self fontSizeChanged:self.fontSizeStepper];
}

- (void)showCatalog:(id)sender {
    UIKitCatalogViewController *catalog = [[UIKitCatalogViewController alloc] init];
    [self.navigationController pushViewController:catalog animated:YES];
    [catalog release];
}

- (NSString *)currentGreeting {
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *prefix = self.greetingStyleControl.selectedSegmentIndex == 1 ? @"Welcome" : @"Hello";
    NSString *recipient = self.personalizationSwitch.on && name.length > 0 ? name : @"UIKit";
    return [NSString stringWithFormat:@"%@, %@!", prefix, recipient];
}

- (IBAction)greet:(id)sender {
    self.greetingLabel.text = [self currentGreeting];
    [self.greetings insertObject:self.greetingLabel.text atIndex:0];
    [self.historyTableView reloadData];
    [self.historyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                               atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.nameTextField resignFirstResponder];
}

- (IBAction)personalizationChanged:(UISwitch *)sender {
    self.nameTextField.enabled = sender.on;
    if (!sender.on) {
        [self.nameTextField resignFirstResponder];
    }
    self.greetingLabel.text = [self currentGreeting];
}

- (IBAction)progressChanged:(UISlider *)sender {
    self.progressView.progress = sender.value;
    self.progressLabel.text = [NSString stringWithFormat:@"Progress: %.0f%%", sender.value * 100];
}

- (IBAction)fontSizeChanged:(UIStepper *)sender {
    self.greetingLabel.font = [UIFont systemFontOfSize:sender.value];
    self.fontSizeLabel.text = [NSString stringWithFormat:@"Greeting font: %.0f pt", sender.value];
}

- (IBAction)greetingStyleChanged:(UISegmentedControl *)sender {
    self.greetingLabel.text = [self currentGreeting];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self greet:textField];
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.greetings.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GreetingCell" forIndexPath:indexPath];
    cell.textLabel.text = [self.greetings objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.greetings removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIViewController *detail = [[UIViewController alloc] init];
    detail.title = @"Greeting Detail";
    detail.view.backgroundColor = [UIColor systemBackgroundColor];
    UILabel *label = [[UILabel alloc] init];
    label.text = [self.greetings objectAtIndex:indexPath.row];
    label.font = [UIFont preferredFontForTextStyle:UIFontTextStyleTitle1];
    label.adjustsFontForContentSizeCategory = YES;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.accessibilityIdentifier = @"detailGreeting";
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [detail.view addSubview:label];
    UILayoutGuide *safeArea = detail.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:[NSArray arrayWithObjects:
        [label.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:24],
        [label.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-24],
        [label.centerYAnchor constraintEqualToAnchor:safeArea.centerYAnchor],
        nil]];
    [label release];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (IBAction)showInfo:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"UIKit Playground"
        message:@"Try the controls, send a greeting, then tap a history row for details or swipe left to delete it."
        preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
// Outlets are retained so they remain valid until their delegates are cleared.
- (void)dealloc {
    _nameTextField.delegate = nil;
    _historyTableView.delegate = nil;
    _historyTableView.dataSource = nil;
    [_scrollView release];
    [_contentStack release];
    [_greetingLabel release];
    [_nameTextField release];
    [_greetButton release];
    [_personalizationSwitch release];
    [_progressSlider release];
    [_progressView release];
    [_progressLabel release];
    [_fontSizeStepper release];
    [_fontSizeLabel release];
    [_greetingStyleControl release];
    [_historyTableView release];
    [_infoButton release];
    [_greetings release];
    [super dealloc];
}
@end
