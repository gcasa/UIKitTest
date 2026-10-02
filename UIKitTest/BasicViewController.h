#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *greetingLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *greetButton;
- (IBAction)greet:(UIButton *)sender;
@end
