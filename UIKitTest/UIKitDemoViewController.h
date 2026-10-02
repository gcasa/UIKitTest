#import <UIKit/UIKit.h>

@interface UIKitDemoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate,
    UISearchBarDelegate, UITabBarDelegate> {
    NSDictionary *_entry;
    UIStackView *_stack;
    UILabel *_feedback;
    UIView *_sample;
    NSInteger _tapCount;
}
+ (NSArray *)liveClassNames;
- (id)initWithEntry:(NSDictionary *)entry;
@end
