//
//  saveMainController.h
//  vkmusic
//
//  Created by CooLX on 10/07/14.
//  Copyright (c) 2014 CooLX. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface saveMainController : UIViewController<UITableViewDelegate, UITableViewDataSource>
#define DOCUMENTS [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]
#define sound [ SoundPlayer sharedPlayer]


@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIButton *gndpaybtn;

@property (strong, nonatomic)  NSArray * Items;
@end
