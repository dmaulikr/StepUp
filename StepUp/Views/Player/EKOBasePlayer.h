//
//  EKOBasePlayer.h
//


#import <AVFoundation/AVFoundation.h>


UIKIT_EXTERN NSString *const EKOBasePlayerTimedMetadataNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerPlaybackLikelyToKeepUpNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerPlaybackBufferEmptyNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerPlaybackBufferFullNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerLoadKeysFinishedNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerChangedDurationNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerChangedPlayingTimeNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerChangedStatusNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerChangedTypeNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerChangedTitleNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerChangedSubtitleNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerPlaybackJumpedNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerPlaybackEndedNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerPlaybackStalledNotification;
UIKIT_EXTERN NSString *const EKOBasePlayerPlaybackEndedFailureNotification;


@protocol EKOBasePlayerDelegate;

typedef NS_ENUM(NSInteger, EKOBasePlayerStatus)
{
    EKOBasePlayerStatusUnknown = 0,
    EKOBasePlayerStatusReady = 1,
    EKOBasePlayerStatusLoading = 2,
    EKOBasePlayerStatusError = 3,
    EKOBasePlayerStatusPlaying = 4,
    EKOBasePlayerStatusPaused = 5
};


typedef NS_ENUM(NSInteger, EKOBasePlayerType)
{
    EKOBasePlayerTypeNone = 0
};


@interface EKOBasePlayer : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) EKOBasePlayerStatus status;
@property (nonatomic) EKOBasePlayerStatus prevStatus;
@property (nonatomic) EKOBasePlayerType type;
@property (nonatomic, weak) id<EKOBasePlayerDelegate> delegate;
@property (nonatomic, readonly) BOOL canRewind;
@property (nonatomic, readonly) BOOL canForward;
@property (nonatomic) BOOL generateNotifications;
@property (nonatomic, readonly) double currentTime;
@property (nonatomic, readonly) double duration;

- (void)play;
- (void)pause;
- (void)rewind;
- (void)forward;

@end


@protocol EKOBasePlayerDelegate <NSObject>
@optional
- (void)player:(EKOBasePlayer *)player receivedTimedMetadata:(NSArray *)timedMetaData;
- (void)player:(EKOBasePlayer *)player playbackLikelyToKeepUp:(BOOL)playbackLikelyToKeepUp;
- (void)player:(EKOBasePlayer *)player playbackBufferEmpty:(BOOL)playbackBufferEmpty;
- (void)player:(EKOBasePlayer *)player playbackBufferFull:(BOOL)playbackBufferFull;
- (void)player:(EKOBasePlayer *)player loadKeysFinished:(NSError *)error;
- (void)player:(EKOBasePlayer *)player changedDuration:(double)duration;
- (void)player:(EKOBasePlayer *)player changedPlayingTimeInSeconds:(double)seconds;
- (void)player:(EKOBasePlayer *)player changedStatus:(EKOBasePlayerStatus)status;
- (void)player:(EKOBasePlayer *)player changedTitle:(NSString *)title;
- (void)player:(EKOBasePlayer *)player changedSubtitle:(NSString *)subtitle;
- (void)player:(EKOBasePlayer *)player changedType:(EKOBasePlayerType)type;

- (void)playbackJumpedForPlayer:(EKOBasePlayer *)player;
- (void)playbackEndedForPlayer:(EKOBasePlayer *)player;
- (void)playbackStalledForPlayer:(EKOBasePlayer *)player;
- (void)playbackEndedFailureForPlayer:(EKOBasePlayer *)player;

@end