//
//  STPTreatmentViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 22/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentViewController.h"
#import "UIFont+App.h"
#import "UIColor+App.h"

@interface STPTreatmentViewController ()
@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@end

@implementation STPTreatmentViewController

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

- (void)setup
{
    _treatmentController = [[STPTreatmentController alloc] init];
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    [self.navigationItem.leftBarButtonItem setTarget:self];
    [self.navigationItem.leftBarButtonItem setAction:@selector(cancelButtonTouched:)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = [NSString stringWithFormat:@"%@ week %ld",self.navigationItem.title, (long)self.weeknumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - handle cancel tap
- (void)cancelButtonTouched:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - show alert with validation message

- (void)showAlertWithValidationMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"ValidationTitle", nil), self.navigationItem.title] message:message delegate:self cancelButtonTitle:NSLocalizedString(@"ValidationCancelButtonText", nil) otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark - lazy ui elements

- (UIBarButtonItem *)leftBarButtonItem
{
    if (!_leftBarButtonItem) {
        _leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:nil action:nil];
        [_leftBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont regularFontWithSize:12.0
]} forState:UIControlStateNormal];
        [_leftBarButtonItem setTintColor:[UIColor cancelActionColor]];
    }
    return _leftBarButtonItem;
}

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] init];
        _rightBarButtonItem.title = NSLocalizedString(@"Save", nil);
        [_rightBarButtonItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont regularFontWithSize:12.0]} forState:UIControlStateNormal];
    }
    return _rightBarButtonItem;
}
@end
