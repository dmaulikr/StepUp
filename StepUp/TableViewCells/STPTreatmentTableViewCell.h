//
//  STPTreamentTableViewCell.h
//  StepUp
//
//  Created by Eelco Koelewijn on 20/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STPTreatmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *treatmentDay;
@property (weak, nonatomic) IBOutlet UIButton *activityButton;
@property (weak, nonatomic) IBOutlet UIButton *mindfulnessButton;
@property (weak, nonatomic) IBOutlet UIButton *positiveButton;

@end
