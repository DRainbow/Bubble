//
//  RegisterViewController.m
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import "RegisterViewController.h"

#import "LoginViewController.h"
#import "User.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

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
    self.userNameField.delegate = self;
    self.userPsdField.delegate = self;
    self.rePsdField.delegate = self;
    self.userMailField.delegate = self;
    
    //userName UITextField失去焦点 判断userName格式
    [self.userNameField addTarget:self action:@selector(checkUserNameFormat) forControlEvents:UIControlEventEditingDidEnd];
    
    //rePsd UITextField失去焦点 判断两次密码是否一致
    [self.rePsdField addTarget:self action:@selector(checkRePsd) forControlEvents:UIControlEventEditingDidEnd];
    
    //userMail UITextField失去焦点 判断邮箱地址格式
    [self.userMailField addTarget:self action:@selector(checkUserMailFormat) forControlEvents:UIControlEventEditingDidEnd];
    
    //密码输入框要隐藏输入字符
//    self.userPsdField.secureTextEntry = TRUE;
//    self.rePsdField.secureTextEntry = TRUE;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//注册按钮
- (IBAction)doBtnRegist:(id)sender {
    NSString *newUserName = self.userNameField.text;
    NSString *newUserPsd = self.userPsdField.text;
    NSString *newRePsd = self.rePsdField.text;
    NSString *newUserMail = self.userMailField.text;
    //所有注册信息不为空，即在数据库中添加记录，并跳转至登陆界面
    if (newUserName.length == 0 || newUserPsd.length == 0 || newRePsd.length == 0 || newUserMail.length ==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册信息不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        //数据库中添加新用户的记录
        User *newUser = [User MR_createEntity];
        newUser.userName = newUserName;
        newUser.userPsd = newUserPsd;
        newUser.userMail = newUserMail;
        newUser.gameScore = @0;
        newUser.gameTime = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        //提示注册成功信息
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"注册成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        //跳转界面至登陆
        UIStoryboard *mainStory = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginViewController *loginController = [mainStory instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self presentViewController:loginController animated:YES completion:nil];
    }
}

//重置按钮
- (IBAction)doBtnRegReset:(id)sender {
    self.userNameField.text = @"";
    self.userPsdField.text = @"";
    self.rePsdField.text = @"";
    self.userMailField.text = @"";
}

//返回登陆界面按钮
- (IBAction)doBtnToLogin:(id)sender {
}

//点击view其他区域隐藏软键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.userNameField resignFirstResponder];
    [self.userPsdField resignFirstResponder];
    [self.rePsdField resignFirstResponder];
    [self.userMailField resignFirstResponder];
}

//判断用户名格式是否正确 & 判断用户名是否已存在
- (void)checkUserNameFormat {
    NSString *userName = self.userNameField.text;
    if (![LoginViewController isTrueForNameFormat:userName]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名格式错误(字母开头，允许3-10字节，允许字母数字下划线)" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        self.userNameField.text = @"";
    }
    NSArray *user = [User MR_findByAttribute:@"userName" withValue:userName];
    if (user.count > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户名已存在" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        self.userNameField.text = @"";
    }
}

//判断两次输入密码是否一致
- (void)checkRePsd {
    NSString *userPsd = self.userPsdField.text;
    NSString *rePsd = self.rePsdField.text;
    if (![userPsd isEqualToString:rePsd]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"两次输入密码不一致" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        self.rePsdField.text = @"";
    }
}

//判断邮箱地址格式
- (void)checkUserMailFormat {
    NSString *userMail = self.userMailField.text;
    if (![RegisterViewController isTrueFormatForMail:userMail]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"邮箱地址格式不正确" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        self.userMailField.text = @"";
    }
}

//正则表达式匹配邮箱地址格式
+ (BOOL)isTrueFormatForMail:(NSString *)mail {
    //匹配Email地址的正则表达式
    NSString *mailPattern = @"^[a-zA-Z0-9_]+([-+.][a-zA-Z0-9_]+)*@[a-zA-Z0-9_]+([-.][a-zA-Z0-9_]+)*[.][a-zA-Z0-9_]+([-.][a-zA-Z0-9_]+)*$";
    //NSRegularExpression类里面调用表达的方法需要传递一个NSError的参数。
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:mailPattern options:0 error:&error];
    //根据正则表达式匹配用户名
    NSArray *matches =  [regex matchesInString:mail options:NSMatchingCompleted range:NSMakeRange(0, [mail length])];
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
//当准备输入时，将视图的位置上调60
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.userMailField) {
        [self.view setFrame:CGRectMake(0, -60,320, 480) ];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == self.userMailField) {
        [self.view setFrame:CGRectMake(0, 0,320, 480) ];
    }
    return YES;
}

@end
