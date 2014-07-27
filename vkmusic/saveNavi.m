//
//  saveNavi.m
//  vkmusic
//
//  Created by CooLX on 15/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import "saveNavi.h"

@interface saveNavi ()

@end

@implementation saveNavi

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
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FinishSave:) name:@"finishsave" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ProgressSave:) name:@"progresssave" object:nil];

    
    
}
-(void) viewWillAppear:(BOOL)animated
{
    [self.tabBarItem setBadgeValue:nil];
}
-(void)ProgressSave:(NSNotification *)n
{
    [ self.tabBarItem setBadgeValue:[NSString stringWithFormat:@"%@ КБ", [n valueForKey:@"userInfo"]]];

}


-(void)FinishSave:(NSNotification *)n
{
    [ self.tabBarItem setBadgeValue:@"Готово!"];
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
