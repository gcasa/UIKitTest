#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
@private
    UIScrollView *_scrollView;
    UIStackView *_contentStack;
    UILabel *_greetingLabel;
    UITextField *_nameTextField;
    UIButton *_greetButton;
    UISwitch *_personalizationSwitch;
    UISlider *_progressSlider;
    UIProgressView *_progressView;
    UILabel *_progressLabel;
    UIStepper *_fontSizeStepper;
    UILabel *_fontSizeLabel;
    UISegmentedControl *_greetingStyleControl;
    UITableView *_historyTableView;
    UIButton *_infoButton;
    NSMutableArray *_greetings;
}
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UIStackView *contentStack;
@property (retain, nonatomic) IBOutlet UILabel *greetingLabel;
@property (retain, nonatomic) IBOutlet UITextField *nameTextField;
@property (retain, nonatomic) IBOutlet UIButton *greetButton;
@property (retain, nonatomic) IBOutlet UISwitch *personalizationSwitch;
@property (retain, nonatomic) IBOutlet UISlider *progressSlider;
@property (retain, nonatomic) IBOutlet UIProgressView *progressView;
@property (retain, nonatomic) IBOutlet UILabel *progressLabel;
@property (retain, nonatomic) IBOutlet UIStepper *fontSizeStepper;
@property (retain, nonatomic) IBOutlet UILabel *fontSizeLabel;
@property (retain, nonatomic) IBOutlet UISegmentedControl *greetingStyleControl;
@property (retain, nonatomic) IBOutlet UITableView *historyTableView;
@property (retain, nonatomic) IBOutlet UIButton *infoButton;
- (IBAction)greet:(id)sender;
- (IBAction)personalizationChanged:(UISwitch *)sender;
- (IBAction)progressChanged:(UISlider *)sender;
- (IBAction)fontSizeChanged:(UIStepper *)sender;
- (IBAction)greetingStyleChanged:(UISegmentedControl *)sender;
- (IBAction)showInfo:(id)sender;
@end
