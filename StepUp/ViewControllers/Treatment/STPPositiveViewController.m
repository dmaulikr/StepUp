//
//  STPPositiveViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 24/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPPositiveViewController.h"

@interface STPPositiveViewController ()
@property (weak, nonatomic) IBOutlet UITextField *positive1TextField;
@property (weak, nonatomic) IBOutlet UITextField *positive2TextField;
@property (weak, nonatomic) IBOutlet UITextField *positive3TextField;

@end

@implementation STPPositiveViewController

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

    PositiefDagboek *treatment = [self.treatmentController getPositiveTreatmentForWeeknumber:self.weeknumber andDay:[self.treatment objectForKey:@"day"]];
    if (treatment) {
        self.positive1TextField.text = treatment.item1;
        self.positive2TextField.text = treatment.item2;
        self.positive3TextField.text = treatment.item3;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    NSDictionary *results = @{@"positive1":self.positive1TextField.text,
                              @"positive2":self.positive2TextField.text,
                              @"positive3":self.positive3TextField.text,
                              @"weeknumber":[NSNumber numberWithInteger:self.weeknumber]};
    
    if ([self.treatmentController saveTreatment:self.treatment withPositiveTreatmentData:results])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self showAlertWithValidationMessage:NSLocalizedString(@"PositiveValidationMessage", nil)];
    }
    
}


@end
