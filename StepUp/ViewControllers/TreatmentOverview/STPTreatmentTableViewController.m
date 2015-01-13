//
//  STPTreatmentTableViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 24/04/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentTableViewController.h"
#import "STPTreatmentTableViewCell.h"
#import "EKArrayDataSource.h"
#import "STPTreatmentViewController.h"
#import "UIViewController+BackButton.h"
#import "Theme.h"

NSString *const kSTUTreatmentCellIdentifier = @"STUTreatmentCellIdentifier"; //match one used in storyboard

@interface STPTreatmentTableViewController () <EKArrayDataSource>
@property (nonatomic, strong) EKArrayDataSource *treatmentDataSource;
@property (nonatomic, strong) UITableViewCell *prototypeCell;
@end

@implementation STPTreatmentTableViewController

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

    self.tableView.tableFooterView = [UIView new];
    self.title = [self.treatment objectForKey:@"treatment"];
    self.treatmentDataSource = [[EKArrayDataSource alloc] initWithArrayDataSource:[self.treatment objectForKey:@"week"] cellIdentifier:kSTUTreatmentCellIdentifier];
    self.tableView.dataSource = self.treatmentDataSource;
    self.treatmentDataSource.delegate = self;
    
    [self setBackButtonWithTitle:NSLocalizedString(@"Back", nil) textAttributes:@{NSFontAttributeName:[UIFont regularFontWithSize:12]} forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id object = [self.treatmentDataSource itemAtIndexPath:indexPath];
    [self arrayDataSource:nil configureCell:self.prototypeCell withObject:object];
    
    [self.prototypeCell layoutIfNeeded];

    CGSize cellSize = [self.prototypeCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return cellSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)prototypeCell
{
    if (!_prototypeCell) {
        
        _prototypeCell = [self.tableView dequeueReusableCellWithIdentifier:kSTUTreatmentCellIdentifier];
    }
    return _prototypeCell;
}

#pragma mark - datasource delegate configure cell
- (void)arrayDataSource:(EKArrayDataSource *)arrayDatasource configureCell:(id)cell withObject:(id)object
{   
    STPTreatmentTableViewCell *configureCell = cell;
    NSDictionary *treatment = (NSDictionary *)object;
    configureCell.treatmentDay.text = [treatment objectForKey:@"day"];
    configureCell.activityButton.enabled = [[treatment objectForKey:@"activity"] boolValue];
    configureCell.mindfulnessButton.enabled = [[treatment objectForKey:@"mindfulness"] boolValue];
    configureCell.positiveButton.enabled = [[treatment objectForKey:@"positive"] boolValue];
    configureCell.activityButton.tag = 1;
    configureCell.mindfulnessButton.tag = 2;
    configureCell.positiveButton.tag = 3;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController *navController = [segue destinationViewController];
    STPTreatmentViewController *treatmentVC = (STPTreatmentViewController *)navController.topViewController;
    
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *selectedIndexPath = nil;
    CGPoint position = [sender convertPoint:CGPointZero toView:self.tableView];
    selectedIndexPath = [self.tableView indexPathForRowAtPoint:position];

    //load treatment from core data
    treatmentVC.weeknumber = [[self.treatment objectForKey:@"weeknumber"] integerValue];
    treatmentVC.treatment = [self.treatmentDataSource itemAtIndexPath:selectedIndexPath];
    
}


@end
