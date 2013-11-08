//
//  TopViewController.h
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *topView;
@property (strong, nonatomic) NSMutableArray *dataList;
- (IBAction)doBtnToGame:(id)sender;

@end
