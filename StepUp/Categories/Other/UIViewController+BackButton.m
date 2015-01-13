//
//  UIViewController+BackButton.m
//

#import "UIViewController+BackButton.h"
#import "Theme.h"

@implementation UIViewController (BackButton)

- (void)setBackButton
{
    //set back button in bar
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:NSLocalizedString(@"NavigationBack", nil)
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    
    self.navigationItem.backBarButtonItem = btnBack;
}

- (void)setBackButtonWithText:(NSString *)text
{
    //set back button in bar
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:text
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    
    self.navigationItem.backBarButtonItem = btnBack;
}

- (void)setBackButtonWithTitle:(NSString *)title textAttributes:(NSDictionary *)attributes forState:(UIControlState)state
{
    //set back button in bar
    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]
                                initWithTitle:title
                                style:UIBarButtonItemStyleBordered
                                target:self
                                action:nil];
    [btnBack setTitleTextAttributes:attributes forState:state];
    
    self.navigationItem.backBarButtonItem = btnBack;
}
@end
