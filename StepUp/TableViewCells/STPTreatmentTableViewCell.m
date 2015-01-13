//
//  STPTreamentTableViewCell.m
//  StepUp
//
//  Created by Eelco Koelewijn on 20/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentTableViewCell.h"
#import "UIColor+App.h"

@implementation STPTreatmentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self setupUI];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.treatmentDay.preferredMaxLayoutWidth = CGRectGetWidth(self.treatmentDay.frame);
}

- (void)setupUI
{
    self.activityButton.backgroundColor = [UIColor treamentButtonBackgroundColor];
    self.activityButton.layer.cornerRadius = 5;
    [self.activityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.activityButton setTitleColor:[UIColor buttonDisabledColor] forState:UIControlStateDisabled];
    
    self.mindfulnessButton.backgroundColor = [UIColor treamentButtonBackgroundColor];
    self.mindfulnessButton.layer.cornerRadius = 5;
    [self.mindfulnessButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.mindfulnessButton setTitleColor:[UIColor buttonDisabledColor] forState:UIControlStateDisabled];
    
    self.positiveButton.backgroundColor = [UIColor treamentButtonBackgroundColor];
    self.positiveButton.layer.cornerRadius = 5;
    [self.positiveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.positiveButton setTitleColor:[UIColor buttonDisabledColor] forState:UIControlStateDisabled];
}
@end
