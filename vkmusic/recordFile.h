//
//  recordFile.h
//  vkmusic
//
//  Created by CooLX on 13/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface recordFile : NSObject
@property (weak, nonatomic) NSURLConnection *connsave;
@property (weak, nonatomic) NSDictionary *item;
@property (strong, nonatomic) NSMutableData *multdata;

#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]


-(void) startsave:(NSURL*)url :(NSDictionary*)dict;

@end
