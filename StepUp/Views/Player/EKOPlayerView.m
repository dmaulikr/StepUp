//
//  EKOPlayerView.m
//  StepUp
//
//  Created by Eelco Koelewijn on 07/08/14.
//  Copyright (c) 2014 E.Koelewijn. All rights reserved.
//

#import "EKOPlayerView.h"
#import "EKOPlayerViewOutlets.h"
#import "EKOPlayer.h"
#import "Theme.h"

@interface EKOPlayerView () <EKOBasePlayerDelegate>
@property (nonatomic, strong) EKOPlayerViewOutlets *rootView;
@property (nonatomic, strong) EKOPlayer *avPlayer;
@property (nonatomic) CGFloat duration;
@property (nonatomic, strong) NSString *playerItem;
@end

@implementation EKOPlayerView

- (void)awakeFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *elements = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
    
    [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    self.rootView = [elements firstObject];
    [self.rootView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self addSubview:self.rootView];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[rootView]|" options:0 metrics:nil views:@{@"rootView":self.rootView}]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[rootView]|" options:0 metrics:nil views:@{@"rootView":self.rootView}]];
    
    [self setup];
    [self setupUIElements];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self awakeFromNib];
    }
    return self;
}

- (void)setup
{
    _avPlayer = [EKOPlayer new];
    _avPlayer.delegate = self;
}

#pragma mark - setup ui elements

- (void)setupUIElements
{
    [self resetPlayerElements];
    [self.rootView.progressView setTintColor:[UIColor actionGreenColor]];
}

#pragma mark - set player item and start playing

- (void)setPlayerItem:(NSString *)playerItem seekTime:(NSTimeInterval)seekTime
{
    self.playerItem = playerItem;
    [self resetPlayerElements];
    self.rootView.itemTitle.text = NSLocalizedString(playerItem, nil);
    [self.avPlayer setURL:[self getURLForAudioFile:playerItem]];
    [self.avPlayer reload];
}

- (void)seekToTime:(NSTimeInterval)seekTime
{
    [self.avPlayer seekToTime:CMTimeMake(seekTime, 1) toleranceBefore:CMTimeMake(0, 1) toleranceAfter:CMTimeMake(0, 1)];
}

- (void)pausePlayer
{
    [self.avPlayer pause];
    [self.rootView.playButton setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
}

- (void)startPlayer
{
    [self.avPlayer play];
    [self.rootView.playButton setTitle:NSLocalizedString(@"Pause", nil) forState:UIControlStateNormal];
}

#pragma mark - get audio url

- (NSURL *)getURLForAudioFile:(NSString *)audioFile
{
	NSString *bundel = [[NSBundle mainBundle] resourcePath];
	NSString *path = [NSString stringWithFormat:@"%@/%@.mp3", bundel, audioFile];
	return [NSURL fileURLWithPath:path];
}

#pragma mark - play button tapped

- (void)playButtonTapped:(UIButton *)sender
{
    switch (self.avPlayer.status) {
        case EKOBasePlayerStatusPlaying:
            [self pausePlayer];
            break;
        case EKOBasePlayerStatusReady:
        case EKOBasePlayerStatusPaused:
            [self startPlayer];
            break;
        default:
            break;
    }
}

#pragma mark - ekoplayer delegates

- (void)player:(EKOBasePlayer *)player changedDuration:(double)duration
{
    self.duration = duration;
    
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    minutes = duration / 60;
    seconds = duration - (minutes * 60);
    
    self.rootView.totalPlayTime.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];

}

- (void)player:(EKOPlayer *)player changedPlayingTimeInSeconds:(double)timeInSeconds
{
    NSInteger minutes = 0;
    NSInteger seconds = 0;
    
    minutes = timeInSeconds / 60;
    seconds = timeInSeconds - (minutes * 60);
    
    self.rootView.currentPlayTime.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
    
    if (self.duration > 0) {
        self.rootView.progressView.progress = timeInSeconds / self.duration;
    }
    
    timeInSeconds = self.duration - timeInSeconds;
    minutes = timeInSeconds / 60;
    seconds = timeInSeconds - (minutes * 60);
    
    self.rootView.totalPlayTime.text = [NSString stringWithFormat:@"%02ld:%02ld", (long)minutes, (long)seconds];
}

- (void)player:(EKOBasePlayer *)player changedStatus:(EKOBasePlayerStatus)status
{
    switch (self.avPlayer.status) {
        case EKOBasePlayerStatusReady:
            self.rootView.playButton.enabled = YES;
            break;
        default:
            break;
    }
}

- (void)playbackEndedForPlayer:(EKOBasePlayer *)player
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerView:completedPlayingItem:)]) {
        [self.delegate playerView:self completedPlayingItem:self.playerItem];
    }
    
    [self resetPlayerElements];
}

#pragma mark - reset ui elements

- (void)resetPlayerElements
{
    self.rootView.itemTitle.text = nil;
    self.rootView.playButton.enabled = NO;
    self.rootView.progressView.progress = 0.f;
    self.rootView.currentPlayTime.text = [NSString stringWithFormat:@"00:00"];
    self.rootView.totalPlayTime.text = [NSString stringWithFormat:@"00:00"];
    [self.rootView.playButton setTitle:NSLocalizedString(@"Play", nil) forState:UIControlStateNormal];
    [self.rootView.playButton addTarget:self action:@selector(playButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
}
@end
