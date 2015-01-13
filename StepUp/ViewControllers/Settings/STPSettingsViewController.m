//
//  STPSettingsViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 13/06/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPSettingsViewController.h"
#import "UIFont+App.h"
#import "ReminderViewController.h"
#import "BewegenDagboek.h"
#import "PositiefDagboek.h"
#import "MindfulnessDagboek.h"
#import "MessageComposerViewController.h"
#import "STPTreatmentController.h"
#import "TBCoreDataStore.h"
#import "UIViewController+BackButton.h"
#import "STPReminderController.h"

@interface STPSettingsViewController () <FeedbackInterface>
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *emailaddress;
@property (nonatomic, strong) STPTreatmentController *treatmentController;
@property (nonatomic, strong) MessageComposerViewController *messageComposer;
@end

@implementation STPSettingsViewController
- (void)awakeFromNib
{
    _treatmentController = [STPTreatmentController new];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _treatmentController = [STPTreatmentController new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;

    self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
    [self.view addGestureRecognizer:self.tapGesture];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString* emailadresValue = [defaults valueForKey:@"email_preference"];
    NSString* naamValue = [defaults valueForKey:@"name_preference"];
    self.name.text  = naamValue;
    self.emailaddress.text = emailadresValue;
    self.title = NSLocalizedString(@"SettingsVCTitel", nil);
    [self setBackButtonWithTitle:NSLocalizedString(@"Back", nil) textAttributes:@{NSFontAttributeName:[UIFont regularFontWithSize:12]} forState:UIControlStateNormal];

}

- (void)dealloc
{
    [self.view removeGestureRecognizer:self.tapGesture];
    _tapGesture = nil;
}

#pragma mark - lazy ui elements

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarButtonItemTapped:)];
        [_rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont regularFontWithSize:12.0]} forState:UIControlStateNormal];
    }
    return _rightBarButtonItem;
}

#pragma mark - handle rightbar button tap

- (void)rightBarButtonItemTapped:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tap gesture recognized

- (void)tapGestureRecognized:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self.view endEditing:YES];
        [self saveUserDefaults];
    }
}

#pragma mark - store name and email address

-(void)saveUserDefaults{
    // opslaan ingesteld e-mailadres en naam in settings.bundle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.name.text forKey:@"name_preference"];
    [defaults setObject:self.emailaddress.text forKey:@"email_preference"];
    [defaults synchronize];
    
    defaults = nil;
    
    // tonen melding dat alle behandelingen gewist zijn
    UIAlertView* done = [[UIAlertView alloc] initWithTitle:nil
                                                   message:@"Naam en e-mailadres zijn opgeslagen"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [done show];
}

#pragma mark - button actions

- (IBAction)sendAllTreatments:(UIButton *)sender
{
    // ophalen ingesteld e-mailadres uit settings.bundle
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *emailaddress = [defaults valueForKey:@"email_preference"];
    NSString *name = [defaults valueForKey:@"name_preference"];
    NSString *subject;
    
    if (!emailaddress) {
        return;
    }
    
    if (name) {
        subject = [NSString stringWithFormat:@"Behandelingen overzicht %@", name];
    } else{
        subject = @"Behandelingen overzicht";
    }
    
    // Fill out the email body text.
    // use mutable string with append
    NSManagedObjectContext *context = [TBCoreDataStore mainQueueContext];
    NSArray *bewegenDagboeken = [self.treatmentController getAllTreatmentsForEntity:[BewegenDagboek entityName] inManagedObjectContext:context];
    NSArray *mindfulnessDagboeken = [self.treatmentController getAllTreatmentsForEntity:[MindfulnessDagboek entityName] inManagedObjectContext:context];
    NSArray *positiefDagboeken = [self.treatmentController getAllTreatmentsForEntity:[PositiefDagboek entityName] inManagedObjectContext:context];
    
    NSMutableString *htmlBody = [[NSMutableString alloc] init];
    [htmlBody appendString:@"<p>Bewegen</p><table>"];
    
    NSNumber *behandelingnr= nil;
    //NSString* behandelingdag = nil;
    for (BewegenDagboek *dagboek in bewegenDagboeken) {
        if(behandelingnr != dagboek.behandelingnummer) {
            [htmlBody appendFormat:@"<tr><td valign=\"top\">Behandeling %@</td></tr>",dagboek.behandelingnummer];
            behandelingnr = dagboek.behandelingnummer;
        }
        [htmlBody appendFormat:@"<tr><td valign=\"top\">%@</td>",dagboek.dag];
        [htmlBody appendFormat:@"<td valign=\"top\"><table>"];
        [htmlBody appendFormat:@"<tr><td>Intensiteit</td><td>:</td><td>%@</td></tr>",dagboek.intensiteit];
        [htmlBody appendFormat:@"<tr><td>Training</td><td>:</td><td>%@</td></tr>",dagboek.training];
        [htmlBody appendFormat:@"<tr><td>Plezier</td><td>:</td><td>%@</td></tr>",dagboek.plezier];
        [htmlBody appendFormat:@"</table></td></tr>"];
        
    }
    [htmlBody appendString:@"</table>"];
    
    [htmlBody appendString:@"<p>Mindfulness</p><table>"];
    behandelingnr = nil;
    for (MindfulnessDagboek *dagboek in mindfulnessDagboeken) {
        if(behandelingnr != dagboek.behandelingnummer){
            [htmlBody appendFormat:@"<tr><td valign=\"top\">Behandeling %@</td></tr>",dagboek.behandelingnummer];
            behandelingnr = dagboek.behandelingnummer;
        }
        [htmlBody appendFormat:@"<tr><td valign=\"top\">%@</td>",dagboek.dag];
        [htmlBody appendFormat:@"<td valign=\"top\"><table>"];
        [htmlBody appendFormat:@"<tr><td>Oefeningen gedaan</td><td>:</td><td>%@</td></tr>",@"Ja"];
        [htmlBody appendFormat:@"</table></td></tr>"];
        
    }
    [htmlBody appendString:@"</table>"];
    
    [htmlBody appendString:@"<p>Positief</p><table>"];
    behandelingnr = nil;
    for (PositiefDagboek *dagboek in positiefDagboeken) {
        if(behandelingnr != dagboek.behandelingnummer) {
            [htmlBody appendFormat:@"<tr><td valign=\"top\">Behandeling %@</td></tr>",dagboek.behandelingnummer];
            behandelingnr = dagboek.behandelingnummer;
        }
        [htmlBody appendFormat:@"<tr><td valign=\"top\">%@</td>",dagboek.dag];
        [htmlBody appendFormat:@"<td valign=\"top\"><table>"];
        [htmlBody appendFormat:@"<tr><td>1</td><td>:</td><td>%@</td></tr>",dagboek.item1];
        [htmlBody appendFormat:@"<tr><td>2</td><td>:</td><td>%@</td></tr>",dagboek.item2];
        [htmlBody appendFormat:@"<tr><td>3</td><td>:</td><td>%@</td></tr>",dagboek.item3];
        [htmlBody appendFormat:@"</table></td></tr>"];
        
    }
    [htmlBody appendString:@"</table>"];
    
    self.messageComposer = [MessageComposerViewController new];
    [self.messageComposer showMailPicker:self subject:subject forMessage:htmlBody withRecipients:@[emailaddress]];
    
    
}

- (IBAction)setReminder:(UIButton *)sender
{
    STPReminderController *reminderController = [STPReminderController new];
    ReminderViewController *reminder = [[ReminderViewController alloc] initWithReminderContoller:reminderController];

    [self.navigationController pushViewController:reminder animated:YES];
}

- (IBAction)deleteAllTreatments:(UIButton *)sender
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@""
                                                    message:@"Weet je zeker dat je alle behandelingen wil verwijderen?"
                                                   delegate:self
                                          cancelButtonTitle:@"Nee"
                                          otherButtonTitles:@"Ja",nil];
    [alert show];
}

#pragma mark - alertview delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex>0){
        NSManagedObjectContext *context = [TBCoreDataStore privateQueueContext];
        [context performBlock:^{
            [self.treatmentController deleteAllTreatmentsInManagedObjectContext:context];
        }];

        // tonen melding dat alle behandelingen gewist zijn
        UIAlertView* done = [[UIAlertView alloc] initWithTitle:nil
                                                       message:@"Alle behandelingen zijn verwijderd."
                                                      delegate:nil
                                             cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [done show];
    }
}

#pragma mark - feedback interface

- (void)feedbackShowMessage:(NSString *)message
{
    //handle feedback from mail composer
}
@end
