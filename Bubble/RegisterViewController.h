//
//  RegisterViewController.h
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameField;
@property (weak, nonatomic) IBOutlet UITextField *userPsdField;
@property (weak, nonatomic) IBOutlet UITextField *rePsdField;
@property (weak, nonatomic) IBOutlet UITextField *userMailField;
- (IBAction)doBtnRegist:(id)sender;
- (IBAction)doBtnRegReset:(id)sender;
- (IBAction)doBtnToLogin:(id)sender;
- (void)checkUserNameFormat;
- (void)checkRePsd;
- (void)checkUserMailFormat;
+ (BOOL)isTrueFormatForMail:(NSString *)mail;

@end
