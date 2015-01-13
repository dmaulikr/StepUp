//
//  RCOVideoPlayer.h
//  AudioVideoSync
//
//  Created by Almer Lucke on 4/23/13.
//  Copyright (c) 2013 Farcoding. All rights reserved.
//

#import "EKOBasePlayer.h"


@interface EKOPlayer : EKOBasePlayer

@property (nonatomic, readonly) AVURLAsset *asset;
@property (nonatomic, readonly) AVPlayerItem *playerItem;
@property (nonatomic, readonly) AVPlayer *player;

@property (nonatomic, readonly) BOOL isPlaying;
@property (nonatomic, readonly) BOOL isPaused;
@property (nonatomic, readonly) BOOL isReady;
@property (nonatomic, readonly) BOOL playbackLikelyToKeepUp;
@property (nonatomic, readonly) BOOL playbackBufferEmpty;
@property (nonatomic, readonly) BOOL playbackBufferFull;
@property (nonatomic, readonly) NSArray *commonMetadata;


- (void)setURL:(NSURL *)url;
- (void)prepareForPlaying;
- (void)reload;

- (AVMediaSelectionGroup *)mediaSelectionGroupForMediaCharacteristic:(NSString *)mediaCharacteristic;
- (AVMediaSelectionOption *)selectedMediaOptionInMediaSelectionGroup:(AVMediaSelectionGroup *)group;
- (void)selectMediaOption:(AVMediaSelectionOption *)selectOption inMediaSelectionGroup:(AVMediaSelectionGroup *)group;

- (void)seekToTime:(CMTime)time completionHandler:(void (^)(BOOL finished))completionHandler;
- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter completionHandler:(void (^)(BOOL finished))completionHandler;
- (void)seekToTime:(CMTime)time toleranceBefore:(CMTime)toleranceBefore toleranceAfter:(CMTime)toleranceAfter;

- (id)addPeriodicTimeObserverForInterval:(CMTime)interval queue:(dispatch_queue_t)queue usingBlock:(void (^)(CMTime time))block;
- (void)removeTimeObserver:(id)observer;

@end