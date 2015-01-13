//
//  EKOBasePlayer.m
//

#import "EKOBasePlayer.h"



NSString *const EKOBasePlayerTimedMetadataNotification = @"EKOBasePlayerTimedMetadataNotification";
NSString *const EKOBasePlayerPlaybackLikelyToKeepUpNotification = @"EKOBasePlayerPlaybackLikelyToKeepUpNotification";
NSString *const EKOBasePlayerPlaybackBufferEmptyNotification = @"EKOBasePlayerPlaybackBufferEmptyNotification";
NSString *const EKOBasePlayerPlaybackBufferFullNotification = @"EKOBasePlayerPlaybackBufferFullNotification";
NSString *const EKOBasePlayerLoadKeysFinishedNotification = @"EKOBasePlayerLoadKeysFinishedNotification";
NSString *const EKOBasePlayerChangedDurationNotification = @"EKOBasePlayerChangedDurationNotification";
NSString *const EKOBasePlayerChangedPlayingTimeNotification = @"EKOBasePlayerChangedPlayingTimeNotification";
NSString *const EKOBasePlayerChangedStatusNotification = @"EKOBasePlayerChangedStatusNotification";
NSString *const EKOBasePlayerChangedTypeNotification = @"EKOBasePlayerChangedTypeNotification";
NSString *const EKOBasePlayerChangedTitleNotification = @"EKOBasePlayerChangedTitleNotification";
NSString *const EKOBasePlayerChangedSubtitleNotification = @"EKOBasePlayerChangedSubtitleNotification";
NSString *const EKOBasePlayerPlaybackJumpedNotification = @"EKOBasePlayerPlaybackJumpedNotification";
NSString *const EKOBasePlayerPlaybackEndedNotification = @"EKOBasePlayerPlaybackEndedNotification";
NSString *const EKOBasePlayerPlaybackStalledNotification = @"EKOBasePlayerPlaybackStalledNotification";
NSString *const EKOBasePlayerPlaybackEndedFailureNotification = @"EKOBasePlayerPlaybackEndedFailureNotification";



@implementation EKOBasePlayer

- (id)init
{
    if ((self = [super init])) {
        // by default no notifications are send
        _generateNotifications = NO;
        _status = EKOBasePlayerStatusUnknown;
        _prevStatus = EKOBasePlayerStatusUnknown;
    }
    
    return self;
}


#pragma mark - STUBS

- (void)play
{
    
}

- (void)pause
{
    
}

- (void)rewind
{
    
}

- (void)forward
{
    
}

- (BOOL)canRewind
{
    return NO;
}

- (BOOL)canForward
{
    return NO;
}


#pragma mark - Status

- (void)setType:(EKOBasePlayerType)type
{
    if (type != _type) {
        _type = type;
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:changedType:)]) {
            [self.delegate player:self changedType:_type];
        }
        
        if (self.generateNotifications) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerChangedTypeNotification
                                                                object:self
                                                              userInfo:@{@"type": [NSNumber numberWithInteger:type]}];
        }
    }
}

- (void)setStatus:(EKOBasePlayerStatus)status
{
    if (status != _status) {
        _status = status;
        if (self.delegate && [self.delegate respondsToSelector:@selector(player:changedStatus:)]) {
            [self.delegate player:self changedStatus:_status];
        }
        
        if (self.generateNotifications) {
            [[NSNotificationCenter defaultCenter] postNotificationName:EKOBasePlayerChangedStatusNotification
                                                                object:self
                                                              userInfo:@{@"status": [NSNumber numberWithInteger:status]}];
        }
    }
}

@end
