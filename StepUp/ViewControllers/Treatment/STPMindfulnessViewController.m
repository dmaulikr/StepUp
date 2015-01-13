//
//  STPMindfulnessViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 24/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPMindfulnessViewController.h"
#import "EKOPlayerView.h"
#import "Theme.h"

@interface STPMindfulnessViewController () <EKOPlayerViewDelegate>
@property (weak, nonatomic) IBOutlet EKOPlayerView *audioPlayer;
@property (weak, nonatomic) IBOutlet UIButton *bodyScanButton;
@property (weak, nonatomic) IBOutlet UIButton *ademruimteButton;

@end

@implementation STPMindfulnessViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.audioPlayer setPlayerItem:@"bodyscan" seekTime:0.0];
    self.audioPlayer.delegate = self;
    
    [self.bodyScanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.bodyScanButton setBackgroundColor:[UIColor baseGreenColor]];
    self.bodyScanButton.layer.cornerRadius = 5;
    
    [self.ademruimteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.ademruimteButton setBackgroundColor:[UIColor baseGreenColor]];
    self.ademruimteButton.layer.cornerRadius = 5;
    
}

- (void)setup
{
    [super setup];
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(saveButtonTouched:)];
    
    //Make sure the system follows our playback status
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

#pragma mark - save button tapped

- (void)saveButtonTouched:(UIBarButtonItem *)sender
{
    NSDictionary *results = @{@"bodyscan":[NSNumber numberWithInteger:1],
                              @"breathing":[NSNumber numberWithInteger:1],
                              @"weeknumber":[NSNumber numberWithInteger:self.weeknumber]};
    
    if ([self.treatmentController saveTreatment:self.treatment withMindfulnessTreatmentData:results])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showAlertWithValidationMessage:NSLocalizedString(@"MindfulnessValidationMessage", nil)];
    }
    
}

#pragma mark - bodyscan/ademruimte buttons

- (IBAction)ademruimteTapped:(UIButton *)sender {
    [self.audioPlayer setPlayerItem:@"ademruimte" seekTime:0.0];
}

- (IBAction)bodyscanTapped:(UIButton *)sender {
    [self.audioPlayer setPlayerItem:@"bodyscan" seekTime:0.0];
}

#pragma mark - player view delegate

- (void)playerView:(EKOPlayerView *)playerView completedPlayingItem:(NSString *)playerItem
{
    //save treatment for played item
}
@end
