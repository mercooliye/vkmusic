//
//  vkLoginViewController.h
//  VKAPI
//
//  Created by Alexander on 05.11.11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface vkLoginViewController : UIViewController <UIWebViewDelegate> {
    
    id delegate;
   // UIWebView *vkWebView;
    NSString *appID;
    
}
@property (weak, nonatomic) IBOutlet UIWebView *vkWebView;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (retain, nonatomic) IBOutlet UINavigationItem *navitem;
@property (nonatomic, retain) id delegate;

@property (nonatomic, retain) NSString *appID;
@property (retain, nonatomic) IBOutlet UINavigationBar *navBar1;
-(void)ok1;


- (NSString*)stringBetweenString:(NSString*)start 
                       andString:(NSString*)end 
                     innerString:(NSString*)str;
@end
