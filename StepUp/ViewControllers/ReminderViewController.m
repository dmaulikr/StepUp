//
//  ReminderViewController.m
//  StepUp
//
//  Created by Eelco Koelewijn on 26/01/14.
//
//

#import "ReminderViewController.h"
#import "UIFont+App.h"
#import "STPReminderController.h"

@interface ReminderViewController ()
@property (nonatomic, strong) UILabel *reminderLabel;
@property (nonatomic, strong) UISwitch *reminderOnOffSwitch;
@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic ,strong) UIDatePicker *reminderTimePicker;
@property (nonatomic, strong) STPReminderController *controller;
@end

@implementation ReminderViewController

- (instancetype)initWithReminderContoller:(STPReminderController *)controller
{
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}

- (void)loadView
{
    self.view = [UIView new];
    [self setup];
    [self setupConstraints];
}

- (void)setup
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.reminderLabel];
    [self.contentView addSubview:self.reminderOnOffSwitch];
    [self.contentView addSubview:self.reminderTimePicker];
    
}

- (void)setupConstraints
{
    NSDictionary *views = @{@"reminderLabel":self.reminderLabel,
                            @"contentView":self.contentView,
                            @"reminderOnOffSwitch":self.reminderOnOffSwitch,
                            @"reminderTimePicker":self.reminderTimePicker};

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[contentView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[contentView]|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[reminderLabel(235)]-[reminderOnOffSwitch]-|" options:0 metrics:nil views:views]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[reminderTimePicker]|" options:0 metrics:nil views:views]];

    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[reminderLabel]-[reminderTimePicker]-|" options:0 metrics:nil views:views]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.reminderOnOffSwitch attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.reminderLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
}

#pragma mark - lazy ui elements

- (UIScrollView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIScrollView alloc] init];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _contentView;
}

- (UILabel *)reminderLabel
{
    if (!_reminderLabel) {
        _reminderLabel = [[UILabel alloc] init];
        _reminderLabel.text = NSLocalizedString(@"ReminderDescriptionText", nil);
        _reminderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [_reminderLabel setFont:[UIFont regularFontWithSize:15]];
        _reminderLabel.numberOfLines = 0;
        _reminderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    }
    return _reminderLabel;
}

- (UISwitch *)reminderOnOffSwitch
{
    if (!_reminderOnOffSwitch) {
        _reminderOnOffSwitch = [[UISwitch alloc] init];
        _reminderOnOffSwitch.translatesAutoresizingMaskIntoConstraints = NO;
        [_reminderOnOffSwitch addTarget:self action:@selector(reminderOnOffSwitchChanged:) forControlEvents:UIControlEventValueChanged];

        if (self.controller.isReminderSet) {
            _reminderOnOffSwitch.on = YES;
        } else {
            _reminderOnOffSwitch.on = NO;
        }
    }
    return _reminderOnOffSwitch;
}

- (UIDatePicker *)reminderTimePicker
{
    if (!_reminderTimePicker) {
        _reminderTimePicker = [[UIDatePicker alloc] init];
        _reminderTimePicker.translatesAutoresizingMaskIntoConstraints = NO;
        _reminderTimePicker.datePickerMode = UIDatePickerModeTime;
        _reminderTimePicker.timeZone = [NSTimeZone localTimeZone];
        _reminderTimePicker.calendar = [NSCalendar currentCalendar];
        [_reminderTimePicker addTarget:self action:@selector(reminderTimePickerChanged:) forControlEvents:UIControlEventValueChanged];

        if (self.controller.isReminderSet) {
            _reminderTimePicker.userInteractionEnabled = YES;
        } else {
            _reminderTimePicker.userInteractionEnabled = NO;
        }
        NSDate *pickerTime = self.controller.reminderTime;
        if (pickerTime) {
            _reminderTimePicker.date = pickerTime;
        } else {
            _reminderTimePicker.date = [NSDate date];
        }
        
    }
    return _reminderTimePicker;
}

- (void)viewDidLoad
{
    self.title = @"Reminder";
}

- (void)reminderOnOffSwitchChanged:(UISwitch *)sender
{
    if (sender.on) {
        self.reminderTimePicker.userInteractionEnabled = YES;
        self.reminderTimePicker.enabled = YES;
    } else {
        self.reminderTimePicker.userInteractionEnabled = NO;
        self.reminderTimePicker.enabled = NO;
        //remove local notification
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [self.controller removeReminder];
    }
    self.controller.reminder = sender.on;
    [self.controller syncSettings];
}

- (void)reminderTimePickerChanged:(UIDatePicker *)sender
{
    self.controller.reminderTime = sender.date;
    [self.controller syncSettings];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];

    //remove old reminders
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //create local notification
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    localNotification.fireDate = [df dateFromString:[df stringFromDate:sender.date]];
    localNotification.repeatInterval = NSWeekdayCalendarUnit;
    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = @"Tijd voor de Step Up! oefeningen";
    localNotification.alertAction = @"Open Step Up! app";
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    
}
@end
