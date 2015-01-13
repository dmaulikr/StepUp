//
//  STPReminderController.h
//  StepUp
//
//  Created by Eelco Koelewijn on 03/01/15.
//  Copyright (c) 2015 E.Koelewijn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface STPReminderController : NSObject
@property(nonatomic, copy) NSDate *reminderTime;
@property(nonatomic, getter = isReminderSet) BOOL reminder;

/**
 *  Remove reminder time setting
 */
- (void)removeReminder;

/**
 *  Synchronise settings to user defaults
 */
- (void)syncSettings;

@end
