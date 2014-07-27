//
//  recordFile.m
//  vkmusic
//
//  Created by CooLX on 13/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "recordFile.h"

@implementation recordFile
@synthesize multdata;
#define music [[NSUserDefaults standardUserDefaults] valueForKey:@"music"]

-(void) startsave:(NSURL*)url :(NSDictionary*)dict      //////
{
    multdata=[[NSMutableData alloc]  init];
    self.item=dict;
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];

    self.connsave= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    multdata = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [multdata appendData:data];
  //  NSLog([NSString stringWithFormat:@"%d", multdata.length]);
    NSString *length=[NSString stringWithFormat:@"%d", multdata.length/1000 ];
 //   NSDictionary *dic=[[NSDictionary alloc] ini];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"progresssave" object:nil userInfo:length];


}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
// NSData *music=[NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    
     NSString *appFile = [DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", [self.item valueForKey:@"id"]]];
     [multdata writeToFile:appFile atomically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishsave" object:nil userInfo:self.item];
/////////////
    ///READ

    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"musiclist.plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    NSMutableArray *arrtmp=[[NSMutableArray alloc] init];
    arrtmp = (NSMutableArray *)[NSPropertyListSerialization
                                propertyListFromData:plistXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
    
///WRITE

    NSMutableArray *arrtmp2=[[NSMutableArray alloc] initWithArray:arrtmp];
    [arrtmp2 addObject:self.item];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:arrtmp2
    format:NSPropertyListXMLFormat_v1_0
    errorDescription:nil];
    [plistData writeToFile:plistPath atomically:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"finishsave" object:nil userInfo:nil];//сказали что закончили загрузку

}



@end



