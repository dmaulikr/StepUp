//
//  STPTreatmentsButton.m
//  StepUp
//
//  Created by Eelco Koelewijn on 29/11/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentsButton.h"
#import "UIFont+App.h"
#import "UIColor+App.h"

@implementation STPTreatmentsButton

- (void)awakeFromNib
{
    [self.titleLabel setFont:[UIFont regularFontWithSize:15]];
    self.layer.cornerRadius = 7;
    [self setBackgroundColor:[UIColor treamentButtonBackgroundColor]];
    [self setContentEdgeInsets:UIEdgeInsetsMake(7, 7, 7, 7)];
    [self.titleLabel setFont:[UIFont regularFontWithSize:12]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
