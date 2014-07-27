//
//  SoundPlayer.h
//  MySoundPlayer
//
//  Created by Alximik on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <AudioToolbox/AudioServices.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer : NSObject {
    NSMutableDictionary *audioFiles;
    

    
}

@property (nonatomic,retain) NSMutableDictionary *audioFiles;
@property AVPlayer *avplayer;

@property NSURL *url;
@property NSArray *items;
@property NSIndexPath *index;
@property BOOL isPlay;
@property BOOL isPause;
@property BOOL isInit;
@property BOOL repeat;
@property BOOL shuffle;
@property BOOL saveplay;


@property UIViewController *ViewPlayer;




+(SoundPlayer *)sharedPlayer;

+ (void)playSound:(NSString*)soundName;

- (void)cacheWithFiles:(NSArray *)sounds;
- (void)playFile:(NSString*)soundFileName volume:(CGFloat)volume loops:(NSInteger)numberOfLoops;
- (void)resumePlaing:(NSString*)soundFileName;
- (void)resumePlaing:(NSString*)soundFileName withVolume:(CGFloat)volume;
- (void)pausePlaing:(NSString*)soundFileName;
- (void)stopPlaing:(NSString*)soundFileName;
- (BOOL)isPlaying:(NSString*)soundFileName;

@end
