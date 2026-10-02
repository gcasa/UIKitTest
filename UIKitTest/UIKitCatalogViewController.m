#import "UIKitCatalogViewController.h"
#import "UIKitDemoViewController.h"

@implementation UIKitCatalogViewController
@synthesize entries = _entries;
@synthesize filteredEntries = _filteredEntries;

- (id)init {
    return [super initWithStyle:UITableViewStyleInsetGrouped];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"UIKit Objects";
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:@"UIKitCatalog" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSDictionary *catalog = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil;
    self.entries = [catalog objectForKey:@"classes"];
    _catalogSearch = [[UISearchController alloc] initWithSearchResultsController:nil];
    _catalogSearch.searchResultsUpdater = self;
    _catalogSearch.obscuresBackgroundDuringPresentation = NO;
    _catalogSearch.searchBar.placeholder = @"Class, category, or header";
    self.navigationItem.searchController = _catalogSearch;
    self.navigationItem.hidesSearchBarWhenScrolling = NO;
    self.definesPresentationContext = YES;
    _scopeControl = [[UISegmentedControl alloc] initWithItems:
        [NSArray arrayWithObjects:@"Live widgets", @"All objects", nil]];
    _scopeControl.selectedSegmentIndex = 0;
    [_scopeControl addTarget:self action:@selector(scopeChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = _scopeControl;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 72;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self scopeChanged:nil];
}

- (void)filterWithQuery:(NSString *)query liveOnly:(BOOL)liveOnly {
    NSMutableArray *matches = [NSMutableArray array];
    NSString *trimmed = [query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (NSDictionary *entry in self.entries) {
        if (liveOnly && ![[UIKitDemoViewController liveClassNames] containsObject:[entry objectForKey:@"name"]]) continue;
        NSString *searchable = [NSString stringWithFormat:@"%@ %@ %@", [entry objectForKey:@"name"],
            [entry objectForKey:@"category"], [entry objectForKey:@"header"]];
        if (trimmed.length == 0 || [searchable rangeOfString:trimmed options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [matches addObject:entry];
        }
    }
    self.filteredEntries = matches;
    UILabel *empty = [[[UILabel alloc] init] autorelease];
    empty.text = self.entries.count ? @"No matching UIKit objects.\nTry another class or category." : @"The UIKit catalog could not be loaded.";
    empty.textAlignment = NSTextAlignmentCenter;
    empty.numberOfLines = 0;
    empty.textColor = [UIColor secondaryLabelColor];
    self.tableView.backgroundView = matches.count ? nil : empty;
    [self.tableView reloadData];
}

- (void)scopeChanged:(id)sender {
    [self filterWithQuery:_catalogSearch.searchBar.text liveOnly:_scopeControl.selectedSegmentIndex == 0];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    [self scopeChanged:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredEntries.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"%lu objects", (unsigned long)self.filteredEntries.count];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @"Live widgets include interactive examples. All objects catalogs Objective-C classes declared in the iOS 26.2 SDK’s public UIKit headers, including deprecated and platform-specific types. Reference cards do not instantiate these types. Protocols, categories, and Swift-only APIs are outside this inventory.";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Object"];
    if (!cell) cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Object"] autorelease];
    NSDictionary *entry = [self.filteredEntries objectAtIndex:indexPath.row];
    NSString *name = [entry objectForKey:@"name"];
    BOOL live = [[UIKitDemoViewController liveClassNames] containsObject:name];
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.adjustsFontForContentSizeCategory = YES;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ · %@", [entry objectForKey:@"category"], live ? @"Live preview" : @"Reference card"];
    cell.detailTextLabel.numberOfLines = 0;
    cell.detailTextLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
    cell.detailTextLabel.adjustsFontForContentSizeCategory = YES;
    cell.imageView.image = [UIImage systemImageNamed:live ? @"hand.tap" : @"doc.text"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *entry = [self.filteredEntries objectAtIndex:indexPath.row];
    UIKitDemoViewController *detail = [[UIKitDemoViewController alloc] initWithEntry:entry];
    [self.navigationController pushViewController:detail animated:YES];
    [detail release];
}

- (void)dealloc {
    _catalogSearch.searchResultsUpdater = nil;
    [_catalogSearch release];
    [_scopeControl release];
    [_entries release];
    [_filteredEntries release];
    [super dealloc];
}
@end
