//
//  LoginViewController.h
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "User.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *logoImg;
@property (weak, nonatomic) IBOutlet UITextField *userNameText;
@property (weak, nonatomic) IBOutlet UITextField *userPsdText;
- (IBAction)doBtnReg:(id)sender;
- (IBAction)doBtnLoginReset:(id)sender;
- (IBAction)doBtnLogin:(id)sender;
- (IBAction)doBtnToTop:(id)sender;
+ (BOOL)isExistsUser:(NSString *)userName;
+ (BOOL)isTruePsd:(NSString *)userPsd ForUser:(NSString *)userName;
+ (BOOL)isTrueForNameFormat:(NSString *)userName;
+ (User *)getPlayer;

@end
