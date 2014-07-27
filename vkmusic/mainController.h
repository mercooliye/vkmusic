//
//  mainController.h
//  vkmusic
//
//  Created by CooLX on 27/06/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SoundPlayer.h"

@interface mainController : UIViewController<UITableViewDelegate, UITableViewDataSource>
#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressupdate;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (strong, nonatomic)  AVAudioPlayer * player;
@property (strong, nonatomic)  AVPlayer * avp;
@property (strong, nonatomic)  NSArray * Items;
@property (weak, nonatomic) IBOutlet UIButton *groundPaybtn;
@property (weak, nonatomic) IBOutlet UILabel *nametrack;
@property (weak, nonatomic) IBOutlet UILabel *artist;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progress;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet NSString *saveurl;


@end
