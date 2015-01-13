
#import <UIKit/UIKit.h>

@protocol FeedbackInterface <NSObject>
- (void)feedbackShowMessage:(NSString *)message;
@end

@interface MessageComposerViewController : UIViewController
- (void)showMailPicker:(id<FeedbackInterface>)sender subject:(NSString *)subject forMessage:(NSString *)message withRecipients:(NSArray *)recipients;
- (void)showSMSPicker:(id<FeedbackInterface>)sender withMessage:(NSString *)message;
- (void)showTweetPicker:(id<FeedbackInterface>)sender withMessage:(NSString *)message;
@end

