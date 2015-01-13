//
//  UIColor+App.m
//  StepUp
//
//  Created by Eelco Koelewijn on 20/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "UIColor+App.h"

@implementation UIColor (App)
+ (instancetype)treamentButtonBackgroundColor
{
    return [UIColor colorWithRed:61.0/255.0 green:179.0/255.0 blue:71.0/255.0 alpha:1.0];
}

+ (instancetype)treamentsCellBackgroundColor
{
    return [UIColor colorWithRed:35.0/255.0 green:90.0/255.0 blue:150.0/255.0 alpha:1.0];
}

+ (instancetype)baseGreenColor
{
    return [UIColor colorWithRed:40.0/255.0 green:171.0/255.0 blue:51.0/255.0 alpha:1.0];
}

+ (instancetype)actionGreenColor
{
    return [UIColor colorWithRed:82.0/255.0 green:187.0/255.0 blue:91.0/255.0 alpha:1.0];
}

+ (instancetype)cancelActionColor
{
    return [UIColor colorWithRed:255.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
}

+ (instancetype)buttonDisabledColor
{
    return [UIColor colorWithRed:70.0/255.0 green:73.0/255.0 blue:70.0/255.0 alpha:1.0];
}
@end
