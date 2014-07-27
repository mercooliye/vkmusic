//
//  mainController.m
//  vkmusic
//
//  Created by CooLX on 27/06/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "mainController.h"
#import "CellAudoi.h"
#import "recordFile.h"



@interface mainController ()

@end

@implementation mainController
NSURLConnection *conn;
NSURLConnection *connupd;

NSMutableData *multdata;
NSMutableDictionary *datadict;
@synthesize table;
@synthesize player;
@synthesize avp;
@synthesize Items;
@synthesize progress;
#define sound [ SoundPlayer sharedPlayer]


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
    return Items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchText resignFirstResponder];

    
    CellAudoi *cell=[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.title.text=[[Items objectAtIndex:indexPath.row] valueForKey:@"title"];
    
    cell.artist.text=[[Items objectAtIndex:indexPath.row] valueForKey:@"artist"];
/*
    if(indexPath.row==self.Items.count-1&&![[ NSString stringWithFormat:@"%@",self.searchText.text] isEqualToString:@""])
    {
        NSString *urlString = [NSString stringWithFormat:@"https://api.vk.com/method/audio.search?access_token=2fff5d4ffdb7719c9c002c9c01b441f030c35533b03eabbf1c44f0cc9a3b087f9c59d391de3a2c06d4993&v=5.21&auto_complete=1&count=100&q=%@&offset=%d", self.searchText.text , Items.count];//, [[NSUserDefaults standardUserDefaults] objectForKey:@"VKdccessToken"]];
        urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
        
        connupd= [[NSURLConnection alloc] initWithRequest:request delegate:self];
        multdata = [NSMutableData data ];
        [self.progressupdate startAnimating];
 
    }
    */

    return cell;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
 //   [self.table setEditing:!self.table.editing animated:YES];

    return @"Сохранить";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
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
    ////////////////////////
    NSArray *arrid=   [arrtmp valueForKey:@"id"];
    NSArray *ids =[self.Items valueForKey:@"id"];
    NSString *st=[NSString stringWithFormat:@"%@",[ids objectAtIndex:indexPath.row] ];
    
    BOOL exist = NO;
    for (int i=0; i<arrid.count; i++) {
        NSString *stsave=[NSString stringWithFormat:@"%@",[arrid objectAtIndex:i] ];
        if([st isEqualToString: stsave])
        {
            exist=YES;
        }
    }
    
    if (exist)
    {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Такая песня уже сохранена" delegate:nil cancelButtonTitle:@"Хорошо" otherButtonTitles:nil, nil];
        [alert show];
    
    //проверить находится ли на этапе загрузок добавить массив загрузок
    // проверка существования в сохраненных, алерт если совпадение по id
    // вызов файлрекорд, передача items, и url
    //	 сделать бейдж на сохраненных
    }
    else
    {
        recordFile *rcfile=[[recordFile alloc] init];
        [rcfile startsave:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[ [self.Items objectAtIndex:indexPath.row] valueForKey:@"url"] ]] :[self.Items objectAtIndex:indexPath.row]] ;
    }
    
    
    
    [self.table setEditing:!self.table.editing animated:YES];

    
    /* My custom code here */
}
- (IBAction)play_pause:(id)sender {
    
 //   NSArray *controllers = self.navigationController.viewControllers;
  //  [self dismissModalViewControllerAnimated:YES];

    [self.navigationController pushViewController:sound.ViewPlayer animated:YES];
/*
    if (!sound.isPause)
    {
        [sound.avplayer pause];
        sound.isPause=YES;
        [self.groundPaybtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
    else
    {
        [sound.avplayer play];
        sound.isPause=NO;
        [self.groundPaybtn setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        
        

    }
 */
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField;              // called when 'return' key pressed. return NO to ignore.
{
    [self startsearch];
    
    return YES;
}
-(void) startsearch
{
    
    [self.searchText resignFirstResponder];
    [self.table scrollRectToVisible:CGRectMake(0, 0, 10 , 20) animated:YES];
    
   // NSString *urlString = [NSString stringWithFormat:@"https://api.vk.com/method/audio.search?access_token=2fff5d4ffdb7719c9c002c9c01b441f030c35533b03eabbf1c44f0cc9a3b087f9c59d391de3a2c06d4993&v=5.21&auto_complete=1&count=300&q=%@", self.searchText.text];//, [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"]];
    NSString *urlString = [NSString stringWithFormat:@"https://api.vk.com/method/audio.search?access_token=%@&v=5.21&auto_complete=1&count=300&q=%@", [[NSUserDefaults standardUserDefaults]objectForKey:@"VKAccessToken"], self.searchText.text] ;
    urlString= [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];
    
    conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    multdata = [NSMutableData data ];
    [progress startAnimating];
    
}


- (IBAction)search:(id)sender {
    [self.searchText resignFirstResponder];
    [self.table scrollRectToVisible:CGRectMake(0, 0, 10 , 20) animated:YES];
    
    [self viewDidLoad];
    
}
-(void)StartPlay:(NSNotification *)n
{
    [self.groundPaybtn setHidden:NO];
    
    [self.groundPaybtn setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
}
-(void)FinishSave:(NSNotification *)n
{
 //   [self.groundPaybtn setHidden:NO];
}

- (void)viewWillAppear
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.groundPaybtn setHidden:YES ];
    NSMutableArray *dicty=  [[NSMutableArray    alloc] init];
//    [dicty addObject:@"ww"   ];
 //[[NSUserDefaults standardUserDefaults] setObject:dicty forKey:@"music"];
 //[[NSUserDefaults  standardUserDefaults] synchronize  ];
    [progress startAnimating];
    multdata=[[NSMutableData alloc] init];
    datadict =[[NSMutableDictionary alloc ] init];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartPlay:) name:@"startplay" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishSave:) name:@"finishsave" object:nil];
    if(sound.isInit)
      [ self.groundPaybtn setHidden:NO];
   /* [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

*/
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.vk.com/method/audio.get?owner_id=%@&access_token=%@&v=5.21",[[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessUserId"], [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"]];
  
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:15.0];

    conn= [[NSURLConnection alloc] initWithRequest:request delegate:self];
  //  NSData *datatemp=[[NSData alloc] initWithContentsOfFile:[DOCUMENTS stringByAppendingPathComponent:@"MusicFile"]];
    //NSURL *url = [[NSURL alloc] initWithString:@"http:\/\/cs521106.vk.me\/u6034898\/audios\/bd3777fb3cc5.mp3?extra=l62tTjlwovolWQSOaJpMSuj18y_0vyeJ3JYclPRrJahzmesF6xgJ-4xXsICdy8AqnKqZZp2lisBiGjDc-tCX9Qhbpy7e"];
    /*
    AVPlayerItem* playerItem =[[AVPlayerItem alloc] init];
    playerItem = [AVPlayerItem  playerItemWithURL:url];
    avp=[AVPlayer playerWithPlayerItem:playerItem];
    [avp play];
    */
    
    // Subscribe to the AVPlayerItem's DidPlayToEndTime notification.
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
   
    NSError *error;

    
   // player=[[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    //[player play];
     [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    NSLog([NSString stringWithFormat:@"%@", error ]);
    
    NSString *fileString = [DOCUMENTS stringByAppendingPathComponent:@"MusicFile.mp3"];
    NSLog(fileString);
   //  AVAudioPlayer *player=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:fileString] error:&error] ;
   // [player prepareToPlay];
  //  [player play];
    
   /*
   // NSString *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
   //NSString *documentsDirectory = [paths objectAtIndex:0];
  //  NSString *path = [paths stringByAppendingPathComponent:fileString];
    NSURL *url = [[NSURL alloc] initFileURLWithPath: fileString];
    AVAudioPlayer *sound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error] ;
    if (! sound) {
        NSLog(@"Sound had error %@", [error localizedDescription]);
    } else {
        [sound prepareToPlay];
        [sound play];
    }
    */
    
    
 //   [[SoundPlayer sharedPlayer] playFile:fileString volume:0.5f loops:0];
    
  
    
    multdata = [NSMutableData data ];
}
-(void)itemDidFinishPlaying:(NSNotification *)n
{
        NSLog(@"MUSIC END");
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

{
    [multdata appendData:data];
    NSLog([NSString stringWithFormat:@"data "]);
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;
{
if (connection==conn) {
        
    
    NSDictionary *res= [[NSJSONSerialization JSONObjectWithData:multdata options:kNilOptions error:nil] valueForKey:@"response"];
    NSArray *items=[res valueForKey:@"items"];
    if (items.count==0) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Нет записей" message:@"Измените поисковый запрос" delegate:self cancelButtonTitle:@"Хорошо" otherButtonTitles:nil, nil];
        
        [progress stopAnimating];
        [alert show];
    }
else
    {
    NSString *path=[[items objectAtIndex:0] valueForKey:@"url"];
    Items =items;
    
//    NSData *music=[NSData dataWithContentsOfURL:[NSURL URLWithString:path]];

    
// NSString *appFile = [DOCUMENTS stringByAppendingPathComponent:@"MusicFile.mp3"];
// [music writeToFile:appFile atomically:YES]  ;
    
//  NSData *datatemp=[[NSData alloc] initWithContentsOfFile:appFile];
//  NSError *error;
	
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:@"http://cs1555.vk.me/u2602785/audios/bc9d48764f26.mp3"];
  
        
    [progress stopAnimating];
    [table reloadData];
    }
    
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
    
    if (connection==connupd) {
        NSDictionary *res= [[NSJSONSerialization JSONObjectWithData:multdata options:kNilOptions error:nil] valueForKey:@"response"];
        NSArray *items=[res valueForKey:@"items"];
        [self.Items arrayByAddingObjectsFromArray:items  ];
        [self.progressupdate stopAnimating] ;
        [table reloadData];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index= [self.table indexPathForSelectedRow];
    NSString *path=[[Items objectAtIndex:index.row] valueForKey:@"url"];
    
    if ([[segue identifier] isEqualToString:@"player"])
    {
        NSIndexPath *index= [self.table indexPathForSelectedRow];
        NSString *path=[[Items objectAtIndex:index.row] valueForKey:@"url"];
        sound.saveplay=NO;
        
       [SoundPlayer sharedPlayer].items=Items;
       [SoundPlayer sharedPlayer].index=index;
        [SoundPlayer sharedPlayer].url=[NSURL URLWithString:path];
    }
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
