//
//  UIViewController+BackButton.h
//

#import <UIKit/UIKit.h>

@interface UIViewController (BackButton)
- (void)setBackButton;
- (void)setBackButtonWithText:(NSString *)text;
- (void)setBackButtonWithTitle:(NSString *)title textAttributes:(NSDictionary *)attributes forState:(UIControlState)state;
@end
