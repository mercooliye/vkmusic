//
//  saveMainController.m
//  vkmusic
//
//  Created by CooLX on 10/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "saveMainController.h"
#import "cellSaveAudio.h"
#import "SoundPlayer.h"
#import "saveNavi.h"

@interface saveMainController ()

@end

@implementation saveMainController
@synthesize table;
@synthesize Items;
NSMutableArray *saveitem;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    return saveitem.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    cellSaveAudio *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.text=[[saveitem objectAtIndex:indexPath.row] valueForKey:@"title"];
    cell.artist.text=[[saveitem objectAtIndex:indexPath.row] valueForKey:@"artist"];

    return cell;
    
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Удалить";
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *fileString = [DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", [[saveitem objectAtIndex:indexPath.row ] valueForKey:@"id"]]];
    [[NSFileManager defaultManager] removeItemAtPath: fileString error: nil];// удаляем сам файл
    
    
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
    
    [arrtmp removeObjectAtIndex:indexPath.row];

    //NSMutableArray *arrtmp2=[[NSMutableArray alloc] initWithArray:arrtmp];
    //[arrtmp2 addObject:self.item];
    NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:arrtmp
                                                                   format:NSPropertyListXMLFormat_v1_0
                                                         errorDescription:nil];
    [plistData writeToFile:plistPath atomically:YES];
    
    
    saveitem=arrtmp;
   // [self.table setEditing:!self.table.editing animated:YES];

    [table reloadData];
    /* My custom code here */
}


-(void) viewDidAppear
{
    //  multdata=[[NSMutableData alloc] init];
    //  datadict =[[NSMutableDictionary alloc ] init];
    // Do any additional setup after loadi	ng the view.
  /*
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"musiclist.plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    saveitem=[[NSMutableArray alloc] init];
    saveitem = (NSMutableArray *)[NSPropertyListSerialization
                                  propertyListFromData:plistXML
                                  mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                  format:&format
                                  errorDescription:&errorDesc];
    
    
    
    [table reloadData];
    */

}
-(void) viewWillAppear:(BOOL)animated
{
    //self.tabBarItem.badgeValue=@"123";

}

- (void)viewDidLoad
{

    [super viewDidLoad];
    self.navigationItem.title=@"Сохраненные";
  //  multdata=[[NSMutableData alloc] init];
  //  datadict =[[NSMutableDictionary alloc ] init];
    // Do any additional setup after loading the view.
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *plistPath = [rootPath stringByAppendingPathComponent:@"musiclist.plist"];
    NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSPropertyListFormat format;
    NSString *errorDesc = nil;
    saveitem=[[NSMutableArray alloc] init];
    saveitem = (NSMutableArray *)[NSPropertyListSerialization
                                propertyListFromData:plistXML
                                mutabilityOption:NSPropertyListMutableContainersAndLeaves
                                format:&format
                                errorDescription:&errorDesc];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartPlay:) name:@"startplay" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishSave:) name:@"finishsave" object:nil];


  
    [table reloadData];
/*
     AVPlayerItem* playerItem =[[AVPlayerItem alloc] init];
     playerItem = [AVPlayerItem  playerItemWithURL:url];
     avp=[AVPlayer playerWithPlayerItem:playerItem];
     [avp play];
*/
    
//  NSLog(fileString);

    
//  NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
     //NSString *documentsDirectory = [paths objectAtIndex:0];
    //   NSString *path = [paths stringByAppendingPathComponent:fileString];
    // NSURL *url = [[NSURL alloc] initFileURLWithPath: fileString];

    
    
    
    
    //   [[SoundPlayer sharedPlayer] playFile:fileString volume:0.5f loops:0];
    
    
    
//    multdata = [NSMutableData data ];
}

-(void)FinishSave:(NSNotification *)n
{
   [ self.tabBarItem setBadgeValue:@"1"];
    [self viewDidLoad];
}

-(void)StartPlay:(NSNotification *)n
{
    [self.gndpaybtn setHidden:NO];
    if (sound.saveplay)
    {
        [self.gndpaybtn setImage:[UIImage imageNamed:@"playsave.png"] forState:UIControlStateNormal];
    }
}

-(void)itemDidFinishPlaying:(NSNotification *)n
{
    NSLog(@"MUSIC END");
}
- (IBAction)pause_play:(id)sender
{
    [self.navigationController pushViewController:sound.ViewPlayer animated:YES];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

{
   // [multdata appendData:data];
    NSLog([NSString stringWithFormat:@"data "]);
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index= [self.table indexPathForSelectedRow];
    
  //  if ([[segue identifier] isEqualToString:@"player"])
   // {
      //  NSIndexPath *index= [self.table indexPathForSelectedRow];
        NSString *fileString = [DOCUMENTS stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3", [[saveitem objectAtIndex:index.row ] valueForKey:@"id"]]];

NSLog(fileString);
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileString];
    sound.items=saveitem;
    sound.index=index;
    sound.url=[[NSURL alloc] initFileURLWithPath: fileString];
    sound.saveplay=YES;
  //  }
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
    /*
    NSDictionary *res= [[NSJSONSerialization JSONObjectWithData:multdata options:kNilOptions error:nil] valueForKey:@"response"];
    NSArray *items=[res valueForKey:@"items"];
    NSString *path=[[items objectAtIndex:0] valueForKey:@"url"];
    
    Items=items;
 */
    ///    NSData *music=[NSData dataWithContentsOfURL:[NSURL URLWithString:path]];
    
    
    // NSString *appFile = [DOCUMENTS stringByAppendingPathComponent:@"MusicFile.mp3"];
    // [music writeToFile:appFile atomically:YES]  ;
    
    //  NSData *datatemp=[[NSData alloc] initWithContentsOfFile:appFile];
    //  NSError *error;
    
    //    NSURL *url = [[NSURL alloc] initFileURLWithPath:@"http://cs1555.vk.me/u2602785/audios/bc9d48764f26.mp3"];
    
    [table reloadData];
    
/*
     self.player= [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] ;
     if (! player) {
     NSLog(@"Sound had error %@", [error localizedDescription]);
     } else {
     [player prepareToPlay];
     [player play];
     }
*/
}
@end
