//
//  UIColor+App.h
//  StepUp
//
//  Created by Eelco Koelewijn on 20/05/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (App)
/**
 *  #3DB347
 *  (61,179,71)
 *
 *  @return new UIColor object
 */
+ (instancetype)treamentButtonBackgroundColor;

/**
 *  #68C470
 *  (104,196,112)
 *
 *  @return new UIColor object
 */
+ (instancetype)treamentsCellBackgroundColor;

/**
 *  #28AB33
 *  (40,171,51)
 *  @return new UIColor object
 */
+ (instancetype)baseGreenColor;

/**
 *  #52BB5B
 *  (82,187,91)
 *
 *  @return new UIColor object
 */
+ (instancetype)actionGreenColor;

/**
 *  #FF3232
 *  (255,50,50)
 *
 *  @return new UIColor object
 */
+ (instancetype)cancelActionColor;

/**
 *  #464946
 *  (70,73,70)
 *
 *  @return new UIColor object
 */
+ (instancetype)buttonDisabledColor;
@end
