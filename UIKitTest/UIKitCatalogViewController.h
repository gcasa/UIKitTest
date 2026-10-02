#import <UIKit/UIKit.h>

@interface UIKitCatalogViewController : UITableViewController <UISearchResultsUpdating> {
    NSArray *_entries;
    NSArray *_filteredEntries;
    UISearchController *_catalogSearch;
    UISegmentedControl *_scopeControl;
}
@property (retain, nonatomic) NSArray *entries;
@property (retain, nonatomic) NSArray *filteredEntries;
- (void)filterWithQuery:(NSString *)query liveOnly:(BOOL)liveOnly;
@end
