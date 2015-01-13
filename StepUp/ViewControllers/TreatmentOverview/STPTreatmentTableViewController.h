//
//  STPTreatmentTableViewController.h
//  StepUp
//
//  Created by Eelco Koelewijn on 24/04/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EKOBaseTreatmentTableViewController.h"

@interface STPTreatmentTableViewController : EKOBaseTreatmentTableViewController
@property (nonatomic, strong) NSDictionary *treatment;
@end
