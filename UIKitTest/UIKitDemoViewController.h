#import <UIKit/UIKit.h>

@interface UIKitDemoViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate,
    UISearchBarDelegate, UITabBarDelegate, UIContextMenuInteractionDelegate, UIEditMenuInteractionDelegate,
    UIDocumentPickerDelegate, UIDocumentBrowserViewControllerDelegate, UIImagePickerControllerDelegate,
    UITextFormattingViewControllerDelegate, UIDragInteractionDelegate, UIDropInteractionDelegate> {
    NSDictionary *_entry;
    UIStackView *_stack;
    UILabel *_feedback;
    UIView *_sample;
    NSInteger _tapCount;
    UIView *_secondarySample;
    id _extraInteraction;
}
+ (NSArray *)liveClassNames;
- (id)initWithEntry:(NSDictionary *)entry;
@end
