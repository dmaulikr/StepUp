//
//  STPTreatmentTableViewCell.m
//  StepUp
//
//  Created by Eelco Koelewijn on 23/04/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "STPTreatmentsTableViewCell.h"
#import "UIFont+App.h"

@implementation STPTreatmentsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.treatmentText.preferredMaxLayoutWidth = CGRectGetWidth(self.treatmentText.frame);
}

- (void)prepareForReuse
{
    self.treatmentText.text = nil;
}
@end
