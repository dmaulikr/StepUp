//
//  STPReminderController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 03/01/15.
//  Copyright (c) 2015 E.Koelewijn. All rights reserved.
//

#import "STPReminderController.h"

@interface STPReminderController ()
@property(nonatomic,strong) NSUserDefaults *defaults;
@end

@implementation STPReminderController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}


#pragma mark - set reminder

- (BOOL)isReminderSet
{
    return [self.defaults boolForKey:@"reminderOn"];
}

- (void)setReminder:(BOOL)reminder
{
    [self.defaults setObject:[NSNumber numberWithBool:reminder] forKey:@"reminderOn"];
}

#pragma mark - retrieving/ storing reminder time

- (NSDate *)reminderTime
{
    NSDate *pickerTime = [self.defaults objectForKey:@"reminderTime"];
    if (pickerTime) {
        return pickerTime;
    }
    return [NSDate date];
}

- (void)setReminderTime:(NSDate *)reminderTime
{
    [self.defaults setObject:reminderTime forKey:@"reminderTime"];
}

#pragma mark - removal of reminder

- (void)removeReminder
{
    [self.defaults removeObjectForKey:@"reminderTime"];
}

#pragma mark - syncing

- (void)syncSettings
{
    [self.defaults synchronize];
}
@end
