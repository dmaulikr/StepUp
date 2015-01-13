//
//  STPTreatmentViewController.h
//  StepUp
//
//  Created by Eelco Koelewijn on 22/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPTreatmentController.h"

@interface STPTreatmentViewController : UIViewController
@property (nonatomic, copy) NSDictionary *treatment;
@property (nonatomic) NSInteger weeknumber;
@property (nonatomic, readonly) STPTreatmentController *treatmentController;

- (void)showAlertWithValidationMessage:(NSString *)message;
- (void)setup;

@end
