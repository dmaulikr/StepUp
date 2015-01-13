//
//  STPTreatmentsTableViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 23/04/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentsTableViewController.h"
#import "STPTreatmentsTableViewCell.h"
#import "EKArrayDataSource.h"
#import "STPTreatmentTableViewController.h"
#import "Theme.h"
#import "UIViewController+BackButton.h"

NSString *const kSTUTreatmentsCellIdentifier = @"STUTreatmentsCellIdentifier"; //match one used in storyboard

@interface STPTreatmentsTableViewController () <EKArrayDataSource>
@property (nonatomic, strong) NSArray *treatments;
@property (nonatomic, strong) EKArrayDataSource *treatmentsDataSource;
@end

@implementation STPTreatmentsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self loadTreatments];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self loadTreatments];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.tableFooterView = [UIView new];
    self.treatmentsDataSource = [[EKArrayDataSource alloc] initWithArrayDataSource:self.treatments cellIdentifier:kSTUTreatmentsCellIdentifier];
    self.tableView.dataSource = self.treatmentsDataSource;
    self.treatmentsDataSource.delegate = self;
    
    [self setBackButtonWithTitle:NSLocalizedString(@"Back", nil) textAttributes:@{NSFontAttributeName:[UIFont regularFontWithSize:12]} forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - array data source delegate

- (void)arrayDataSource:(EKArrayDataSource *)arrayDatasource configureCell:(id)cell withObject:(id)object
{
    // Configure the cell...
    STPTreatmentsTableViewCell *configureCell = cell;
    NSDictionary *treatment = (NSDictionary *)object;
    configureCell.treatmentText.text = [NSString stringWithFormat:@"%@\n%@",[treatment objectForKey:@"treatment"],[treatment objectForKey:@"description"]];
}

#pragma mark - tableview delegate

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight ||
        self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        return 50.0f;
    }
    return 110.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForBasicCellAtIndexPath:indexPath];
}

- (CGFloat)heightForBasicCellAtIndexPath:(NSIndexPath *)indexPath
{
    static STPTreatmentsTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:kSTUTreatmentsCellIdentifier ];
    });
    [self arrayDataSource:nil configureCell:sizingCell withObject:[self.treatmentsDataSource itemAtIndexPath:indexPath]];
    CGFloat height = [self calculateHeightForConfiguredSizingCell:sizingCell];
    
    return roundf(height);
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell
{
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView
                   systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - loading treatments
- (void)loadTreatments
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Treatments" ofType:@"plist"];
    self.treatments = [[NSArray alloc] initWithContentsOfFile:filePath];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *selectedIndexPath = nil;
    if ([segue.identifier isEqualToString:@"buttonTreatmentSegue"]) {
        CGPoint position = [sender convertPoint:CGPointZero toView:self.tableView];
        selectedIndexPath = [self.tableView indexPathForRowAtPoint:position];
    } else if ([segue.identifier isEqualToString:@"selectTreatmentSegue"]) {
        UITableViewCell *selectedCell = sender;
        selectedIndexPath = [self.tableView indexPathForCell:selectedCell];
    }
    
    STPTreatmentTableViewController *treatmentVC = [segue destinationViewController];
    treatmentVC.treatment = [self.treatmentsDataSource itemAtIndexPath:selectedIndexPath];
    
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}


@end
