//
//  mainTabBar.m
//  vkmusic
//
//  Created by CooLX on 15/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "mainTabBar.h"
#import "mainController.h"  
#import "saveMainController.h"
#import "saveNavi.h"
#import "Navi.h"


@interface mainTabBar ()

@end

@implementation mainTabBar

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    saveMainController *smaincnt=[saveMainController alloc];
    mainController *maincnt=[mainController alloc];

    saveNavi *snavi=[saveNavi alloc];
    Navi *navi=[Navi alloc];
    
  //  [maincnt viewDidLoad];
   // [smaincnt viewDidLoad];
    
    [snavi viewDidLoad];
    [navi viewDidLoad];
    [self setSelectedIndex:1];
    [self setSelectedIndex:0];

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
