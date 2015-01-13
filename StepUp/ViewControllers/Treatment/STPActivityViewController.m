//
//  STPActivityViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 22/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPActivityViewController.h"
#import "BewegenDagboek.h"
#import "Theme.h"

@interface STPActivityViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *intensitySegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *trainigSegmentedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *funSegmentedControl;

@end

@implementation STPActivityViewController

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
    BewegenDagboek *treatment = [self.treatmentController getActivityTreatmentForWeeknumber:self.weeknumber andDay:[self.treatment objectForKey:@"day"]];
    if (treatment) {
        self.intensitySegmentedControl.selectedSegmentIndex = treatment.intensiteitValue;
        self.trainigSegmentedControl.selectedSegmentIndex = treatment.trainingValue;
        self.funSegmentedControl.selectedSegmentIndex = treatment.plezierValue;
    }
    
    [self.intensitySegmentedControl setTintColor:[UIColor treamentButtonBackgroundColor]];
    [self.trainigSegmentedControl setTintColor:[UIColor treamentButtonBackgroundColor]];
    [self.funSegmentedControl setTintColor:[UIColor treamentButtonBackgroundColor]];
}

- (void)setup
{
    [super setup];
    [self.navigationItem.rightBarButtonItem setTarget:self];
    [self.navigationItem.rightBarButtonItem setAction:@selector(saveButtonTouched:)];
}

#pragma mark - save button tapped

- (void)saveButtonTouched:(UIBarButtonItem *)sender
{
    NSDictionary *results = @{@"intensity":[NSNumber numberWithInteger:self.intensitySegmentedControl.selectedSegmentIndex],
                              @"training":[NSNumber numberWithInteger:self.trainigSegmentedControl.selectedSegmentIndex],
                              @"fun":[NSNumber numberWithInteger:self.funSegmentedControl.selectedSegmentIndex],
                              @"weeknumber":[NSNumber numberWithInteger:self.weeknumber]};
    
    if ([self.treatmentController saveTreatment:self.treatment withActivityTreatmentData:results])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showAlertWithValidationMessage:NSLocalizedString(@"ActivityValidationMessage", nil)];
    }
    
}

@end
