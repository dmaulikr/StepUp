//
//  EKOVideoPlayer.m
//

#import "EKOPlayer.h"

static const NSString *EKOPlayerItemStatusContext;
static const NSString *EKOPlayerItemPlaybackLikelyToKeepUpContext;
static const NSString *EKOPlayerItemPlaybackBufferEmptyContext;
static const NSString *EKOPlayerItemPlaybackBufferFullContext;
static const NSString *EKOPlayerItemTimedMetadataContext;
static const NSString *EKOPlayerItemDurationContext;

@interface EKOPlayer ()

@property (nonatomic, strong) AVURLAsset *asset;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) id timeObserver;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) BOOL isPreparedForPlaying;

@end


@implementation EKOPlayer

- (void)clear
{
    [self removeTimeObserver:self.timeObserver];
    self.timeObserver = nil;
    
    @try {
        [self.playerItem removeObserver:self forKeyPath:@"status"];
    } @catch(id anException){
        
    }
    
    [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty"];
    [self.playerItem removeObserver:self forKeyPath:@"playbackBufferFull"];
    [self.playerItem removeObserver:self forKeyPath:@"duration"];
    [self.playerItem removeObserver:self forKeyPath:@"timedMetadata"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.playerItem = nil;
    self.player = nil;
    self.isPreparedForPlaying = NO;
    self.status = EKOBasePlayerStatusUnknown;
}

- (void)dealloc
{
    [self clear];
}

- (id)init
{
    if ((self = [super init])) {
    }
    
    return self;
}

- (void)setURL:(NSURL *)url
{
    NSDictionary *options = @{AVURLAssetPreferPreciseDurationAndTimingKey:[NSNumber numberWithBool:YES],
                              AVURLAssetReferenceRestrictionsKey:[NSNumber numberWithInteger:AVAssetReferenceRestrictionForbidNone]};
    
    self.asset = [AVURLAsset URLAssetWithURL:url options:options];
}

- (void)reload
{
    [self clear];
    [self setURL:self.asset.URL];
    [self prepareForPlaying];
}


#pragma mark - Preparation

- (void)finishPrepareForPlaying
{
    self.isPreparedForPlaying = YES;
    
    self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset];
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"status"
                         options:0
                         context:&EKOPlayerItemStatusContext];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"duration"
                         options:0
                         context:&EKOPlayerItemDurationContext];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"playbackLikelyToKeepUp"
                         options:0
                         context:&EKOPlayerItemPlaybackLikelyToKeepUpContext];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"playbackBufferEmpty"
                         options:0
                         context:&EKOPlayerItemPlaybackBufferEmptyContext];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"playbackBufferFull"
                         options:0
                         context:&EKOPlayerItemPlaybackBufferFullContext];
    
    [self.playerItem addObserver:self
                      forKeyPath:@"timedMetadata"
                         options:0
                         context:&EKOPlayerItemTimedMetadataContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemJumped:)
                                                 name:AVPlayerItemTimeJumpedNotification
                                               object:self.playerItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemEnded:)
                                                 name:AVPlayerItemDidPlayToEndTimeNotification
                                               object:self.playerItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemStalled:)
                                                 name:AVPlayerItemPlaybackStalledNotification
                                               object:self.playerItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playerItemEndedFailure:)
                                                 name:AVPlayerItemFailedToPlayToEndTimeNotification
                                               object:self.playerItem];

    CMTime cmTime = CMTimeMake(1, 10);
    
    __weak EKOPlayer *weakSelf = self;
    
    self.timeObserver = [self.player addPeriodicTimeObserverForInterval:cmTime
                                                                  queue:NULL
                                                             usingBlock:^(CMTime time) {
                                                            double timeInSeconds = CMTimeGetSeconds(time);
                                                            
                                                            if (weakSelf.delegate &&
                                                                [weakSelf.delegate respondsToSelector:@selector(player:changedPlayingTimeInSeconds:)]) {
                                                                [weakSelf.delegate player:weakSelf changedPlayingTimeInSeconds:timeInSeconds];
                                                            }
                                                            
                                                            if (weakSelf.generateNotifications) {
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerChangedPlayingTimeNotification
                                                                                                                    object:weakSelf
                                                                                                                  userInfo:@{@"time": [NSNumber numberWithDouble:timeInSeconds]}];
                                                            }
                                                        }];
}

- (void)prepareForPlaying
{
    NSString *tracksKey = @"tracks";
    NSString *availableMediaKey = @"availableMediaCharacteristicsWithMediaSelectionOptions";
    NSString *commonMetadataKey = @"commonMetadata";
    NSArray *keys = @[tracksKey, availableMediaKey, commonMetadataKey];
    
    self.status = EKOBasePlayerStatusLoading;

    [self.asset loadValuesAsynchronouslyForKeys:keys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            AVKeyValueStatus status = AVKeyValueStatusLoaded;
            
            for (NSString *key in keys) {
                status = [self.asset statusOfValueForKey:key error:&error];
                if (status == AVKeyValueStatusFailed) {
                    if (self.generateNotifications) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerLoadKeysFinishedNotification
                                                                            object:self];
                    }
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(player:loadKeysFinished:)]) {
                        [self.delegate player:self loadKeysFinished:error];
                    }
                    
                    break;
                }
            }
            
            if (status != AVKeyValueStatusFailed) {
                if (self.generateNotifications) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerLoadKeysFinishedNotification
                                                                        object:self];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:loadKeysFinished:)]) {
                    [self.delegate player:self loadKeysFinished:nil];
                }
                
                [self finishPrepareForPlaying];
            } else {
                self.status = EKOBasePlayerStatusError;
                NSLog(@"AVKeyValueStatusFailed:%@(%@)[%@]",[error localizedDescription],error.description,error.debugDescription);
            }
        });
    }];
}


#pragma mark - Observing

- (void)playerItemJumped:(NSNotification *)note
{
    if (self.generateNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerPlaybackJumpedNotification
                                                            object:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playbackJumpedForPlayer:)]) {
        [self.delegate playbackJumpedForPlayer:self];
    }
}

- (void)playerItemEnded:(NSNotification *)note
{
    if (self.generateNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerPlaybackEndedNotification
                                                            object:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playbackEndedForPlayer:)]) {
        [self.delegate playbackEndedForPlayer:self];
    }
}

- (void)playerItemStalled:(NSNotification *)note
{
    if (self.generateNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerPlaybackStalledNotification
                                                            object:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playbackStalledForPlayer:)]) {
        [self.delegate playbackStalledForPlayer:self];
    }
}

- (void)playerItemEndedFailure:(NSNotification *)note
{
    if (self.generateNotifications) {
        [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerPlaybackEndedFailureNotification
                                                            object:self];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(playbackEndedFailureForPlayer:)]) {
        [self.delegate playbackEndedFailureForPlayer:self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (object == self.playerItem) {
            if (context == &EKOPlayerItemStatusContext) {
                if (self.playerItem.status == AVPlayerItemStatusReadyToPlay) {
                    [self.playerItem removeObserver:self forKeyPath:@"status"];
                    self.status = EKOBasePlayerStatusReady;
                } else if (self.playerItem.status == AVPlayerItemStatusFailed) {
                    [self.playerItem removeObserver:self forKeyPath:@"status"];
                    self.status = EKOBasePlayerStatusError;
                }
            }
            
            if (context == &EKOPlayerItemPlaybackLikelyToKeepUpContext) {
                if (self.generateNotifications) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerPlaybackLikelyToKeepUpNotification
                                                                        object:self];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:playbackLikelyToKeepUp:)]) {
                    [self.delegate player:self playbackLikelyToKeepUp:self.playerItem.playbackLikelyToKeepUp];
                }
            }
            
            if (context == &EKOPlayerItemPlaybackBufferEmptyContext) {
                if (self.generateNotifications) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerPlaybackBufferEmptyNotification
                                                                        object:self];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:playbackBufferEmpty:)]) {
                    [self.delegate player:self playbackBufferEmpty:self.playerItem.playbackBufferEmpty];
                }
            }
            
            if (context == &EKOPlayerItemPlaybackBufferFullContext) {
                if (self.generateNotifications) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerPlaybackBufferFullNotification
                                                                        object:self];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:playbackBufferFull:)]) {
                    [self.delegate player:self playbackBufferFull:self.playerItem.playbackBufferFull];
                }
            }
            
            if (context == &EKOPlayerItemDurationContext) {
                if (self.generateNotifications) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerChangedDurationNotification
                                                                        object:self
                                                                      userInfo:@{@"duration": [NSNumber numberWithDouble:CMTimeGetSeconds(self.playerItem.duration)]}];
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:changedDuration:)]) {
                    [self.delegate player:self changedDuration:CMTimeGetSeconds(self.playerItem.duration)];
                }
            }
            
            if (context == &EKOPlayerItemTimedMetadataContext) {
                if (self.playerItem.timedMetadata) {

                    NSArray *timedMetadataList = self.playerItem.timedMetadata;
                    
                    for (AVMetadataItem *metaDataItem in timedMetadataList) {
                        if ([(NSString *)metaDataItem.key isEqualToString:@"title"]) {
                            NSString *title = (NSString *)metaDataItem.value;
                            NSArray *titleComponents = [title componentsSeparatedByString:@":"];
                            
                            if ([titleComponents count] > 0) {
                                NSString *title = [[titleComponents objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                
                                self.title = title;
                                
                                if (self.generateNotifications) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerChangedTitleNotification
                                                                                        object:self
                                                                                      userInfo:@{@"title" : self.title}];
                                }
                                
                                if (self.delegate && [self.delegate respondsToSelector:@selector(player:changedTitle:)]) {
                                    [self.delegate player:self changedTitle:title];
                                }
                            }
                            
                            if ([titleComponents count] > 1) {
                                NSString *subtitle = [[titleComponents objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                
                                self.subtitle = subtitle;
                                
                                if (self.generateNotifications) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerChangedSubtitleNotification
                                                                                        object:self
                                                                                      userInfo:@{@"subtitle" : self.subtitle}];
                                }
                                
                                if (self.delegate && [self.delegate respondsToSelector:@selector(player:changedSubtitle:)]) {
                                    [self.delegate player:self changedSubtitle:subtitle];
                                }
                            }
                            
                            break;
                        }
                    }
                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(player:receivedTimedMetadata:)]) {
                    [self.delegate player:self receivedTimedMetadata:self.playerItem.timedMetadata];
                }
                
                if (self.generateNotifications) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerTimedMetadataNotification
                                                                        object:self
                                                                      userInfo:@{@"metadata" : self.playerItem.timedMetadata}];
                }
            }
        }
    });
}

#pragma mark - Properties

- (double)currentTime
{
    return CMTimeGetSeconds(self.playerItem.currentTime);
}

- (NSArray *)commonMetadata
{
    return self.asset.commonMetadata;
}

- (BOOL)playbackLikelyToKeepUp
{
    return self.playerItem.playbackLikelyToKeepUp;
}

- (BOOL)playbackBufferEmpty
{
    return self.playerItem.playbackBufferEmpty;
}

- (BOOL)playbackBufferFull
{
    return self.playerItem.playbackBufferFull;
}

- (BOOL)isReady
{
    return (self.status == EKOBasePlayerStatusReady ||
            self.status == EKOBasePlayerStatusPlaying ||
            self.status == EKOBasePlayerStatusPaused);
}

- (BOOL)isPlaying
{
    return (self.status == EKOBasePlayerStatusPlaying);
}

- (BOOL)isPaused
{
    return (self.status == EKOBasePlayerStatusPaused);
}

- (double)duration
{
    return CMTimeGetSeconds(self.playerItem.duration);
}


#pragma mark - Play

- (void)play
{
    [self.player play];
    self.status = EKOBasePlayerStatusPlaying;
}

- (void)pause
{
    [self.player pause];
    self.status = EKOBasePlayerStatusPaused;
}

#pragma mark - Shortcuts

- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block
{
    return [self.player addPeriodicTimeObserverForInterval:interval
                                                     queue:queue
                                                usingBlock:block];
}

- (void)removeTimeObserver:(id)observer
{
    [self.player removeTimeObserver:observer];
}

- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler
{
    [self.playerItem seekToTime:time completionHandler:completionHandler];
}

- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^)(BOOL finished))completionHandler
{
    [self.playerItem seekToTime:time
                toleranceBefore:toleranceBefore
                 toleranceAfter:toleranceAfter
              completionHandler:completionHandler];
}

- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter
{
    [self.playerItem seekToTime:time
                toleranceBefore:toleranceBefore
                 toleranceAfter:toleranceAfter];
}

- (AVMediaSelectionGroup *)mediaSelectionGroupForMediaCharacteristic:(NSString *)mediaCharacteristic
{
    return [self.asset mediaSelectionGroupForMediaCharacteristic:mediaCharacteristic];
}

- (AVMediaSelectionOption *)selectedMediaOptionInMediaSelectionGroup:(AVMediaSelectionGroup *)group
{
    return [self.playerItem selectedMediaOptionInMediaSelectionGroup:group];
}

- (void)selectMediaOption:(AVMediaSelectionOption *)selectOption inMediaSelectionGroup:(AVMediaSelectionGroup *)group
{
    [self.playerItem selectMediaOption:selectOption inMediaSelectionGroup:group];
}

@end
