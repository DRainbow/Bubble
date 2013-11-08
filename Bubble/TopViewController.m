//
//  TopViewController.m
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import "TopViewController.h"

#import "User.h"
#import "LoginViewController.h"
#import "GameViewController.h"

@interface TopViewController ()

@end

@implementation TopViewController

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
    
    //tableview代理设置
    self.topView.dataSource = self;
    self.topView.delegate = self;
    
    //初始化tableview数据
    self.dataList = [[NSMutableArray alloc] initWithArray:[User MR_findAllSortedBy:@"gameScore" ascending:NO]];
//    for (User *u in self.dataList) {
//        NSLog(@"----%@----",u.userName);
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回tableview中有多少section
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//返回rowCount
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

//初始化cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellWithIdentifier];
    }
    NSUInteger row = [indexPath row];
    //显示用户名、分数、时间
    
    User *showUser = (User *)[self.dataList objectAtIndex:row];
    NSString *showName = showUser.userName;
    NSString *showScore = [NSString stringWithFormat:@"%@",showUser.gameScore];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *showTime = [NSString stringWithFormat:@"%@",[formatter stringFromDate:showUser.gameTime]];
    NSString *showStr = [[showName stringByAppendingFormat:@"\t分数:%@",showScore] stringByAppendingFormat:@"\t时间:%@",showTime];
    cell.textLabel.text = showStr;
    //显示排名
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i",row+1];
    return cell;
}

//设置cell可删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    //删除数据库中该行元素的对应记录
    NSArray *deleUsers = [User MR_findByAttribute:@"userName" withValue:((User *)[self.dataList objectAtIndex:indexPath.row]).userName];
    User *deleUser = [deleUsers objectAtIndex:0];
    [deleUser MR_deleteEntity];
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    //删除数组中的该行元素
    [self.dataList removeObjectAtIndex:indexPath.row];
    //删除师徒中的该行元素
    [self.topView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (IBAction)doBtnToGame:(id)sender {
    if ([LoginViewController getPlayer] == NULL) {  //用户未登录
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"请先登录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //跳转至登录界面
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginController = [mainStory instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginController animated:YES completion:nil];
    } else {
        //跳转至游戏界面
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GameViewController *gameController = [mainStory instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self presentViewController:gameController animated:YES completion:nil];
    }
}
@end
