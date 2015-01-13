//
//  STPTreatmentButton.m
//  StepUp
//
//  Created by Eelco Koelewijn on 29/11/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentButton.h"
#import "Theme.h"

@implementation STPTreatmentButton

- (void)awakeFromNib
{
    [self.titleLabel setFont:[UIFont regularFontWithSize:12]];
    self.layer.cornerRadius = 5;
    [self setBackgroundColor:[UIColor treamentButtonBackgroundColor]];
    [self setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

@end
