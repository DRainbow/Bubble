//
//  GameViewController.h
//  Bubble
//
//  Created by apple on 13-11-5.
//  Copyright (c) 2013年 tyq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController
@property (strong, nonatomic) NSTimer *aniTimer;
@property (strong, nonatomic) NSTimer *timerCount;

@property (strong, nonatomic) NSMutableArray *bubbleArr;
@property (strong, nonatomic) NSMutableArray *xDirectionArr;
@property (strong, nonatomic) NSMutableArray *xChangeArr;
@property (strong, nonatomic) NSMutableArray *yChangeArr;

@property (weak, nonatomic) IBOutlet UIButton *startBtn;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
- (IBAction)doBtnStart:(id)sender;
- (IBAction)singleTap:(id)sender;
+ (int)getScore;

@end
