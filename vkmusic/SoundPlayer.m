//
//  SoundPlayer.m
//  MySoundPlayer
//
//  Created by Alximik on 15.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundPlayer.h"

@implementation SoundPlayer

@synthesize audioFiles;
//@synthesize avplayer;



static SoundPlayer * sharedPlayer = NULL;
+ (SoundPlayer *) sharedPlayer {
    if ( !sharedPlayer || sharedPlayer == NULL ) {
        sharedPlayer = [SoundPlayer new];
    }
    
    return sharedPlayer;
}



+ (void)playSound:(NSString*)soundName {
    SystemSoundID volleyFile;
    NSString *volleyPath = [[NSBundle mainBundle] pathForResource:soundName ofType:nil];
    CFURLRef volleyURL = (__bridge CFURLRef ) [NSURL fileURLWithPath:volleyPath];
    AudioServicesCreateSystemSoundID (volleyURL, &volleyFile);
    AudioServicesPlaySystemSound(volleyFile);
}



- (void)cacheWithFiles:(NSArray *)sounds {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSError *error;
    
    self.audioFiles = [NSMutableDictionary dictionary];
    
    for (NSString *fileName in sounds) {
        NSURL *soundURL = [NSURL fileURLWithPath:[mainBundle pathForResource:fileName ofType:nil]];
        AVAudioPlayer *myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundURL 
                                                                              error:&error];
        if (myAudioPlayer) {
            [myAudioPlayer prepareToPlay];
            [audioFiles setObject:myAudioPlayer forKey:fileName];
        } else {
            NSLog(@"Error in file(%@): %@\n", fileName, [error localizedDescription]);
        }
    }    
}

- (void)playFile:(NSString*)soundFileName volume:(CGFloat)volume loops:(NSInteger)numberOfLoops {
    AVAudioPlayer *sound = [audioFiles objectForKey:soundFileName];
    sound.volume = volume;
    sound.numberOfLoops = numberOfLoops;
    sound.currentTime = 0.0f;
    [sound play];
}

- (void)resumePlaing:(NSString*)soundFileName {
    AVAudioPlayer *sound = [audioFiles objectForKey:soundFileName];
	[sound pause];    
}

- (void)resumePlaing:(NSString*)soundFileName withVolume:(CGFloat)volume {
    AVAudioPlayer *sound = [audioFiles objectForKey:soundFileName];
    sound.volume = volume;
	[sound play];    
}

- (void)pausePlaing:(NSString*)soundFileName {
    AVAudioPlayer *sound = [audioFiles objectForKey:soundFileName];
	[sound pause];
}

- (void)stopPlaing:(NSString*)soundFileName {
    AVAudioPlayer *sound = [audioFiles objectForKey:soundFileName];
	[sound stop];    
}

- (BOOL)isPlaying:(NSString*)soundFileName {
    AVAudioPlayer *sound = [audioFiles objectForKey:soundFileName];
	return sound.playing;    
}

@end
