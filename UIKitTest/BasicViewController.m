#import "BasicViewController.h"

@implementation BasicViewController
- (instancetype)init {
    return [super initWithNibName:@"BasicViewController" bundle:[NSBundle bundleForClass:self.class]];
}

- (IBAction)greet:(UIButton *)sender {
    NSString *name = [self.nameTextField.text stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceAndNewlineCharacterSet];
    self.greetingLabel.text = name.length == 0 ? @"Hello, UIKit!" : [NSString stringWithFormat:@"Hello, %@!", name];
    [self.nameTextField resignFirstResponder];
}
@end
