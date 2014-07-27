//
//  musicController.m
//  vkmusic
//
//  Created by CooLX on 08/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "musicController.h"

@interface musicController ()


@end

@implementation musicController
@synthesize slider;
NSUInteger localindex;

#define sound [ SoundPlayer sharedPlayer]


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSString*)timeFormat:(float)value{
    
    float minutes = floor(lroundf(value)/60);
    float seconds = lroundf(value) - (minutes * 60);
    
    int roundedSeconds = lroundf(seconds);
    int roundedMinutes = lroundf(minutes);
    
    NSString *time = [[NSString alloc]
                      initWithFormat:@"%d:%02d",
                      roundedMinutes, roundedSeconds];
    return time;
}



- (void)updateTime:(NSTimer *)timer {
    //to don't update every second. When scrubber is mouseDown the the slider will not set
   // if (!self.scrubbing) {
    CMTime time= [[ SoundPlayer sharedPlayer].avplayer currentTime] ;
     CMTime duration=  [ [ SoundPlayer sharedPlayer].avplayer.currentItem duration] ;
    

    float f_time=time.value/time.timescale;
    [slider setValue:f_time animated:YES];
    float f_duration=duration.value/duration.timescale;
    [slider setMaximumValue:f_duration];

 //   self.timelabel.text=  [NSString stringWithFormat:@"%f.0", f];
    self.timelabel.text=  [self timeFormat:f_time];
    self.timeendlabel.text=[self timeFormat:f_duration];

//    NSLog([NSString stringWithFormat:@"%f.2", f_duration]);
}
- (IBAction)play:(id)sender {
    if(!sound.isPause)
    {
    [self.playbtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        sound.isPause=YES;
        [sound.avplayer pause];
    }
   else
    {
        [self.playbtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
       // sound.isPlay=YES;
        sound.isPause=NO;
        [sound.avplayer play];

    }
    
   // [SoundPlayer sharedPlayer].avplayer
}
- (IBAction)repeat:(id)sender
{
    if (sound.repeat)
    {
        [self.repeatbtn setImage:[UIImage imageNamed:@"repeat.png" ] forState:UIControlStateNormal];
            sound.repeat=NO;
    }
    
    else{
        [self.repeatbtn setImage:[UIImage imageNamed:@"repeat_press.png" ] forState:UIControlStateNormal];
        sound.repeat=YES;
    }
}
- (IBAction)shuffle:(id)sender
{
    if (sound.shuffle)
    {
        [self.shufflebtn setImage:[UIImage imageNamed:@"shuffle.png" ] forState:UIControlStateNormal];
        sound.shuffle=NO;
    }
    
    else{
        [self.shufflebtn setImage:[UIImage imageNamed:@"shuffle_press.png" ] forState:UIControlStateNormal];
        sound.shuffle=YES;
    }
}

- (IBAction)backplay:(id)sender {
    
    if (localindex==0) {
        localindex=sound.items.count-1;
    }
    else
    localindex--;
    // sound.index=[NSIndexPath indexPathWithIndex:localindex];
    
    NSURL *url=[NSURL URLWithString:[[[SoundPlayer sharedPlayer].items objectAtIndex:localindex] valueForKey:@"url"]];
    
    if(sound.saveplay)
    {
        [self.savebtn setHidden:YES];
        
        NSArray *item=sound.items;
        NSURL *urlid=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ [item objectAtIndex:localindex] valueForKey:@"id"]]];
        NSString *urlst=[NSString stringWithFormat:@"%@", urlid];
        urlid=[[NSURL alloc] initFileURLWithPath:[DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", urlst]]];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:urlid options:nil];
        AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
        sound.avplayer = [AVPlayer playerWithPlayerItem:anItem];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:anItem];
        
    }
    else
    {
        [SoundPlayer sharedPlayer].avplayer =[AVPlayer playerWithURL:url];
    }
    [[SoundPlayer sharedPlayer].avplayer play];

    
    self.namelabel.text=[[[SoundPlayer sharedPlayer].items objectAtIndex:localindex] valueForKey:@"title"];
    self.artistlabel.text=[[[SoundPlayer sharedPlayer].items objectAtIndex:localindex ] valueForKey:@"artist"];
    float max=[[SoundPlayer sharedPlayer].avplayer.currentItem duration].value/[[SoundPlayer sharedPlayer].avplayer.currentItem duration].timescale;
    slider.value=0;
    slider.maximumValue=max;
    slider.minimumValue=0;
    sound.avplayer.volume=self.volumeSlider.value;
    
   
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startplay" object:nil userInfo:nil];

}
- (IBAction)forwardplay:(id)sender {
    if (localindex==sound.items.count-1) {
        localindex=0;
    }
    else
        localindex++;

    
    
   // sound.index=[NSIndexPath indexPathWithIndex:localindex];
    NSURL *url=[NSURL URLWithString:[[[SoundPlayer sharedPlayer].items objectAtIndex:localindex] valueForKey:@"url"]];

    if(sound.saveplay)
    {
        [self.savebtn setHidden:YES];
    
        NSArray *item=sound.items;
        
      //  NSURL *urlid=[NSURL URLWithString:[[[SoundPlayer sharedPlayer].items valueForKey:@"id"] objectAtIndex:localindex]];
        NSURL *urlid=[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ [item objectAtIndex:localindex] valueForKey:@"id"]]];
        NSString *urlst=[NSString stringWithFormat:@"%@", urlid];
     urlid=[[NSURL alloc] initFileURLWithPath:[DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", urlst]]];
        AVAsset *asset = [AVURLAsset URLAssetWithURL:urlid options:nil];
        AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
        sound.avplayer = [AVPlayer playerWithPlayerItem:anItem];
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:anItem];
    }
    else
    {
    [SoundPlayer sharedPlayer].avplayer =[AVPlayer playerWithURL:url];
    }
  
    [[SoundPlayer sharedPlayer].avplayer play];

    
    self.namelabel.text=[[[SoundPlayer sharedPlayer].items objectAtIndex:localindex] valueForKey:@"title"];
    self.artistlabel.text=[[[SoundPlayer sharedPlayer].items objectAtIndex:localindex ] valueForKey:@"artist"];
    float max=[[SoundPlayer sharedPlayer].avplayer.currentItem duration].value/[[SoundPlayer sharedPlayer].avplayer.currentItem duration].timescale;
    slider.value=0;
    slider.maximumValue=max;
    slider.minimumValue=0;
    sound.avplayer.volume=self.volumeSlider.value;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"startplay" object:nil userInfo:nil];
    
    
}

- (void)viewDidLoad
{
    self.volumeSlider.transform = CGAffineTransformRotate(slider.transform, -M_PI/2);
      self.volumeSlider2.transform = CGAffineTransformRotate(slider.transform, -M_PI/2);
    self.volumeSlider.value=[[[NSUserDefaults standardUserDefaults] valueForKey:@"volume"] floatValue];
    self.volumeSlider2.value=[[[NSUserDefaults standardUserDefaults] valueForKey:@"volume"] floatValue];
    
    sound.ViewPlayer=self;
    localindex=sound.index.row;
    [super viewDidLoad];
    // Do any additional setup after loading the view.rl
    NSURL *url=[SoundPlayer sharedPlayer].url;
    
    self.namelabel.text=[[[SoundPlayer sharedPlayer].items objectAtIndex:[SoundPlayer sharedPlayer].index.row] valueForKey:@"title"];
    
    self.artistlabel.text=[[[SoundPlayer sharedPlayer].items objectAtIndex:[SoundPlayer sharedPlayer].index.row] valueForKey:@"artist"];
 
    if(sound.saveplay)
{
    [self.savebtn setHidden:YES];
AVAsset *asset = [AVURLAsset URLAssetWithURL:url options:nil];
AVPlayerItem *anItem = [AVPlayerItem playerItemWithAsset:asset];
    
    sound.avplayer = [AVPlayer playerWithPlayerItem:anItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:anItem];
    
}

    
else
{
    [self.savebtn setHidden:NO];

    [SoundPlayer sharedPlayer].avplayer =[AVPlayer playerWithURL:url];
}
    
    [[SoundPlayer sharedPlayer].avplayer play];
    [sound.avplayer setVolume:[[[NSUserDefaults standardUserDefaults] valueForKey:@"volume"]floatValue]];

    float max=[[SoundPlayer sharedPlayer].avplayer.currentItem duration].value/[[SoundPlayer sharedPlayer].avplayer.currentItem duration].timescale;
    slider.value=0;
    slider.maximumValue=max;
    slider.minimumValue=0;
    
  //  [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEvent];
    sound.isPause=NO;
    sound.isInit=YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                  target:self
                                                selector:@selector(updateTime:)
                                                userInfo:nil
                                                 repeats:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startplay" object:nil userInfo:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:sound.avplayer.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishSave:) name:@"finishsave" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProgressSave:) name:@"progresssave" object:nil];

    
}
-(void) ProgressSave:(NSNotification *)n
{
  //NSLog([NSString stringWithFormat:@"%@", [n valueForKey:@"userInfo"]]);
    
   // self.lenght.text=[NSString stringWithFormat:@"%@ КБ", [n valueForKey:@"userInfo"]];
}

- (IBAction)startSave:(id)sender
{
    recordFile *rcFile=[[recordFile alloc] init];
    [rcFile startsave:sound.url :[sound.items objectAtIndex:localindex]];
    
    
    [self.progresssave startAnimating];
}
-(void)FinishSave:(NSNotification *)n
{
  //  NSLog(n.userInfo);
    NSLog([NSString stringWithFormat:@"%@", [n.userInfo valueForKey:@"id" ]]);
  // NSDictionary *info= n.userInfo;
    [self.progresssave stopAnimating];

}

-(void)itemDidFinishPlaying:(NSNotification *)n
{
    if (sound.repeat)
    {
        [self viewDidLoad];
    }
 //   if(sound.shuffle)
  //  {
        
   // }
    else
    {
        [self forwardplay:@"1"];
    }
    
}

- (IBAction)sliderChanged:(id)sender
{
if ([self.timer isValid])
    [self.timer invalidate];
    
    self.timelabel.text=  [self timeFormat:slider.value];
 }

- (IBAction)sliderInside:(id)sender
    {
    
    [[ SoundPlayer sharedPlayer].avplayer pause];
    
    float timescale=[[ SoundPlayer sharedPlayer].avplayer currentTime].timescale;
    CMTime setTime= CMTimeMake(slider.value*timescale, timescale);
    
    [[SoundPlayer sharedPlayer].avplayer.currentItem seekToTime:setTime];
    NSLog([NSString stringWithFormat:@"%f", slider.value]);
    
    [[ SoundPlayer sharedPlayer].avplayer play];
        
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                      target:self
                                                    selector:@selector(updateTime:)
                                                    userInfo:nil
                                                     repeats:YES];

}
- (IBAction)volumeChanged:(id)sender {
    self.volumeSlider2.value=self.volumeSlider.value;

    [[SoundPlayer sharedPlayer].avplayer setVolume:self.volumeSlider.value];
    [[NSUserDefaults standardUserDefaults] setFloat:sound.avplayer.volume forKey:@"volume"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)volumeChanged2:(id)sender {
    self.volumeSlider.value=self.volumeSlider2.value;
    
    [[SoundPlayer sharedPlayer].avplayer setVolume:self.volumeSlider.value];
    [[NSUserDefaults standardUserDefaults] setFloat:sound.avplayer.volume forKey:@"volume"];
    [[NSUserDefaults standardUserDefaults] synchronize];


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
