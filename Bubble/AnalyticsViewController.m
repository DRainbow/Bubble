//
//  AnalyticsViewController.m
//  Bubble
//
//  Created by apple on 13-11-6.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import "AnalyticsViewController.h"

#import "LoginViewController.h"
#import "GameViewController.h"

@interface AnalyticsViewController ()

@end

@implementation AnalyticsViewController

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
    
    //用户
    User *player = [LoginViewController getPlayer];
    //用户名
    NSString *userName = player.userName;
    self.userNameField.text = [NSString stringWithFormat:@"用户名:\t%@",userName];
    //游戏得分
    int s = [GameViewController getScore];
    self.scoreField.text = [NSString stringWithFormat:@"分数:\t%i",s];
    //游戏时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    self.timeField.text = [NSString stringWithFormat:@"时间:\t%@",date];
    /* 修改数据库中用户信息 */
    // 若打破记录，则更新数据库中用户信息
    if ([GameViewController getScore] > [player.gameScore intValue]) {
        User *user = [User MR_findFirstByAttribute:@"userName" withValue:player.userName];
        user.gameScore = [NSNumber numberWithInt:[GameViewController getScore]];
        user.gameTime = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
