//
//  EKOBaseTreatmentTableViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 13/06/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "EKOBaseTreatmentTableViewController.h"
#import "UIFont+App.h"
#import "STPSettingsViewController.h"

@interface EKOBaseTreatmentTableViewController ()
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;
@end

@implementation EKOBaseTreatmentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
}

#pragma mark - lazy ui elements

- (UIBarButtonItem *)rightBarButtonItem
{
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(rightBarButtonItemTapped:)];
    }
    return _rightBarButtonItem;
}

#pragma mark - handle rightbar button tap

- (void)rightBarButtonItemTapped:(UIBarButtonItem *)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                                
    STPSettingsViewController *settingsVC = [storyboard instantiateViewControllerWithIdentifier:@"settingsViewController"];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsVC];
    
    [self presentViewController:navController animated:YES completion:nil];
}
@end
