//
//  EKOPlayerViewOutlets.h
//  StepUp
//
//  Created by Eelco Koelewijn on 07/08/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EKOPlayerViewOutlets : UIView
@property (nonatomic, weak) IBOutlet UILabel *currentPlayTime;
@property (nonatomic, weak) IBOutlet UILabel *totalPlayTime;
@property (nonatomic, weak) IBOutlet UIButton *playButton;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, weak) IBOutlet UILabel *itemTitle;
@end
