//
//  EKOPlayerView.h
//  StepUp
//
//  Created by Eelco Koelewijn on 07/08/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class EKOPlayerView;

@protocol EKOPlayerViewDelegate <NSObject>

@optional
- (void)playerView:(EKOPlayerView *)playerView completedPlayingItem:(NSString *)playerItem;

@end

@interface EKOPlayerView : UIView
@property (nonatomic, weak) id<EKOPlayerViewDelegate> delegate;
- (void)setPlayerItem:(NSString *)playerItem seekTime:(NSTimeInterval)seekTime;
- (void)seekToTime:(NSTimeInterval)seekTime;
- (void)startPlayer;
- (void)pausePlayer;
@end
