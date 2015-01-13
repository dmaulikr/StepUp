//
//  UIFont+App.m
//  StepUp
//
//  Created by Eelco Koelewijn on 24/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "UIFont+App.h"

@implementation UIFont (App)
+ (instancetype)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Roboto-Regular" size:size];
}
@end
