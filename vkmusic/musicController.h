//
//  musicController.h
//  vkmusic
//
//  Created by CooLX on 08/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPlayer.h"
#import "recordFile.h"

@interface musicController : UIViewController
#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]

@property (weak, nonatomic) IBOutlet UISlider *slider;
@property NSTimer *timer;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *timeendlabel;

@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider2;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
@property (weak, nonatomic) IBOutlet UILabel *artistlabel;

@property (weak, nonatomic) IBOutlet UIButton *playbtn;
@property (weak, nonatomic) IBOutlet UIButton *repeatbtn;
@property (weak, nonatomic) IBOutlet UIButton *shufflebtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progresssave;
@property (weak, nonatomic) IBOutlet UILabel *lenght;
@property (weak, nonatomic) IBOutlet UIButton *savebtn;

@end
