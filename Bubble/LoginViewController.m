//
//  LoginViewController.m
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import "LoginViewController.h"

#import "User.h"
#import "GameViewController.h"

static User *player;

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    
    //指定文本框的代理
    self.userNameText.delegate = self;
    self.userPsdText.delegate = self;
    
    //密码输入框要隐藏输入字符
    self.userPsdText.secureTextEntry = TRUE;
    
//    User *newUser = [User MR_createEntity];
//    newUser.userName = @"jack";
//    newUser.userPsd = @"123";
//    newUser.userMail = @"jack@qq.com";
//    newUser.gameScore = @16;
//    newUser.gameTime = [NSDate date];
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//    
//    newUser = [User MR_createEntity];
//    newUser.userName = @"tom";
//    newUser.userPsd = @"123";
//    newUser.userMail = @"123@163.com";
//    newUser.gameScore = @13;
//    newUser.gameTime = [NSDate date];
//    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
//
//    NSArray *users = [User MR_findAll];
//    for (User *u in users) {
//        NSLog(@"---%@---",u.userName);
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//注册按钮
- (void)doBtnReg:(id)sender {
}

//重置按钮
- (IBAction)doBtnLoginReset:(id)sender {
    //清空userName、userPsd文本框
    self.userNameText.text = @"";
    self.userPsdText.text = @"";    
}

//登陆按钮
- (IBAction)doBtnLogin:(id)sender {
    //取出用户输入的用户名、密码
    NSString *userName = [self.userNameText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *userPsd = [self.userPsdText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    //登陆验证
    UIAlertView *alert;
    if(userName.length == 0 || userPsd.length == 0) {       //用户名或密码为空
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名或密码为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    } else if (![LoginViewController isTrueForNameFormat:userName]) {        //用户名格式判断（字母开头，允许5-16字节，允许字母数字下划线）
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名格式错误(字母开头，允许3-10字节，允许字母数字下划线)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    } else if(![LoginViewController isExistsUser:userName]) {     //用户名错误
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名不存在" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    } else if(![LoginViewController isTruePsd:userPsd ForUser:userName]) {       //密码错误
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"密码错误" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    } else {        //登陆成功
        alert = [[UIAlertView alloc] initWithTitle:nil message:@"登陆成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        player = [User MR_findFirstByAttribute:@"userName" withValue:userName];
        //跳转至游戏界面
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GameViewController *gameController = [mainStory instantiateViewControllerWithIdentifier:@"GameViewController"];
        [self presentViewController:gameController animated:YES completion:nil];
    }
    [alert show];
}

//查看排行榜按钮
- (IBAction)doBtnToTop:(id)sender {
}

//点击view其他区域隐藏软键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameText resignFirstResponder];
    [self.userPsdText resignFirstResponder];
}

//判断用户名是否存在
+ (BOOL)isExistsUser:(NSString *)userName {
    BOOL returnValue = NO;
    //查找数据库中所有users
    NSArray *users = [User MR_findAll];
    //遍历users，判断用户名是否存在
    for (User *u in users) {
        if ([u.userName isEqualToString:userName]) {
            returnValue = YES;
            break;
        }
    }
    return returnValue;
}

//匹配用户名、密码是否正确
+ (BOOL)isTruePsd:(NSString *)userPsd ForUser:(NSString *)userName {
    BOOL returnValue = NO;
    //查找数据库中user的记录
    NSArray *user = [User MR_findByAttribute:@"userName" withValue:userName];
    //判断输入密码与数据库中密码是否匹配
    if ([userPsd isEqualToString:((User *)[user objectAtIndex:0]).userPsd]) {
        returnValue = YES;
    }
    return returnValue;
}

//正则表达式判断用户名格式
+ (BOOL)isTrueForNameFormat:(NSString *)userName {
    //字母开头，允许3-10字节，允许字母数字下划线
    NSString *userPattern = @"^[a-zA-Z][a-zA-Z0-9_]{2,9}$";
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:userPattern options:0 error:&error];
    //根据正则表达式匹配用户名
    NSArray *matches =  [regex matchesInString:userName options:NSMatchingCompleted range:NSMakeRange(0, [userName length])];
    Boolean returnValue;
    //若输入用户名全匹配正则表达式，则matches长度为1，否则长度为0，即输入用户名格式不正确
    if(matches.count == 1) {
        returnValue = TRUE;
    } else {
        returnValue = FALSE;
    }
    return returnValue;
}

//键盘调出时将输入框覆盖
//当准备输入时，将视图的位置上调50
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.userPsdText) {
        [self.view setFrame:CGRectMake(0, -50,320, 480) ];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.userPsdText) {
        [self.view setFrame:CGRectMake(0, 0,320, 480) ];
    }
    return YES;
}

+ (User *)getPlayer {
    return player;
}

@end
