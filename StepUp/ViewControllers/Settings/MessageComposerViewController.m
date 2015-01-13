
#import <MessageUI/MessageUI.h>
#import "MessageComposerViewController.h"
#import <Social/Social.h>

@interface MessageComposerViewController () <
    MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    UINavigationControllerDelegate
>
// UILabel for displaying the result of the sending the message.
@property (nonatomic, weak) IBOutlet UILabel *feedbackMsg;
@property (nonatomic, strong) id<FeedbackInterface> presenter;
@end


@implementation MessageComposerViewController

#pragma mark - Rotation

#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_6_0
// -------------------------------------------------------------------------------
//	shouldAutorotateToInterfaceOrientation:
//  Disable rotation on iOS 5.x and earlier.  Note, for iOS 6.0 and later all you
//  need is "UISupportedInterfaceOrientations" defined in your Info.plist
// -------------------------------------------------------------------------------
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#endif

#pragma mark - Actions

// -------------------------------------------------------------------------------
//	showMailPicker:
//  IBAction for the Compose Mail button.
// -------------------------------------------------------------------------------
- (IBAction)showMailPicker:(id<FeedbackInterface>)sender subject:(NSString *)subject forMessage:(NSString *)message withRecipients:(NSArray *)recipients
{
    // You must check that the current device can send email messages before you
    // attempt to create an instance of MFMailComposeViewController.  If the
    // device can not send email messages,
    // [[MFMailComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMailComposeViewController canSendMail])
    // The device can send email.
    {
        self.presenter = sender;
        [self displayMailComposerSheetOn:sender subject:subject forMessage:message withRecipients:recipients];
    }
    else
    // The device can not send email.
    {
		[sender feedbackShowMessage:@"Device not configured to send mail."];
    }
}

// -------------------------------------------------------------------------------
//	showSMSPicker:
//  IBAction for the Compose SMS button.
// -------------------------------------------------------------------------------
- (IBAction)showSMSPicker:(id<FeedbackInterface>)sender withMessage:(NSString *)message
{
    // You must check that the current device can send SMS messages before you
    // attempt to create an instance of MFMessageComposeViewController.  If the
    // device can not send SMS messages,
    // [[MFMessageComposeViewController alloc] init] will return nil.  Your app
    // will crash when it calls -presentViewController:animated:completion: with
    // a nil view controller.
    if ([MFMessageComposeViewController canSendText])
    // The device can send email.
    {
        self.presenter = sender;
        [self displaySMSComposerSheetOn:sender withMessage:message];
    }
    else
    // The device can not send email.
    {
		[sender feedbackShowMessage:@"Device not configured to send SMS."];
    }
}

#pragma mark - Compose Mail/SMS

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an email composition interface inside the application.
//  Populates all the Mail fields.
// -------------------------------------------------------------------------------
- (void)displayMailComposerSheetOn:(id)sender subject:(NSString *)subject forMessage:(NSString *)message withRecipients:(NSArray *)recipients
{
	MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
	picker.mailComposeDelegate = self;
	
	[picker setSubject:subject];
	
	// Set up recipients
	NSArray *toRecipients = @[[recipients firstObject]];
    NSArray *ccRecipients;
    if ([recipients count] > 1) {
        NSRange range;
        range.location = 1;
        range.length = [recipients count]-1;
        ccRecipients = [recipients subarrayWithRange:range];
    }
	
	[picker setToRecipients:toRecipients];
	[picker setCcRecipients:ccRecipients];	
		
	// Fill out the email body text
	NSString *emailBody = message;
	[picker setMessageBody:emailBody isHTML:YES];

	[sender presentViewController:picker animated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	displayMailComposerSheet
//  Displays an SMS composition interface inside the application.
// -------------------------------------------------------------------------------
- (void)displaySMSComposerSheetOn:(id)sender withMessage:(NSString *)message
{
	MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
	picker.messageComposeDelegate = self;

    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    /* picker.recipients = @[@"Phone number here"]; */
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    picker.body = message;
    
	[sender presentViewController:picker animated:YES completion:NULL];
}


#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	mailComposeController:didFinishWithResult:
//  Dismisses the email composition interface when users tap Cancel or Send.
//  Proceeds to update the message field with the result of the operation.
// -------------------------------------------------------------------------------
- (void)mailComposeController:(MFMailComposeViewController*)controller 
		didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			[self.presenter feedbackShowMessage:@"Mail sending canceled"];
			break;
		case MFMailComposeResultSaved:
			[self.presenter feedbackShowMessage:@"Mail saved"];
			break;
		case MFMailComposeResultSent:
			[self.presenter feedbackShowMessage:@"Mail sent"];
			break;
		case MFMailComposeResultFailed:
			[self.presenter feedbackShowMessage:@"Mail sending failed"];
			break;
		default:
			[self.presenter feedbackShowMessage:@"Mail not sent"];
			break;
	}
    
	[controller.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller 
			  didFinishWithResult:(MessageComposeResult)result
{
	self.feedbackMsg.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MessageComposeResultCancelled:
			[self.presenter feedbackShowMessage:@"SMS sending canceled"];
			break;
		case MessageComposeResultSent:
			[self.presenter feedbackShowMessage:@"SMS sent"];
			break;
		case MessageComposeResultFailed:
			[self.presenter feedbackShowMessage:@"SMS sending failed"];
			break;
		default:
			[self.presenter feedbackShowMessage:@"SMS not sent"];
			break;
	}
    
	[controller.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return [super supportedInterfaceOrientations];
}

- (void)showTweetPicker:(id<FeedbackInterface>)sender withMessage:(NSString *)message
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        [self displayTweetComposerSheetOn:sender withMessage:message];
    } else {
		[sender feedbackShowMessage:@"Device not configured to send Tweet."];
    }
}

- (void)displayTweetComposerSheetOn:(id)sender withMessage:(NSString *)message
{
	SLComposeViewController *tweetVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    
    [tweetVC setInitialText:message];
    
    self.presenter = sender;
	[sender presentViewController:tweetVC animated:YES completion:NULL];
}
@end
